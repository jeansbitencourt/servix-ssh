import '../entities/ssh_host.dart';
import '../entities/terminal_session.dart';
import '../repositories/host_repository.dart';
import '../repositories/ssh_repository.dart';

class OpenSSHSessionUseCase {
  final HostRepository _hostRepository;
  final SSHRepository _sshRepository;

  OpenSSHSessionUseCase(this._hostRepository, this._sshRepository);

  Future<TerminalSession> call(SSHHost host) async {
    final password = await _hostRepository.getHostPassword(host.id);
    final passphrase = await _hostRepository.getHostPassphrase(host.id);

    return _sshRepository.createTerminalSession(
      host,
      password: password,
      passphrase: passphrase,
    );
  }
}
