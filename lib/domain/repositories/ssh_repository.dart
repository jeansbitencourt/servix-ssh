import '../entities/command_result.dart';
import '../entities/ssh_host.dart';
import '../entities/terminal_session.dart';

abstract class SSHRepository {
  Future<bool> testConnection(SSHHost host, {String? password, String? passphrase});
  Future<CommandResult> executeCommand(
    SSHHost host,
    String command, {
    String? password,
    String? passphrase,
    int timeoutSeconds = 30,
    String? shortcutId,
  });
  Future<TerminalSession> createTerminalSession(
    SSHHost host, {
    String? password,
    String? passphrase,
  });
}
