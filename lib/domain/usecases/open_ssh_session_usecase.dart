import '../entities/ssh_host.dart';
import '../entities/terminal_session.dart';
import '../repositories/ssh_repository.dart';

class OpenSSHSessionUseCase {
  final SSHRepository _sshRepository;

  OpenSSHSessionUseCase(this._sshRepository);

  Future<TerminalSession> call(SSHHost host) =>
      _sshRepository.createTerminalSession(host);
}
