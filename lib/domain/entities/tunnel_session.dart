enum TunnelStatus {
  disconnected,
  connecting,
  connected,
  disconnecting,
  reconnecting,
  error;

  bool get isActive => this != disconnected && this != error;
}

enum TunnelIssue {
  invalidConfiguration,
  configurationStorage,
  missingServer,
  localPortInUse,
  localListener,
  sshUnavailable,
  authentication,
  hostKeyRejected,
  hostKeyChanged,
  hostKeyStorage,
  forwardingRefused,
  destinationUnavailable,
  transfer,
  disconnected,
}

class TunnelSession {
  const TunnelSession({
    this.status = TunnelStatus.disconnected,
    this.connections = 0,
    this.issue,
    this.message,
  });

  final TunnelStatus status;
  final int connections;
  final TunnelIssue? issue;
  final String? message;
}
