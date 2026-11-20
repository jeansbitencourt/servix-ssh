import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter_test/flutter_test.dart';
import 'package:servix/data/datasources/local_database.dart';
import 'package:servix/data/datasources/secure_storage_datasource.dart';
import 'package:servix/data/datasources/ssh_connection_factory.dart';
import 'package:servix/data/datasources/ssh_host_key_store.dart';
import 'package:servix/data/datasources/ssh_remote_datasource.dart';
import 'package:servix/data/datasources/ssh_tunnel_datasource.dart';
import 'package:servix/data/repositories/host_repository_impl.dart';
import 'package:servix/domain/entities/ssh_host.dart';
import 'package:servix/domain/entities/ssh_host_key.dart';
import 'package:servix/domain/entities/ssh_tunnel.dart';
import 'package:servix/domain/entities/terminal_session.dart';
import 'package:servix/domain/entities/tunnel_session.dart';

void main() {
  final enabled =
      const bool.fromEnvironment('SERVIX_OPENSSH_TESTS') ||
      Platform.environment['SERVIX_OPENSSH_TESTS'] == '1';
  test(
    'OpenSSH verifies commands, terminals and TCP tunnels, including rotation',
    () async {
      final server = await _OpenSSH.create();
      addTearDown(server.dispose);
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final credentials = _TestCredentials();
      final hosts = HostRepositoryImpl(database, credentials);
      final keyStore = SSHHostKeyStore(database);
      final consent = _Consent();
      final factory = SSHConnectionFactory(hosts, keyStore, consent);
      final ssh = SSHRemoteDatasource(factory);
      final runtime = SSHTunnelDatasource(hosts, factory);
      addTearDown(runtime.shutdown);

      final host = _host(server);
      await hosts.saveHost(host);
      consent.answer = false;
      await expectLater(
        ssh.runCommand(host, "printf 'unsafe'"),
        throwsA(
          isA<SSHHostKeyException>().having(
            (error) => error.issue,
            'issue',
            SSHHostKeyIssue.rejected,
          ),
        ),
      );
      final presented = consent.lastKey!;
      expect(presented.fingerprint, startsWith('SHA256:'));
      expect(presented.algorithm, 'ssh-ed25519');
      expect(await keyStore.read(presented), isNull);
      final rejectedShell = await ssh.createInteractiveShell(host);
      expect(rejectedShell.status, TerminalSessionStatus.error);
      expect(consent.prompts, 2);

      final config = SSHTunnel(
        id: 'tunnel',
        name: 'Echo',
        hostId: host.id,
        localPort: await _freePort(),
        remoteHost: '127.0.0.1',
        remotePort: await _freePort(),
        autoReconnect: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final rejected = _next(
        runtime,
        (session) => session.issue == TunnelIssue.hostKeyRejected,
      );
      await runtime.start(config);
      await rejected;
      expect(consent.prompts, 3);
      expect(await keyStore.read(presented), isNull);

      consent.answer = true;
      credentials.passphrase = 'fixture-passphrase';
      final encryptedKeyHost = host.copyWith(
        keyFilePath: '${server.directory.path}/encrypted',
      );
      expect(await ssh.testConnection(encryptedKeyHost), isTrue);
      credentials.passphrase = null;
      expect(consent.prompts, 4);
      expect(
        (await keyStore.read(presented))?.fingerprint,
        presented.fingerprint,
      );
      final command = await ssh.runCommand(host, "printf 'trusted'");
      expect(command.stdout, 'trusted');
      expect(consent.prompts, 4);
      final terminal = await ssh.createInteractiveShell(host);
      expect(terminal.status, TerminalSessionStatus.connected);

      final target = await ServerSocket.bind(
        InternetAddress.loopbackIPv4,
        config.remotePort,
      );
      addTearDown(target.close);
      final targetConnections = <Socket>{};
      addTearDown(() {
        for (final socket in targetConnections) {
          socket.destroy();
        }
      });
      final targetClosedFirst = Completer<Uint8List>();
      var closeFromTarget = false;
      target.listen((socket) async {
        targetConnections.add(socket);
        if (closeFromTarget) {
          try {
            final upload = socket.fold(
              BytesBuilder(copy: false),
              (buffer, bytes) => buffer..add(bytes),
            );
            socket.add([0, 128, 255]);
            await socket.close();
            targetClosedFirst.complete((await upload).takeBytes());
          } finally {
            socket.destroy();
            targetConnections.remove(socket);
          }
          return;
        }
        // Reply only once the client has half-closed its upload.
        final data = BytesBuilder(copy: false);
        try {
          await for (final bytes in socket) {
            data.add(bytes);
          }
          socket.add(data.takeBytes());
          await socket.flush();
          await socket.close();
        } catch (_) {
          socket.destroy();
          rethrow;
        } finally {
          targetConnections.remove(socket);
        }
      });

      final started = _next(
        runtime,
        (session) => session.status == TunnelStatus.connected,
      );
      await runtime.start(config);
      await started;
      terminal.close();

      final count = _next(runtime, (session) => session.connections == 2);
      final clients = await Future.wait(
        List.generate(2, (_) => Socket.connect('127.0.0.1', config.localPort)),
      );
      addTearDown(() {
        for (final client in clients) {
          client.destroy();
        }
      });
      await count;
      await Future.wait(
        clients.indexed.map((pair) async {
          final (index, socket) = pair;
          // Larger than a channel window to exercise concurrent binary flow.
          final payload = Uint8List.fromList(
            List.generate(2500000, (i) => (i + index) % 256),
          );
          final response = BytesBuilder(copy: false);
          final received = socket.forEach(response.add);
          socket.add(payload);
          await socket.flush();
          await socket.close();
          await received.timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw StateError('Received ${response.length} bytes without EOF');
            },
          );
          expect(listEquals(response.takeBytes(), payload), isTrue);
        }),
      );
      closeFromTarget = true;
      final halfClosed = await Socket.connect('127.0.0.1', config.localPort);
      addTearDown(halfClosed.destroy);
      final greeting = await halfClosed
          .fold(
            BytesBuilder(copy: false),
            (buffer, bytes) => buffer..add(bytes),
          )
          .timeout(const Duration(seconds: 10));
      expect(greeting.takeBytes(), [0, 128, 255]);
      halfClosed.add([255, 128, 0]);
      await halfClosed.close();
      expect(
        await targetClosedFirst.future.timeout(const Duration(seconds: 10)),
        [255, 128, 0],
      );

      final conflict = _next(
        runtime,
        (session) => session.issue == TunnelIssue.localPortInUse,
      );
      await runtime.start(
        SSHTunnel(
          id: 'conflict',
          name: 'Conflict',
          hostId: host.id,
          localPort: config.localPort,
          remoteHost: '127.0.0.1',
          remotePort: config.remotePort,
          createdAt: config.createdAt,
          updatedAt: config.updatedAt,
        ),
      );
      await conflict;

      closeFromTarget = false;
      final transferOpened = _next(
        runtime,
        (session) => session.connections == 1,
      );
      final heldClient = await Socket.connect('127.0.0.1', config.localPort);
      addTearDown(heldClient.destroy);
      final heldClientEnded = heldClient.drain<void>();
      await transferOpened;

      await target.close();
      final destinationUnavailable = _next(
        runtime,
        (session) =>
            session.status == TunnelStatus.connected &&
            session.issue == TunnelIssue.destinationUnavailable,
      );
      final unavailableClient = await Socket.connect(
        '127.0.0.1',
        config.localPort,
      );
      addTearDown(unavailableClient.destroy);
      await destinationUnavailable;
      await unavailableClient.drain<void>();

      final stopped = _next(
        runtime,
        (session) => session.status == TunnelStatus.disconnected,
      );
      await runtime.stop(config.id);
      await stopped;
      await heldClientEnded.timeout(const Duration(seconds: 10));
      await (await ServerSocket.bind(
        InternetAddress.loopbackIPv4,
        config.localPort,
      )).close();

      await server.restartWithOtherKey();
      await expectLater(
        ssh.testConnection(host),
        throwsA(
          isA<SSHHostKeyException>().having(
            (error) => error.issue,
            'issue',
            SSHHostKeyIssue.changed,
          ),
        ),
      );
      expect(
        consent.presentedChange!.fingerprint,
        isNot(presented.fingerprint),
      );
      expect(
        (await keyStore.read(presented))?.fingerprint,
        presented.fingerprint,
      );
      await consent.replace!();
      expect(await ssh.testConnection(host), isTrue);
      expect(consent.prompts, 4);

      for (final failRead in [true, false]) {
        final unavailable = SSHRemoteDatasource(
          SSHConnectionFactory(
            hosts,
            _UnavailableKeyStore(database, failRead: failRead),
            consent,
          ),
        );
        await expectLater(
          unavailable.testConnection(host),
          throwsA(
            isA<SSHHostKeyException>().having(
              (error) => error.issue,
              'issue',
              SSHHostKeyIssue.storage,
            ),
          ),
        );
        expect(consent.prompts, 4);
      }
    },
    skip: enabled
        ? false
        : 'Set SERVIX_OPENSSH_TESTS=1 with OpenSSH installed.',
    timeout: const Timeout(Duration(minutes: 2)),
  );
}

Future<TunnelSession> _next(
  SSHTunnelDatasource runtime,
  bool Function(TunnelSession) check,
) => runtime.sessions
    .map((event) => event.$2)
    .firstWhere(check)
    .timeout(const Duration(seconds: 15));

Future<int> _freePort() async {
  final socket = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
  final port = socket.port;
  await socket.close();
  return port;
}

SSHHost _host(_OpenSSH server) => SSHHost(
  id: 'host',
  name: 'Test OpenSSH',
  host: '127.0.0.1',
  port: server.port,
  username: Platform.environment['USER']!,
  authType: SSHAuthType.privateKey,
  keyFilePath: '${server.directory.path}/client',
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);

class _UnavailableKeyStore extends SSHHostKeyStore {
  _UnavailableKeyStore(super.database, {required this.failRead});

  final bool failRead;

  @override
  Future<TrustedHostKeyEntry?> read(SSHHostKey key) {
    if (failRead) throw StateError('Trust storage unavailable');
    return super.read(key);
  }

  @override
  Future<bool> record(
    SSHHostKey key,
    TrustedHostKeyEntry? expected, {
    required bool Function() isCurrent,
  }) async => throw StateError('Trust storage unavailable');
}

class _TestCredentials extends SecureStorageDatasource {
  @override
  Future<String?> getPassphrase(String hostId) async => passphrase;

  String? passphrase;
}

class _Consent implements SSHHostKeyConfirmation {
  bool answer = false;
  int prompts = 0;
  SSHHostKey? lastKey;
  SSHHostKey? presentedChange;
  Future<void> Function()? replace;

  @override
  Future<bool> trust(SSHHostKey key, Future<void> connectionEnded) async {
    lastKey = key;
    prompts++;
    return answer;
  }

  @override
  Future<void> changed(
    SSHHostKey previous,
    SSHHostKey presented,
    Future<void> Function() replace,
  ) async {
    presentedChange = presented;
    this.replace = replace;
  }

  @override
  void rekeyRejected(String endpoint, String previous, String presented) {}
}

class _OpenSSH {
  _OpenSSH(this.directory, this.port);

  final Directory directory;
  final int port;
  Process? _process;

  static Future<_OpenSSH> create() async {
    final directory = await Directory.systemTemp.createTemp('servix-openssh-');
    final fixture = _OpenSSH(directory, await _freePort());
    try {
      await fixture._key('host');
      await fixture._key('rotated');
      await fixture._key('client');
      await fixture._key('encrypted', passphrase: 'fixture-passphrase');
      final path = directory.path;
      final plain = await File('$path/client.pub').readAsString();
      final encrypted = await File('$path/encrypted.pub').readAsString();
      await File('$path/authorized_keys').writeAsString('$plain$encrypted');
      await fixture._start('host');
      return fixture;
    } catch (_) {
      await fixture.dispose();
      rethrow;
    }
  }

  Future<void> _key(String name, {String passphrase = ''}) async {
    final result = await Process.run('ssh-keygen', [
      '-q',
      '-t',
      'ed25519',
      '-N',
      passphrase,
      '-f',
      '${directory.path}/$name',
    ]);
    if (result.exitCode != 0) throw StateError(result.stderr.toString());
  }

  Future<void> _start(String key) async {
    final path = directory.path;
    final config = File('$path/sshd_config');
    await config.writeAsString('''
ListenAddress 127.0.0.1
Port $port
HostKey $path/$key
PidFile $path/sshd.pid
AuthorizedKeysFile $path/authorized_keys
UsePAM no
StrictModes no
AllowTcpForwarding local
PasswordAuthentication no
KbdInteractiveAuthentication no
PrintMotd no
''');
    final process = _process = await Process.start(
      Platform.environment['SERVIX_SSHD'] ?? '/usr/bin/sshd',
      ['-D', '-e', '-f', config.path],
    );
    unawaited(process.stdout.drain<void>());
    final ready = Completer<void>();
    final errors = StringBuffer();
    process.stderr
        .transform(utf8.decoder)
        .listen(
          (data) {
            errors.write(data);
            if (!ready.isCompleted &&
                errors.toString().contains('Server listening')) {
              ready.complete();
            }
          },
          onDone: () {
            if (!ready.isCompleted) {
              ready.completeError(StateError(errors.toString()));
            }
          },
        );
    await ready.future.timeout(const Duration(seconds: 5));
  }

  Future<void> restartWithOtherKey() async {
    await _stop();
    await _start('rotated');
  }

  Future<void> _stop() async {
    final process = _process;
    if (process == null) return;
    process.kill();
    await process.exitCode;
    _process = null;
  }

  Future<void> dispose() async {
    await _stop();
    await directory.delete(recursive: true);
  }
}
