import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dartssh2/dartssh2.dart' hide SSHHostKey;

import '../../core/errors/exceptions.dart';
import '../../domain/entities/ssh_host.dart';
import '../../domain/entities/ssh_host_key.dart';
import '../../domain/repositories/host_repository.dart';
import '../../l10n/system_localizations.dart';
import 'ssh_host_key_store.dart';

enum SSHHostKeyIssue { rejected, changed, storage }

class SSHHostKeyException extends SSHConnectionException {
  SSHHostKeyException(this.issue)
    : super(switch (issue) {
        SSHHostKeyIssue.rejected => systemLocalizations.hostKeyRejected,
        SSHHostKeyIssue.changed => systemLocalizations.hostKeyChangedError,
        SSHHostKeyIssue.storage => systemLocalizations.hostKeyStorageError,
      });

  final SSHHostKeyIssue issue;
}

class SSHConnectionCancellation {
  final _cancelled = Completer<void>();
  bool get isCancelled => _cancelled.isCompleted;
  Future<void> get cancelled => _cancelled.future;

  void cancel() {
    if (!isCancelled) _cancelled.complete();
  }
}

class SSHConnectionFactory {
  SSHConnectionFactory(this._hosts, this._keys, this._confirmation);

  final HostRepository _hosts;
  final SSHHostKeyStore _keys;
  final SSHHostKeyConfirmation _confirmation;

  Future<SSHClient> connect(
    SSHHost host, {
    String? password,
    String? passphrase,
    Duration timeout = const Duration(seconds: 15),
    SSHConnectionCancellation? cancellation,
  }) {
    final connection = _connect(
      host,
      password,
      passphrase,
      timeout,
      cancellation,
    );
    return cancellation == null
        ? connection
        : Future.any([
            connection,
            cancellation.cancelled.then<SSHClient>((_) {
              throw SSHConnectionException(systemLocalizations.cancel);
            }),
          ]);
  }

  Future<SSHClient> _connect(
    SSHHost host,
    String? password,
    String? passphrase,
    Duration timeout,
    SSHConnectionCancellation? cancellation,
  ) async {
    final ended = Completer<void>();
    SSHSocket? socket;
    SSHClient? client;
    SSHHostKeyException? verificationError;
    Timer? handshakeTimer;
    var accepted = false;
    var handshakeTimedOut = false;
    var awaitingVerification = false;

    void markEnded() {
      if (!ended.isCompleted) ended.complete();
    }

    bool isCurrent() =>
        !ended.isCompleted && !(cancellation?.isCancelled ?? false);

    final endpoint = SSHHostKey(
      normalizeSSHHostname(host.host),
      host.port,
      '',
      '',
    );
    try {
      final credentials = await _loadCredentials(host, password, passphrase)
          .timeout(
            timeout,
            onTimeout: () => throw SSHAuthenticationException(
              systemLocalizations.sshCredentialsUnavailable,
            ),
          );
      if (!isCurrent()) {
        throw SSHConnectionException(systemLocalizations.cancel);
      }

      socket = await SSHSocket.connect(
        sshSocketHostname(host.host),
        host.port,
        timeout: timeout,
      );
      if (!isCurrent()) {
        throw SSHConnectionException(systemLocalizations.cancel);
      }

      void abort() {
        markEnded();
        final current = client;
        if (current != null && !current.isClosed) {
          unawaited(closeSSHClient(current));
        }
      }

      if (cancellation != null) {
        unawaited(cancellation.cancelled.then((_) => abort()));
      }
      handshakeTimer = Timer(timeout, () {
        handshakeTimedOut = true;
        abort();
      });
      client = SSHClient(
        socket,
        username: host.username,
        identities: credentials.identities,
        onPasswordRequest: host.authType == SSHAuthType.password
            ? () => credentials.password ?? ''
            : null,
        handshakeTimeout: const Duration(minutes: 2),
        authTimeout: timeout,
        onVerifyHostKey: (algorithm, bytes) async {
          handshakeTimer?.cancel();
          awaitingVerification = true;
          final key = SSHHostKey(
            endpoint.hostname,
            endpoint.port,
            algorithm,
            utf8.decode(bytes),
          );
          try {
            await _verify(key, ended.future, isCurrent);
            accepted = isCurrent();
            return accepted;
          } on SSHHostKeyException catch (error) {
            verificationError = error;
            return false;
          } finally {
            awaitingVerification = false;
          }
        },
      );
      unawaited(
        client.done.then(
          (_) => markEnded(),
          onError: (Object error, StackTrace _) {
            markEnded();
            if (accepted && error is SSHHostkeyError) {
              final change = RegExp(
                r'^Host key changed during rekey: was (.+), now (.+)$',
              ).firstMatch(error.message);
              _confirmation.rekeyRejected(
                endpoint.endpoint,
                change?.group(1) ?? '',
                change?.group(2) ?? '',
              );
            }
          },
        ),
      );
      await client.authenticated;
      if (!isCurrent()) {
        throw SSHConnectionException(systemLocalizations.cancel);
      }
      return client;
    } catch (error) {
      markEnded();
      if (client == null) {
        socket?.destroy();
      } else {
        await closeSSHClient(client);
      }
      if (verificationError != null) throw verificationError!;
      if (error is AppException) rethrow;
      if (error is SSHHostkeyError ||
          (error is SSHAuthAbortError && error.reason is SSHHostkeyError) ||
          (awaitingVerification && error is SSHHandshakeError)) {
        throw SSHHostKeyException(SSHHostKeyIssue.rejected);
      }
      if (error is SSHAuthFailError ||
          (error is SSHAuthAbortError &&
              error.message == 'Authentication timed out')) {
        throw SSHAuthenticationException(
          systemLocalizations.sshAuthenticationFailed,
        );
      }
      if (handshakeTimedOut ||
          error is TimeoutException ||
          error is SSHHandshakeError) {
        throw SSHConnectionException(
          systemLocalizations.sshConnectionTimedOut(endpoint.endpoint),
        );
      }
      throw SSHConnectionException(
        systemLocalizations.sshServerUnavailable(endpoint.endpoint),
      );
    } finally {
      handshakeTimer?.cancel();
    }
  }

  Future<void> _verify(
    SSHHostKey key,
    Future<void> ended,
    bool Function() isCurrent,
  ) async {
    try {
      final trusted = await _keys.read(key);
      if (!isCurrent()) throw SSHHostKeyException(SSHHostKeyIssue.rejected);
      if (trusted == null) {
        if (!await _confirmation.trust(key, ended) || !isCurrent()) {
          throw SSHHostKeyException(SSHHostKeyIssue.rejected);
        }
      } else if (!key.matches(trusted.identity)) {
        unawaited(
          _confirmation.changed(trusted.identity, key, () async {
            if (!await _keys.record(key, trusted, isCurrent: () => true)) {
              throw SSHHostKeyException(SSHHostKeyIssue.storage);
            }
          }),
        );
        throw SSHHostKeyException(SSHHostKeyIssue.changed);
      }
      if (!await _keys.record(key, trusted, isCurrent: isCurrent)) {
        throw SSHHostKeyException(
          isCurrent() ? SSHHostKeyIssue.storage : SSHHostKeyIssue.rejected,
        );
      }
    } on SSHHostKeyException {
      rethrow;
    } catch (_) {
      throw SSHHostKeyException(SSHHostKeyIssue.storage);
    }
  }

  Future<({String? password, List<SSHKeyPair>? identities})> _loadCredentials(
    SSHHost host,
    String? password,
    String? passphrase,
  ) async {
    final l10n = systemLocalizations;
    try {
      if (host.authType == SSHAuthType.password) {
        return (
          password: password ?? await _hosts.getHostPassword(host.id),
          identities: null,
        );
      }
      final path = host.keyFilePath;
      if (path == null || path.trim().isEmpty) {
        throw SSHAuthenticationException(l10n.missingKeyPath);
      }
      final keyFile = File(path);
      if (!await keyFile.exists()) {
        throw SSHAuthenticationException(l10n.privateKeyNotFound(path));
      }
      final pem = await keyFile.readAsString();
      final secret = passphrase ?? await _hosts.getHostPassphrase(host.id);
      return (password: null, identities: SSHKeyPair.fromPem(pem, secret));
    } on SSHAuthenticationException {
      rethrow;
    } on StorageException {
      throw SSHAuthenticationException(l10n.sshCredentialsUnavailable);
    } catch (_) {
      throw SSHAuthenticationException(l10n.sshPrivateKeyInvalid);
    }
  }
}

Future<void> closeSSHClient(SSHClient client) async {
  try {
    await client.close().timeout(const Duration(seconds: 2));
  } on TimeoutException {
    client.socket.destroy();
  } on SSHError {
    // Transport errors are delivered separately through client.done.
    if (!client.isClosed) rethrow;
  } on SocketException {
    if (!client.isClosed) rethrow;
  }
}
