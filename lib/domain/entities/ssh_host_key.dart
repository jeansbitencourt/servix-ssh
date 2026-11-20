class SSHHostKey {
  const SSHHostKey(this.hostname, this.port, this.algorithm, this.fingerprint);

  final String hostname;
  final int port;
  final String algorithm;
  final String fingerprint;

  String get endpoint =>
      hostname.contains(':') ? '[$hostname]:$port' : '$hostname:$port';

  String get identity => '$algorithm $fingerprint';

  bool matches(SSHHostKey other) =>
      algorithm == other.algorithm && fingerprint == other.fingerprint;
}

/// The connection layer can request consent without knowing how it is shown.
abstract interface class SSHHostKeyConfirmation {
  Future<bool> trust(SSHHostKey key, Future<void> connectionEnded);

  Future<void> changed(
    SSHHostKey previous,
    SSHHostKey presented,
    Future<void> Function() replace,
  );

  void rekeyRejected(String endpoint, String previous, String presented);
}
