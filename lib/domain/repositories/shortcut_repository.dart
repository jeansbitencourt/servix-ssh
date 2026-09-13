import '../entities/command_result.dart';
import '../entities/shortcut_command.dart';

abstract class ShortcutRepository {
  Future<List<ShortcutCommand>> getShortcuts({String? hostId});
  Stream<List<ShortcutCommand>> watchShortcuts({String? hostId});
  Future<void> saveShortcut(ShortcutCommand shortcut);
  Future<void> deleteShortcut(String id);
  Future<List<CommandResult>> getExecutionHistory({int limit = 50, String? hostId});
  Stream<List<CommandResult>> watchExecutionHistory({int limit = 50, String? hostId});
  Future<void> saveExecutionResult(CommandResult result);
}
