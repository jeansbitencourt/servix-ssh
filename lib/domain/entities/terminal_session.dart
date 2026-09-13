import 'package:dartssh2/dartssh2.dart';
import 'package:xterm/xterm.dart';
import 'ssh_host.dart';

enum TerminalSessionStatus {
  connecting,
  connected,
  disconnected,
  error,
}

class TerminalSession {
  final String id;
  final SSHHost host;
  final String title;
  final Terminal terminal;
  final DateTime createdAt;
  SSHClient? client;
  SSHSession? sshSession;
  TerminalSessionStatus status;
  String? errorMessage;

  TerminalSession({
    required this.id,
    required this.host,
    required this.title,
    required this.terminal,
    required this.createdAt,
    this.client,
    this.sshSession,
    this.status = TerminalSessionStatus.connecting,
    this.errorMessage,
  });

  void close() {
    try {
      sshSession?.close();
    } catch (_) {}
    try {
      client?.close();
    } catch (_) {}
    status = TerminalSessionStatus.disconnected;
  }
}
