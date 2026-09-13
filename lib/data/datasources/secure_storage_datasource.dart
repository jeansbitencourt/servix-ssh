import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/errors/exceptions.dart';

class SecureStorageDatasource {
  final FlutterSecureStorage _storage;

  SecureStorageDatasource({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  String _passwordKey(String hostId) => 'ssh_host_${hostId}_password';
  String _passphraseKey(String hostId) => 'ssh_host_${hostId}_passphrase';

  Future<void> savePassword(String hostId, String password) async {
    try {
      await _storage.write(key: _passwordKey(hostId), value: password);
    } catch (e) {
      throw StorageException('Falha ao salvar senha no cofre seguro: $e', e);
    }
  }

  Future<String?> getPassword(String hostId) async {
    try {
      return await _storage.read(key: _passwordKey(hostId));
    } catch (e) {
      throw StorageException('Falha ao recuperar senha do cofre seguro: $e', e);
    }
  }

  Future<void> deletePassword(String hostId) async {
    try {
      await _storage.delete(key: _passwordKey(hostId));
    } catch (e) {
      throw StorageException('Falha ao deletar senha do cofre seguro: $e', e);
    }
  }

  Future<void> savePassphrase(String hostId, String passphrase) async {
    try {
      await _storage.write(key: _passphraseKey(hostId), value: passphrase);
    } catch (e) {
      throw StorageException('Falha ao salvar passphrase no cofre seguro: $e', e);
    }
  }

  Future<String?> getPassphrase(String hostId) async {
    try {
      return await _storage.read(key: _passphraseKey(hostId));
    } catch (e) {
      throw StorageException('Falha ao recuperar passphrase do cofre seguro: $e', e);
    }
  }

  Future<void> deletePassphrase(String hostId) async {
    try {
      await _storage.delete(key: _passphraseKey(hostId));
    } catch (e) {
      throw StorageException('Falha ao deletar passphrase do cofre seguro: $e', e);
    }
  }

  Future<void> deleteAllHostCredentials(String hostId) async {
    await deletePassword(hostId);
    await deletePassphrase(hostId);
  }
}
