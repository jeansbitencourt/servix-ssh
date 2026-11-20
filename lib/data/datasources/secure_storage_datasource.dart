import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/errors/exceptions.dart';
import '../../l10n/system_localizations.dart';

class SecureStorageDatasource {
  final FlutterSecureStorage _storage;

  SecureStorageDatasource({FlutterSecureStorage? storage})
    : _storage =
          storage ??
          const FlutterSecureStorage(
            mOptions: MacOsOptions(
              accountName: 'com.servix.Servix',
              usesDataProtectionKeychain: false,
            ),
          );

  String _passwordKey(String hostId) => 'ssh_host_${hostId}_password';
  String _passphraseKey(String hostId) => 'ssh_host_${hostId}_passphrase';

  Future<void> savePassword(String hostId, String password) async {
    try {
      await _storage.write(key: _passwordKey(hostId), value: password);
    } catch (e) {
      throw StorageException(
        systemLocalizations.savePasswordFailed(e.toString()),
        e,
      );
    }
  }

  Future<String?> getPassword(String hostId) async {
    try {
      return await _storage.read(key: _passwordKey(hostId));
    } catch (e) {
      throw StorageException(
        systemLocalizations.readPasswordFailed(e.toString()),
        e,
      );
    }
  }

  Future<void> deletePassword(String hostId) async {
    try {
      await _storage.delete(key: _passwordKey(hostId));
    } catch (e) {
      throw StorageException(
        systemLocalizations.deletePasswordFailed(e.toString()),
        e,
      );
    }
  }

  Future<void> savePassphrase(String hostId, String passphrase) async {
    try {
      await _storage.write(key: _passphraseKey(hostId), value: passphrase);
    } catch (e) {
      throw StorageException(
        systemLocalizations.savePassphraseFailed(e.toString()),
        e,
      );
    }
  }

  Future<String?> getPassphrase(String hostId) async {
    try {
      return await _storage.read(key: _passphraseKey(hostId));
    } catch (e) {
      throw StorageException(
        systemLocalizations.readPassphraseFailed(e.toString()),
        e,
      );
    }
  }

  Future<void> deletePassphrase(String hostId) async {
    try {
      await _storage.delete(key: _passphraseKey(hostId));
    } catch (e) {
      throw StorageException(
        systemLocalizations.deletePassphraseFailed(e.toString()),
        e,
      );
    }
  }

  Future<void> deleteAllHostCredentials(String hostId) async {
    await deletePassword(hostId);
    await deletePassphrase(hostId);
  }
}
