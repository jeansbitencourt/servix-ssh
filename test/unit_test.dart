import 'dart:ffi';
import 'package:control_panel/core/utils/date_formatter.dart';
import 'package:control_panel/data/datasources/local_database.dart';
import 'package:control_panel/data/repositories/host_repository_impl.dart';
import 'package:control_panel/data/repositories/shortcut_repository_impl.dart';
import 'package:control_panel/domain/entities/command_result.dart';
import 'package:control_panel/domain/entities/shortcut_command.dart';
import 'package:control_panel/domain/entities/ssh_host.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/open.dart';

// In-memory fake secure storage for test isolation
import 'package:control_panel/data/datasources/secure_storage_datasource.dart';

class FakeSecureStorageDatasource extends SecureStorageDatasource {
  final Map<String, String> _memory = {};

  @override
  Future<void> savePassword(String hostId, String password) async {
    _memory['pwd_$hostId'] = password;
  }

  @override
  Future<String?> getPassword(String hostId) async {
    return _memory['pwd_$hostId'];
  }

  @override
  Future<void> savePassphrase(String hostId, String passphrase) async {
    _memory['passphrase_$hostId'] = passphrase;
  }

  @override
  Future<String?> getPassphrase(String hostId) async {
    return _memory['passphrase_$hostId'];
  }

  @override
  Future<void> deleteAllHostCredentials(String hostId) async {
    _memory.remove('pwd_$hostId');
    _memory.remove('passphrase_$hostId');
  }
}

void main() {
  setUpAll(() {
    open.overrideFor(OperatingSystem.linux, () {
      try {
        return DynamicLibrary.open('libsqlite3.so');
      } catch (_) {
        return DynamicLibrary.open('libsqlite3.so.0');
      }
    });
  });
  group('DateFormatter Tests', () {
    test('formatDuration should format ms and seconds correctly', () {
      expect(DateFormatter.formatDuration(500), '500ms');
      expect(DateFormatter.formatDuration(1500), '1.50s');
      expect(DateFormatter.formatDuration(2340), '2.34s');
    });
  });

  group('Drift & Repository Persistence Tests', () {
    late AppDatabase database;
    late FakeSecureStorageDatasource fakeSecureStorage;
    late HostRepositoryImpl hostRepository;
    late ShortcutRepositoryImpl shortcutRepository;

    setUp(() {
      database = AppDatabase(NativeDatabase.memory());
      fakeSecureStorage = FakeSecureStorageDatasource();
      hostRepository = HostRepositoryImpl(database, fakeSecureStorage);
      shortcutRepository = ShortcutRepositoryImpl(database);
    });

    tearDown(() async {
      await database.close();
    });

    test('HostRepository should save, read, and delete hosts with credentials', () async {
      final host = SSHHost(
        id: 'host-1',
        name: 'Servidor Teste',
        host: '127.0.0.1',
        port: 2222,
        username: 'ubuntu',
        authType: SSHAuthType.password,
        groupName: 'Testes',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await hostRepository.saveHost(host, password: 'super_secret_password');

      final list = await hostRepository.getAllHosts();
      expect(list.length, 1);
      expect(list.first.name, 'Servidor Teste');
      expect(list.first.port, 2222);

      final retrievedPassword = await hostRepository.getHostPassword('host-1');
      expect(retrievedPassword, 'super_secret_password');

      await hostRepository.deleteHost('host-1');
      final emptyList = await hostRepository.getAllHosts();
      expect(emptyList.isEmpty, true);

      final deletedPassword = await hostRepository.getHostPassword('host-1');
      expect(deletedPassword, isNull);
    });

    test('ShortcutRepository should save shortcuts and execution history', () async {
      final shortcut = ShortcutCommand(
        id: 'sc-1',
        name: 'Verificar Uptime',
        command: 'uptime',
        category: 'Sistema',
        timeoutSeconds: 15,
        createdAt: DateTime.now(),
      );

      await shortcutRepository.saveShortcut(shortcut);
      final shortcuts = await shortcutRepository.getShortcuts();
      expect(shortcuts.length, 1);
      expect(shortcuts.first.command, 'uptime');

      final result = CommandResult(
        id: 'res-1',
        hostId: 'host-1',
        shortcutId: 'sc-1',
        command: 'uptime',
        exitCode: 0,
        stdout: ' 12:00:00 up 10 days, 2 users, load average: 0.10, 0.05, 0.01',
        stderr: '',
        durationMs: 142,
        executedAt: DateTime.now(),
      );

      await shortcutRepository.saveExecutionResult(result);
      final history = await shortcutRepository.getExecutionHistory();
      expect(history.length, 1);
      expect(history.first.exitCode, 0);
      expect(history.first.isSuccess, true);
      expect(history.first.stdout, contains('load average'));
    });
  });
}
