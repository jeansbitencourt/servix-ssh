import 'package:drift/drift.dart';

import '../../core/errors/exceptions.dart';
import '../../domain/entities/ssh_tunnel.dart';
import '../../domain/entities/tunnel_session.dart';
import '../../domain/repositories/tunnel_repository.dart';
import '../../l10n/system_localizations.dart';
import '../datasources/local_database.dart';
import '../datasources/ssh_tunnel_datasource.dart';

class TunnelRepositoryImpl implements TunnelRepository {
  TunnelRepositoryImpl(this._db, this._runtime);

  final AppDatabase _db;
  final SSHTunnelDatasource _runtime;
  final _starting = <String, Object>{};
  final _mutating = <String>{};
  bool _closed = false;

  @override
  Stream<List<SSHTunnel>> watchTunnels() =>
      (_db.select(_db.tunnelsTable)..orderBy([(t) => OrderingTerm.asc(t.name)]))
          .watch()
          .map((rows) => rows.map(_fromRow).toList());

  SSHTunnel _fromRow(TunnelEntry row) => SSHTunnel(
    id: row.id,
    name: row.name,
    hostId: row.hostId,
    localHost: row.localHost,
    localPort: row.localPort,
    remoteHost: row.remoteHost,
    remotePort: row.remotePort,
    autoReconnect: row.autoReconnect,
    autoConnect: row.autoConnect,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  );

  @override
  Future<void> save(SSHTunnel tunnel) async {
    if (!tunnel.isValid) {
      throw DatabaseException(systemLocalizations.tunnelInvalidConfiguration);
    }
    final id = tunnel.id;
    if (_runtime.isRunning(id) ||
        _starting.containsKey(id) ||
        !_mutating.add(id)) {
      throw DatabaseException(systemLocalizations.stopTunnelBeforeEditing);
    }
    try {
      await _db
          .into(_db.tunnelsTable)
          .insertOnConflictUpdate(
            TunnelEntry(
              id: id,
              name: tunnel.name,
              hostId: tunnel.hostId,
              localHost: tunnel.localHost,
              localPort: tunnel.localPort,
              remoteHost: tunnel.remoteHost,
              remotePort: tunnel.remotePort,
              autoReconnect: tunnel.autoReconnect,
              autoConnect: tunnel.autoConnect,
              createdAt: tunnel.createdAt,
              updatedAt: tunnel.updatedAt,
            ),
          );
    } finally {
      _mutating.remove(id);
    }
  }

  @override
  Future<void> delete(String id) async {
    if (!_mutating.add(id)) {
      throw DatabaseException(systemLocalizations.tunnelDeleteError);
    }
    try {
      await stop(id);
      await (_db.delete(
        _db.tunnelsTable,
      )..where((table) => table.id.equals(id))).go();
    } finally {
      _mutating.remove(id);
    }
  }

  @override
  Stream<(String, TunnelSession)> get sessions => _runtime.sessions;

  @override
  Future<void> start(String id) async {
    if (_closed ||
        _mutating.contains(id) ||
        _runtime.isRunning(id) ||
        _starting.containsKey(id)) {
      return;
    }
    final request = _starting[id] = Object();
    try {
      final row = await (_db.select(
        _db.tunnelsTable,
      )..where((table) => table.id.equals(id))).getSingleOrNull();
      if (_starting[id] == request && row != null) {
        await _runtime.start(_fromRow(row));
      }
    } finally {
      if (_starting[id] == request) _starting.remove(id);
    }
  }

  @override
  Future<void> stop(String id) {
    _starting.remove(id);
    return _runtime.stop(id);
  }

  @override
  Future<void> shutdown() {
    _closed = true;
    _starting.clear();
    return _runtime.shutdown();
  }
}
