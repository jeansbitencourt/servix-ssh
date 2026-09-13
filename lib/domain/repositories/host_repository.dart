import '../entities/ssh_host.dart';

abstract class HostRepository {
  Future<List<SSHHost>> getAllHosts();
  Stream<List<SSHHost>> watchAllHosts();
  Future<SSHHost?> getHostById(String id);
  Future<void> saveHost(SSHHost host, {String? password, String? passphrase});
  Future<void> deleteHost(String id);
  Future<String?> getHostPassword(String id);
  Future<String?> getHostPassphrase(String id);
}
