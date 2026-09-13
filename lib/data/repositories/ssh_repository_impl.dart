import '../../domain/entities/command_result.dart';
import '../../domain/entities/ssh_host.dart';
import '../../domain/entities/terminal_session.dart';
import '../../domain/repositories/ssh_repository.dart';
import '../datasources/ssh_remote_datasource.dart';

class SSHRepositoryImpl implements SSHRepository {
  final SSHRemoteDatasource _remoteDatasource;

  SSHRepositoryImpl(this._remoteDatasource);

  @override
  Future<bool> testConnection(
    SSHHost host, {
    String? password,
    String? passphrase,
  }) {
    return _remoteDatasource.testConnection(
      host,
      password: password,
      passphrase: passphrase,
    );
  }

  @override
  Future<CommandResult> executeCommand(
    SSHHost host,
    String command, {
    String? password,
    String? passphrase,
    int timeoutSeconds = 30,
    String? shortcutId,
  }) {
    return _remoteDatasource.runCommand(
      host,
      command,
      password: password,
      passphrase: passphrase,
      timeoutSeconds: timeoutSeconds,
      shortcutId: shortcutId,
    );
  }

  @override
  Future<TerminalSession> createTerminalSession(
    SSHHost host, {
    String? password,
    String? passphrase,
  }) {
    return _remoteDatasource.createInteractiveShell(
      host,
      password: password,
      passphrase: passphrase,
    );
  }
}
