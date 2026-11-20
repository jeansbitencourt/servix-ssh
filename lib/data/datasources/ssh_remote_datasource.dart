import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dartssh2/dartssh2.dart';
import 'package:uuid/uuid.dart';
import 'package:xterm/xterm.dart';

import '../../core/errors/exceptions.dart';
import '../../domain/entities/command_result.dart';
import '../../domain/entities/ssh_host.dart';
import '../../domain/entities/terminal_session.dart';
import '../../l10n/system_localizations.dart';

class SSHRemoteDatasource {
  final Uuid _uuid;

  SSHRemoteDatasource({Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  Future<SSHClient> _connectClient(
    SSHHost host, {
    String? password,
    String? passphrase,
    Duration timeout = const Duration(seconds: 15),
  }) async {
    try {
      final socket = await SSHSocket.connect(
        host.host,
        host.port,
        timeout: timeout,
      );

      List<SSHKeyPair>? identities;
      if (host.authType == SSHAuthType.privateKey) {
        if (host.keyFilePath == null || host.keyFilePath!.trim().isEmpty) {
          throw SSHAuthenticationException(systemLocalizations.missingKeyPath);
        }

        final keyFile = File(host.keyFilePath!);
        if (!keyFile.existsSync()) {
          throw SSHAuthenticationException(
            systemLocalizations.privateKeyNotFound(keyFile.path),
          );
        }

        final keyPem = await keyFile.readAsString();
        try {
          identities = SSHKeyPair.fromPem(keyPem, passphrase);
        } catch (e) {
          throw SSHAuthenticationException(
            systemLocalizations.privateKeyReadFailed(e.toString()),
            e,
          );
        }
      }

      final client = SSHClient(
        socket,
        username: host.username,
        onPasswordRequest: host.authType == SSHAuthType.password
            ? () => password ?? ''
            : null,
        identities: identities,
      );

      await client.authenticated;
      return client;
    } on SocketException catch (e) {
      throw SSHConnectionException(
        systemLocalizations.sshSocketFailed(
          '${host.host}:${host.port}',
          e.message,
        ),
        e,
      );
    } on TimeoutException catch (e) {
      throw SSHConnectionException(
        systemLocalizations.sshConnectionTimedOut('${host.host}:${host.port}'),
        e,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw SSHConnectionException(
        systemLocalizations.sshConnectionError(host.host, e.toString()),
        e,
      );
    }
  }

  Future<bool> testConnection(
    SSHHost host, {
    String? password,
    String? passphrase,
  }) async {
    SSHClient? client;
    try {
      client = await _connectClient(
        host,
        password: password,
        passphrase: passphrase,
        timeout: const Duration(seconds: 10),
      );
      return true;
    } finally {
      try {
        client?.close();
      } catch (_) {}
    }
  }

  Future<CommandResult> runCommand(
    SSHHost host,
    String command, {
    String? password,
    String? passphrase,
    int timeoutSeconds = 30,
    String? shortcutId,
  }) async {
    SSHClient? client;
    final stopwatch = Stopwatch()..start();

    try {
      client = await _connectClient(
        host,
        password: password,
        passphrase: passphrase,
        timeout: const Duration(seconds: 15),
      );

      final session = await client
          .execute(command)
          .timeout(
            Duration(seconds: timeoutSeconds),
            onTimeout: () => throw SSHExecutionException(
              systemLocalizations.commandTimedOut(timeoutSeconds),
            ),
          );

      final stdoutBuffer = StringBuffer();
      final stderrBuffer = StringBuffer();

      final stdoutFuture = session.stdout.listen((data) {
        stdoutBuffer.write(utf8.decode(data, allowMalformed: true));
      }).asFuture();

      final stderrFuture = session.stderr.listen((data) {
        stderrBuffer.write(utf8.decode(data, allowMalformed: true));
      }).asFuture();

      await Future.wait([stdoutFuture, stderrFuture]);
      await session.done;

      stopwatch.stop();

      final exitCode = session.exitCode ?? 0;

      return CommandResult(
        id: _uuid.v4(),
        hostId: host.id,
        shortcutId: shortcutId,
        command: command,
        exitCode: exitCode,
        stdout: stdoutBuffer.toString(),
        stderr: stderrBuffer.toString(),
        durationMs: stopwatch.elapsedMilliseconds,
        executedAt: DateTime.now(),
      );
    } catch (e) {
      stopwatch.stop();
      if (e is AppException) rethrow;
      throw SSHExecutionException(
        systemLocalizations.sshCommandFailed(e.toString()),
        details: e,
      );
    } finally {
      try {
        client?.close();
      } catch (_) {}
    }
  }

  Future<TerminalSession> createInteractiveShell(
    SSHHost host, {
    String? password,
    String? passphrase,
  }) async {
    final terminal = Terminal(maxLines: 10000);
    final sessionId = _uuid.v4();

    final session = TerminalSession(
      id: sessionId,
      host: host,
      title: '${host.name} (${host.username}@${host.host})',
      terminal: terminal,
      createdAt: DateTime.now(),
      status: TerminalSessionStatus.connecting,
    );

    try {
      terminal.write(
        '${systemLocalizations.terminalConnectingTo('${host.username}@${host.host}:${host.port}')}\r\n',
      );

      final client = await _connectClient(
        host,
        password: password,
        passphrase: passphrase,
        timeout: const Duration(seconds: 15),
      );

      session.client = client;

      final sshSession = await client.shell(
        pty: SSHPtyConfig(
          width: terminal.viewWidth > 0 ? terminal.viewWidth : 80,
          height: terminal.viewHeight > 0 ? terminal.viewHeight : 24,
          type: 'xterm-256color',
        ),
      );

      session.sshSession = sshSession;
      session.status = TerminalSessionStatus.connected;
      terminal.write(
        '\x1b[32m${systemLocalizations.terminalConnectionSucceeded}\x1b[0m\r\n\r\n',
      );

      // Pipe SSH stdout & stderr to Terminal
      sshSession.stdout.listen(
        (data) {
          terminal.write(utf8.decode(data, allowMalformed: true));
        },
        onError: (err) {
          terminal.write(
            '\r\n\x1b[31m${systemLocalizations.terminalReadError(err.toString())}\x1b[0m\r\n',
          );
        },
      );

      sshSession.stderr.listen((data) {
        terminal.write(utf8.decode(data, allowMalformed: true));
      });

      // Pipe Terminal input to SSH
      terminal.onOutput = (output) {
        if (session.status == TerminalSessionStatus.connected) {
          sshSession.write(Uint8List.fromList(utf8.encode(output)));
        }
      };

      // Handle Terminal Resize
      terminal.onResize = (width, height, pixelWidth, pixelHeight) {
        if (session.status == TerminalSessionStatus.connected) {
          sshSession.resizeTerminal(width, height, pixelWidth, pixelHeight);
        }
      };

      // Handle termination
      sshSession.done
          .then((_) {
            session.status = TerminalSessionStatus.disconnected;
            terminal.write(
              '\r\n\x1b[33m${systemLocalizations.remoteSessionClosed}\x1b[0m\r\n',
            );
            try {
              client.close();
            } catch (_) {}
          })
          .catchError((err) {
            session.status = TerminalSessionStatus.error;
            session.errorMessage = err.toString();
            terminal.write(
              '\r\n\x1b[31m${systemLocalizations.terminalDisconnectedWithError(err.toString())}\x1b[0m\r\n',
            );
          });

      return session;
    } catch (e) {
      session.status = TerminalSessionStatus.error;
      session.errorMessage = e.toString();
      terminal.write(
        '\r\n\x1b[31m${systemLocalizations.connectionFailed(e.toString())}\x1b[0m\r\n',
      );
      return session;
    }
  }
}
