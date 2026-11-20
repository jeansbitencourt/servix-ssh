import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:servix/core/errors/exceptions.dart';
import 'package:servix/data/datasources/local_database.dart';
import 'package:servix/data/datasources/secure_storage_datasource.dart';
import 'package:servix/data/datasources/ssh_connection_factory.dart';
import 'package:servix/data/datasources/ssh_host_key_store.dart';
import 'package:servix/data/datasources/ssh_tunnel_datasource.dart';
import 'package:servix/data/repositories/host_repository_impl.dart';
import 'package:servix/data/repositories/tunnel_repository_impl.dart';
import 'package:servix/domain/entities/ssh_host_key.dart';
import 'package:servix/domain/entities/ssh_tunnel.dart';

void main() {
  test(
    'Normalizes DNS and IP literals without merging DNS and IP endpoints',
    () {
      expect(normalizeSSHHostname(' SSH.example.com. '), 'ssh.example.com');
      expect(normalizeSSHHostname('[2001:0db8::0001]'), '2001:db8::1');
      expect(normalizeSSHHostname('[fe80::1%Eth0]'), 'fe80::1%Eth0');
      expect(normalizeSSHHostname('127.0.0.1'), '127.0.0.1');
      expect(normalizeSSHHostname('localhost'), 'localhost');
    },
  );

  test('Migrates v1, preserves data and persists endpoint trust and tunnel configuration', () async {
    final directory = await Directory.systemTemp.createTemp('servix-test-db-');
    addTearDown(() => directory.delete(recursive: true));
    final file = File('${directory.path}/servix.sqlite');
    final original = AppDatabase(NativeDatabase(file));
    final now = DateTime.utc(2026, 11, 19);
    await original
        .into(original.hostsTable)
        .insert(
          HostEntry(
            id: 'ssh-server',
            name: 'Server',
            host: 'example.com',
            port: 22,
            username: 'operator',
            authType: 'password',
            groupName: 'Test',
            createdAt: now,
            updatedAt: now,
          ),
        );
    await original
        .into(original.shortcutCommandsTable)
        .insert(
          ShortcutEntry(
            id: 'shortcut',
            hostId: 'ssh-server',
            name: 'Uptime',
            command: 'uptime',
            timeoutSeconds: 30,
            category: 'Test',
            createdAt: now,
          ),
        );
    await original
        .into(original.executionHistoryTable)
        .insert(
          ExecutionHistoryEntry(
            id: 'execution',
            hostId: 'ssh-server',
            shortcutId: 'shortcut',
            command: 'uptime',
            exitCode: 0,
            stdout: 'output',
            stderr: '',
            durationMs: 3,
            executedAt: now,
          ),
        );
    // Restore the exact v1 schema, which consists of the original three tables.
    await original.customStatement('DROP TABLE tunnels_table');
    await original.customStatement('DROP TABLE trusted_host_keys_table');
    await original.customStatement('PRAGMA user_version = 1');
    await original.close();

    final migrated = AppDatabase(NativeDatabase(file));
    final migratedKeys = SSHHostKeyStore(migrated);
    final hosts = HostRepositoryImpl(migrated, SecureStorageDatasource());
    final runtime = SSHTunnelDatasource(
      hosts,
      SSHConnectionFactory(hosts, migratedKeys, _Confirmation()),
    );
    final tunnels = TunnelRepositoryImpl(migrated, runtime);
    expect((await hosts.getAllHosts()).single.id, 'ssh-server');
    expect(
      (await migrated.select(migrated.shortcutCommandsTable).getSingle()).id,
      'shortcut',
    );
    expect(
      (await migrated.select(migrated.executionHistoryTable).getSingle())
          .stdout,
      'output',
    );

    final config = SSHTunnel(
      id: 'tunnel-id',
      name: 'Example',
      hostId: 'ssh-server',
      localPort: 3307,
      remoteHost: 'private.example.com',
      remotePort: 3306,
      autoConnect: true,
      autoReconnect: true,
      createdAt: now,
      updatedAt: now,
    );
    await tunnels.save(config);
    await expectLater(
      hosts.deleteHost(config.hostId),
      throwsA(isA<DatabaseException>()),
    );

    const key = SSHHostKey('example.com', 22, 'ssh-ed25519', 'SHA256:old');
    const keyOnOtherPort = SSHHostKey(
      'example.com',
      2222,
      'ssh-ed25519',
      'SHA256:old',
    );
    const rotated = SSHHostKey('example.com', 22, 'ssh-ed25519', 'SHA256:new');
    expect(await migratedKeys.read(key), isNull);
    expect(
      await migratedKeys.record(key, null, isCurrent: () => false),
      isFalse,
    );
    expect(await migratedKeys.record(key, null, isCurrent: () => true), isTrue);
    final initialRecord = await migratedKeys.read(key);
    expect(await migratedKeys.read(keyOnOtherPort), isNull);
    expect(
      await migratedKeys.record(rotated, null, isCurrent: () => true),
      isFalse,
    );
    expect(
      await migratedKeys.record(rotated, initialRecord, isCurrent: () => true),
      isTrue,
    );
    expect(
      await migratedKeys.record(key, initialRecord, isCurrent: () => true),
      isFalse,
    );
    await runtime.shutdown();
    await migrated.close();

    final restarted = AppDatabase(NativeDatabase(file));
    addTearDown(restarted.close);
    final record = (await SSHHostKeyStore(restarted).read(key))!;
    expect(record.identity.matches(rotated), isTrue);
    expect(record.firstConfirmedAt, isNotNull);
    expect(record.lastVerifiedAt, isNotNull);
    final saved = await restarted.select(restarted.tunnelsTable).getSingle();
    expect(saved.localHost, '127.0.0.1');
    expect(saved.localPort, 3307);
    expect(saved.remoteHost, 'private.example.com');
    expect(saved.remotePort, 3306);
    expect(saved.autoConnect, isTrue);
    expect(saved.autoReconnect, isTrue);
  });
}

class _Confirmation implements SSHHostKeyConfirmation {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
