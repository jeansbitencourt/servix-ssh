import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

part 'local_database.g.dart';

@DataClassName('HostEntry')
class HostsTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get host => text()();
  IntColumn get port => integer().withDefault(const Constant(22))();
  TextColumn get username => text()();
  TextColumn get authType => text()(); // 'password' or 'privateKey'
  TextColumn get keyFilePath => text().nullable()();
  TextColumn get groupName => text().withDefault(const Constant('Default'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ShortcutEntry')
class ShortcutCommandsTable extends Table {
  TextColumn get id => text()();
  TextColumn get hostId => text().nullable()();
  TextColumn get name => text()();
  TextColumn get command => text()();
  TextColumn get workingDirectory => text().nullable()();
  IntColumn get timeoutSeconds => integer().withDefault(const Constant(30))();
  TextColumn get category => text().withDefault(const Constant('Geral'))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ExecutionHistoryEntry')
class ExecutionHistoryTable extends Table {
  TextColumn get id => text()();
  TextColumn get hostId => text()();
  TextColumn get shortcutId => text().nullable()();
  TextColumn get command => text()();
  IntColumn get exitCode => integer()();
  TextColumn get stdout => text()();
  TextColumn get stderr => text()();
  IntColumn get durationMs => integer()();
  DateTimeColumn get executedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('TrustedHostKeyEntry')
class TrustedHostKeysTable extends Table {
  TextColumn get hostname => text()();
  IntColumn get port => integer()();
  TextColumn get algorithm => text()();
  TextColumn get fingerprint => text()();
  DateTimeColumn get firstConfirmedAt => dateTime()();
  DateTimeColumn get lastVerifiedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {hostname, port};
}

@DataClassName('TunnelEntry')
class TunnelsTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get hostId =>
      text().references(HostsTable, #id, onDelete: KeyAction.restrict)();
  TextColumn get localHost => text().withDefault(const Constant('127.0.0.1'))();
  IntColumn get localPort => integer()();
  TextColumn get remoteHost => text()();
  IntColumn get remotePort => integer()();
  BoolColumn get autoReconnect =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get autoConnect => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    HostsTable,
    ShortcutCommandsTable,
    ExecutionHistoryTable,
    TrustedHostKeysTable,
    TunnelsTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e])
    : super(
        e ??
            driftDatabase(
              name: 'servix',
              native: const DriftNativeOptions(
                databaseDirectory: getApplicationSupportDirectory,
              ),
            ),
      );

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await transaction(() async {
          await migrator.createTable(trustedHostKeysTable);
          await migrator.createTable(tunnelsTable);
        });
      }
    },
    beforeOpen: (_) => customStatement('PRAGMA foreign_keys = ON'),
  );
}
