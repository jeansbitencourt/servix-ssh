import 'package:drift/drift.dart';
import '../../domain/entities/command_result.dart';
import '../datasources/local_database.dart';

class ExecutionHistoryModel {
  static CommandResult fromEntry(ExecutionHistoryEntry entry) {
    return CommandResult(
      id: entry.id,
      hostId: entry.hostId,
      shortcutId: entry.shortcutId,
      command: entry.command,
      exitCode: entry.exitCode,
      stdout: entry.stdout,
      stderr: entry.stderr,
      durationMs: entry.durationMs,
      executedAt: entry.executedAt,
    );
  }

  static ExecutionHistoryTableCompanion toCompanion(CommandResult result) {
    return ExecutionHistoryTableCompanion.insert(
      id: result.id,
      hostId: result.hostId,
      shortcutId: result.shortcutId != null ? Value(result.shortcutId) : const Value.absent(),
      command: result.command,
      exitCode: result.exitCode,
      stdout: result.stdout,
      stderr: result.stderr,
      durationMs: result.durationMs,
      executedAt: result.executedAt,
    );
  }
}
