import '../entities/command_result.dart';
import '../entities/shortcut_command.dart';
import '../entities/ssh_host.dart';
import '../repositories/shortcut_repository.dart';
import '../repositories/ssh_repository.dart';

class ExecuteShortcutUseCase {
  final ShortcutRepository _shortcutRepository;
  final SSHRepository _sshRepository;

  ExecuteShortcutUseCase(this._shortcutRepository, this._sshRepository);

  Future<CommandResult> call({
    required SSHHost host,
    required ShortcutCommand shortcut,
  }) async {
    final command =
        shortcut.workingDirectory != null &&
            shortcut.workingDirectory!.trim().isNotEmpty
        ? 'cd ${shortcut.workingDirectory} && ${shortcut.command}'
        : shortcut.command;

    final result = await _sshRepository.executeCommand(
      host,
      command,
      timeoutSeconds: shortcut.timeoutSeconds,
      shortcutId: shortcut.id,
    );

    // Persist result in execution history
    await _shortcutRepository.saveExecutionResult(result);

    return result;
  }
}
