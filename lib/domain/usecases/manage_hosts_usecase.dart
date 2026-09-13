import '../entities/ssh_host.dart';
import '../repositories/host_repository.dart';
import '../repositories/ssh_repository.dart';

class ManageHostsUseCase {
  final HostRepository _hostRepository;
  final SSHRepository _sshRepository;

  ManageHostsUseCase(this._hostRepository, this._sshRepository);

  Future<List<SSHHost>> getAllHosts() => _hostRepository.getAllHosts();

  Stream<List<SSHHost>> watchAllHosts() => _hostRepository.watchAllHosts();

  Future<void> saveHost(SSHHost host, {String? password, String? passphrase}) {
    return _hostRepository.saveHost(host, password: password, passphrase: passphrase);
  }

  Future<void> deleteHost(String id) => _hostRepository.deleteHost(id);

  Future<bool> testConnection(SSHHost host, {String? password, String? passphrase}) async {
    final effectivePassword = password ?? await _hostRepository.getHostPassword(host.id);
    final effectivePassphrase = passphrase ?? await _hostRepository.getHostPassphrase(host.id);

    return _sshRepository.testConnection(
      host,
      password: effectivePassword,
      passphrase: effectivePassphrase,
    );
  }
}
