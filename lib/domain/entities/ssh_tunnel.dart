import 'dart:io';

class SSHTunnel {
  const SSHTunnel({
    required this.id,
    required this.name,
    required this.hostId,
    this.localHost = loopback,
    required this.localPort,
    required this.remoteHost,
    required this.remotePort,
    this.autoReconnect = false,
    this.autoConnect = false,
    required this.createdAt,
    required this.updatedAt,
  });

  static const loopback = '127.0.0.1';

  final String id;
  final String name;
  final String hostId;
  final String localHost;
  final int localPort;
  final String remoteHost;
  final int remotePort;
  final bool autoReconnect;
  final bool autoConnect;
  final DateTime createdAt;
  final DateTime updatedAt;

  String get localAddress => '$localHost:$localPort';
  String get remoteAddress =>
      remoteHost.contains(':') && !remoteHost.startsWith('[')
      ? '[$remoteHost]:$remotePort'
      : '$remoteHost:$remotePort';

  static bool isValidPort(int? port) =>
      port != null && port >= 1 && port <= 65535;

  static bool isValidRemoteHost(String host) {
    if (host.contains(':')) {
      final literal = host.startsWith('[') && host.endsWith(']')
          ? host.substring(1, host.length - 1)
          : host;
      final parts = literal.split('%');
      return InternetAddress.tryParse(parts.first)?.type ==
              InternetAddressType.IPv6 &&
          (parts.length == 1 ||
              (parts.length == 2 && RegExp(r'^[\w.-]+$').hasMatch(parts.last)));
    }
    final name = host.endsWith('.') ? host.substring(0, host.length - 1) : host;
    // DNS names can be unicode, punycode, or local single-label names.
    return name.isNotEmpty &&
        name.length <= 253 &&
        name
            .split('.')
            .every(
              (label) => RegExp(
                r'^[\p{L}\p{N}_](?:[\p{L}\p{N}_-]{0,61}[\p{L}\p{N}_])?$',
                unicode: true,
              ).hasMatch(label),
            );
  }

  bool get isValid =>
      id.isNotEmpty &&
      name.trim().isNotEmpty &&
      hostId.isNotEmpty &&
      localHost == loopback &&
      isValidPort(localPort) &&
      isValidPort(remotePort) &&
      isValidRemoteHost(remoteHost);
}
