import 'package:drift/drift.dart';
import '../../domain/entities/shortcut_command.dart';
import '../datasources/local_database.dart';

class ShortcutCommandModel {
  static ShortcutCommand fromEntry(ShortcutEntry entry) {
    return ShortcutCommand(
      id: entry.id,
      hostId: entry.hostId,
      name: entry.name,
      command: entry.command,
      workingDirectory: entry.workingDirectory,
      timeoutSeconds: entry.timeoutSeconds,
      category: entry.category,
      createdAt: entry.createdAt,
    );
  }

  static ShortcutCommandsTableCompanion toCompanion(ShortcutCommand shortcut) {
    return ShortcutCommandsTableCompanion.insert(
      id: shortcut.id,
      hostId: shortcut.hostId != null ? Value(shortcut.hostId) : const Value.absent(),
      name: shortcut.name,
      command: shortcut.command,
      workingDirectory: shortcut.workingDirectory != null ? Value(shortcut.workingDirectory) : const Value.absent(),
      timeoutSeconds: Value(shortcut.timeoutSeconds),
      category: Value(shortcut.category),
      createdAt: shortcut.createdAt,
    );
  }
}
