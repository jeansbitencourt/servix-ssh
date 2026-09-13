import 'package:drift/drift.dart';
import '../../domain/entities/command_result.dart';
import '../../domain/entities/shortcut_command.dart';
import '../../domain/repositories/shortcut_repository.dart';
import '../datasources/local_database.dart';
import '../models/execution_history_model.dart';
import '../models/shortcut_command_model.dart';

class ShortcutRepositoryImpl implements ShortcutRepository {
  final AppDatabase _database;

  ShortcutRepositoryImpl(this._database);

  @override
  Future<List<ShortcutCommand>> getShortcuts({String? hostId}) async {
    final query = _database.select(_database.shortcutCommandsTable);
    if (hostId != null) {
      query.where((t) => t.hostId.isNull() | t.hostId.equals(hostId));
    }
    query.orderBy([(t) => OrderingTerm(expression: t.category), (t) => OrderingTerm(expression: t.name)]);
    final entries = await query.get();
    return entries.map(ShortcutCommandModel.fromEntry).toList();
  }

  @override
  Stream<List<ShortcutCommand>> watchShortcuts({String? hostId}) {
    final query = _database.select(_database.shortcutCommandsTable);
    if (hostId != null) {
      query.where((t) => t.hostId.isNull() | t.hostId.equals(hostId));
    }
    query.orderBy([(t) => OrderingTerm(expression: t.category), (t) => OrderingTerm(expression: t.name)]);
    return query.watch().map((entries) => entries.map(ShortcutCommandModel.fromEntry).toList());
  }

  @override
  Future<void> saveShortcut(ShortcutCommand shortcut) async {
    final companion = ShortcutCommandModel.toCompanion(shortcut);
    await _database.into(_database.shortcutCommandsTable).insertOnConflictUpdate(companion);
  }

  @override
  Future<void> deleteShortcut(String id) async {
    await (_database.delete(_database.shortcutCommandsTable)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<List<CommandResult>> getExecutionHistory({int limit = 50, String? hostId}) async {
    final query = _database.select(_database.executionHistoryTable);
    if (hostId != null) {
      query.where((t) => t.hostId.equals(hostId));
    }
    query.orderBy([(t) => OrderingTerm(expression: t.executedAt, mode: OrderingMode.desc)]);
    query.limit(limit);

    final entries = await query.get();
    return entries.map(ExecutionHistoryModel.fromEntry).toList();
  }

  @override
  Stream<List<CommandResult>> watchExecutionHistory({int limit = 50, String? hostId}) {
    final query = _database.select(_database.executionHistoryTable);
    if (hostId != null) {
      query.where((t) => t.hostId.equals(hostId));
    }
    query.orderBy([(t) => OrderingTerm(expression: t.executedAt, mode: OrderingMode.desc)]);
    query.limit(limit);

    return query.watch().map((entries) => entries.map(ExecutionHistoryModel.fromEntry).toList());
  }

  @override
  Future<void> saveExecutionResult(CommandResult result) async {
    final companion = ExecutionHistoryModel.toCompanion(result);
    await _database.into(_database.executionHistoryTable).insert(companion);
  }
}
