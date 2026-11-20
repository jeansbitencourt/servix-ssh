import 'dart:async';
import 'dart:io';

import 'package:dartssh2/dartssh2.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:servix/core/errors/exceptions.dart';
import 'package:servix/data/datasources/local_database.dart';
import 'package:servix/data/datasources/secure_storage_datasource.dart';
import 'package:servix/data/datasources/ssh_connection_factory.dart';
import 'package:servix/data/datasources/ssh_host_key_store.dart';
import 'package:servix/data/datasources/ssh_tunnel_datasource.dart';
import 'package:servix/data/repositories/host_repository_impl.dart';
import 'package:servix/domain/entities/ssh_host.dart';
import 'package:servix/domain/entities/ssh_host_key.dart' hide SSHHostKey;
import 'package:servix/domain/entities/ssh_tunnel.dart';
import 'package:servix/domain/entities/tunnel_session.dart';

void main() {
  late AppDatabase db;
  late _Factory factory;
  late SSHTunnel config;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    final hosts = HostRepositoryImpl(db, SecureStorageDatasource());
    factory = _Factory(hosts, SSHHostKeyStore(db), _Confirmation());
    final now = DateTime.now();
    await hosts.saveHost(
      SSHHost(
        id: 'host',
        name: 'Test host',
        host: 'example.test',
        username: 'test',
        authType: SSHAuthType.password,
        createdAt: now,
        updatedAt: now,
      ),
    );
    final listener = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
    config = SSHTunnel(
      id: 'tunnel',
      name: 'Test tunnel',
      hostId: 'host',
      localPort: listener.port,
      remoteHost: 'destination.test',
      remotePort: 3306,
      autoReconnect: true,
      createdAt: now,
      updatedAt: now,
    );
    await listener.close();
  });
  tearDown(() => db.close());

  test('Reopens listener on SSH loss and releases it on shutdown', () async {
    final runtime = SSHTunnelDatasource(
      factory.hosts,
      factory,
      reconnectDelay: const Duration(milliseconds: 25),
    );
    addTearDown(runtime.shutdown);
    await runtime.start(config);
    expect(factory.clients.length, 1);
    final reconnected = runtime.sessions
        .map((event) => event.$2.status)
        .take(2)
        .toList()
        .timeout(const Duration(seconds: 3));
    await factory.clients.single.close();
    expect(await reconnected, [
      TunnelStatus.reconnecting,
      TunnelStatus.connected,
    ]);
    expect(factory.clients.length, 2);
    await runtime.shutdown();
    expect(factory.clients.last.isClosed, isTrue);
    await (await ServerSocket.bind(
      InternetAddress.loopbackIPv4,
      config.localPort,
    )).close();
  });

  test('Manual stop cancels backoff and in-flight connection', () async {
    final runtime = SSHTunnelDatasource(
      factory.hosts,
      factory,
      reconnectDelay: const Duration(seconds: 10),
    );
    addTearDown(runtime.shutdown);
    await runtime.start(config);
    final reconnecting = runtime.sessions.firstWhere(
      (event) => event.$2.status == TunnelStatus.reconnecting,
    );
    await factory.clients.single.close();
    await reconnecting.timeout(const Duration(seconds: 3));
    await runtime.stop(config.id).timeout(const Duration(seconds: 1));
    expect(factory.clients.length, 1);

    factory.pending = Completer<void>();
    final starting = runtime.start(config);
    await factory.pending!.future;
    await runtime.stop(config.id).timeout(const Duration(seconds: 1));
    await starting;
    await runtime.stop(config.id);
    expect(factory.clients.length, 1);
    await (await ServerSocket.bind(
      InternetAddress.loopbackIPv4,
      config.localPort,
    )).close();
  });

  for (final (error, issue) in [
    (
      SSHHostKeyException(SSHHostKeyIssue.rejected),
      TunnelIssue.hostKeyRejected,
    ),
    (SSHHostKeyException(SSHHostKeyIssue.changed), TunnelIssue.hostKeyChanged),
    (SSHHostKeyException(SSHHostKeyIssue.storage), TunnelIssue.hostKeyStorage),
    (
      SSHAuthenticationException('Invalid credentials'),
      TunnelIssue.authentication,
    ),
  ]) {
    test('${issue.name} stops automatic reconnection', () async {
      factory.failure = error;
      final runtime = SSHTunnelDatasource(
        factory.hosts,
        factory,
        reconnectDelay: Duration.zero,
      );
      addTearDown(runtime.shutdown);
      final failed = runtime.sessions.firstWhere(
        (event) => event.$2.status == TunnelStatus.error,
      );
      await runtime.start(config);
      expect((await failed).$2.issue, issue);
      expect(factory.attempts, 1);
      expect(runtime.isRunning(config.id), isFalse);
    });
  }
}

class _Factory extends SSHConnectionFactory {
  _Factory(
    this.hosts,
    SSHHostKeyStore keys,
    SSHHostKeyConfirmation confirmation,
  ) : super(hosts, keys, confirmation);

  final HostRepositoryImpl hosts;
  final clients = <_Client>[];
  AppException? failure;
  Completer<void>? pending;
  int attempts = 0;

  @override
  Future<SSHClient> connect(
    SSHHost host, {
    String? password,
    String? passphrase,
    Duration timeout = const Duration(seconds: 15),
    SSHConnectionCancellation? cancellation,
  }) async {
    attempts++;
    if (failure != null) throw failure!;
    if (pending != null) {
      pending!.complete();
      await cancellation!.cancelled;
      throw SSHConnectionException('Cancelled');
    }
    final client = _Client();
    clients.add(client);
    return client;
  }
}

class _Client implements SSHClient {
  final _done = Completer<void>();

  @override
  Future<void> get done => _done.future;

  @override
  bool get isClosed => _done.isCompleted;

  @override
  Future<void> close() async {
    if (!isClosed) _done.complete();
  }

  @override
  Future<void> ping() async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Confirmation implements SSHHostKeyConfirmation {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
