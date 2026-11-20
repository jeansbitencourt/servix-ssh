import 'dart:io';

import 'package:drift/drift.dart';

import '../../domain/entities/ssh_host_key.dart';
import 'local_database.dart';

String sshSocketHostname(String hostname) {
  final trimmed = hostname.trim();
  return trimmed.startsWith('[') && trimmed.endsWith(']')
      ? trimmed.substring(1, trimmed.length - 1)
      : trimmed;
}

String normalizeSSHHostname(String hostname) {
  final address = sshSocketHostname(hostname);
  final scopeIndex = address.indexOf('%');
  final literal = scopeIndex < 0 ? address : address.substring(0, scopeIndex);
  final ip = InternetAddress.tryParse(literal);
  if (ip != null) {
    final canonical = InternetAddress.fromRawAddress(ip.rawAddress).address;
    return scopeIndex < 0
        ? canonical
        : '$canonical${address.substring(scopeIndex)}';
  }
  final lower = address.toLowerCase();
  return lower.endsWith('.') ? lower.substring(0, lower.length - 1) : lower;
}

class SSHHostKeyStore {
  SSHHostKeyStore(this._db);

  final AppDatabase _db;

  Future<TrustedHostKeyEntry?> read(SSHHostKey key) =>
      (_db.select(_db.trustedHostKeysTable)..where(
            (t) => t.hostname.equals(key.hostname) & t.port.equals(key.port),
          ))
          .getSingleOrNull();

  /// Compare-and-set prevents stale prompts from replacing a newer decision.
  Future<bool> record(
    SSHHostKey key,
    TrustedHostKeyEntry? expected, {
    required bool Function() isCurrent,
  }) => _db.transaction(() async {
    final current = await read(key);
    if (!isCurrent() ||
        current?.algorithm != expected?.algorithm ||
        current?.fingerprint != expected?.fingerprint ||
        current?.firstConfirmedAt != expected?.firstConfirmedAt) {
      return false;
    }

    final now = DateTime.now();
    final sameKey =
        current?.fingerprint == key.fingerprint &&
        current?.algorithm == key.algorithm;
    await _db
        .into(_db.trustedHostKeysTable)
        .insertOnConflictUpdate(
          TrustedHostKeysTableCompanion.insert(
            hostname: key.hostname,
            port: key.port,
            algorithm: key.algorithm,
            fingerprint: key.fingerprint,
            firstConfirmedAt: sameKey ? current!.firstConfirmedAt : now,
            lastVerifiedAt: now,
          ),
        );
    return true;
  });
}

extension TrustedHostKeyIdentity on TrustedHostKeyEntry {
  SSHHostKey get identity => SSHHostKey(hostname, port, algorithm, fingerprint);
}
