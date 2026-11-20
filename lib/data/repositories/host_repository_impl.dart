import 'package:drift/drift.dart';

import '../../core/errors/exceptions.dart';
import '../../domain/entities/ssh_host.dart';
import '../../l10n/system_localizations.dart';
import '../../domain/repositories/host_repository.dart';
import '../datasources/local_database.dart';
import '../datasources/secure_storage_datasource.dart';
import '../models/ssh_host_model.dart';

class HostRepositoryImpl implements HostRepository {
  final AppDatabase _database;
  final SecureStorageDatasource _secureStorage;

  HostRepositoryImpl(this._database, this._secureStorage);

  @override
  Future<List<SSHHost>> getAllHosts() async {
    final query = _database.select(_database.hostsTable)
      ..orderBy([(t) => OrderingTerm(expression: t.name)]);
    final entries = await query.get();
    return entries.map(SSHHostModel.fromEntry).toList();
  }

  @override
  Stream<List<SSHHost>> watchAllHosts() {
    final query = _database.select(_database.hostsTable)
      ..orderBy([(t) => OrderingTerm(expression: t.name)]);
    return query.watch().map(
      (entries) => entries.map(SSHHostModel.fromEntry).toList(),
    );
  }

  @override
  Future<SSHHost?> getHostById(String id) async {
    final query = _database.select(_database.hostsTable)
      ..where((t) => t.id.equals(id));
    final entry = await query.getSingleOrNull();
    return entry != null ? SSHHostModel.fromEntry(entry) : null;
  }

  @override
  Future<void> saveHost(
    SSHHost host, {
    String? password,
    String? passphrase,
  }) async {
    final companion = SSHHostModel.toCompanion(host);
    await _database
        .into(_database.hostsTable)
        .insertOnConflictUpdate(companion);

    if (password != null && password.isNotEmpty) {
      await _secureStorage.savePassword(host.id, password);
    }
    if (passphrase != null && passphrase.isNotEmpty) {
      await _secureStorage.savePassphrase(host.id, passphrase);
    }
  }

  @override
  Future<void> deleteHost(String id) async {
    await _database.transaction(() async {
      final linked =
          await (_database.select(_database.tunnelsTable)
                ..where((t) => t.hostId.equals(id))
                ..limit(1))
              .getSingleOrNull();
      if (linked != null) {
        throw DatabaseException(systemLocalizations.hostUsedByTunnel);
      }
      await (_database.delete(
        _database.hostsTable,
      )..where((t) => t.id.equals(id))).go();
    });
    await _secureStorage.deleteAllHostCredentials(id);
  }

  @override
  Future<String?> getHostPassword(String id) => _secureStorage.getPassword(id);

  @override
  Future<String?> getHostPassphrase(String id) =>
      _secureStorage.getPassphrase(id);
}
