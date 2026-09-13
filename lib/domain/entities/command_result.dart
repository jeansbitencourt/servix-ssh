class CommandResult {
  final String id;
  final String hostId;
  final String? shortcutId;
  final String command;
  final int exitCode;
  final String stdout;
  final String stderr;
  final int durationMs;
  final DateTime executedAt;

  const CommandResult({
    required this.id,
    required this.hostId,
    this.shortcutId,
    required this.command,
    required this.exitCode,
    required this.stdout,
    required this.stderr,
    required this.durationMs,
    required this.executedAt,
  });

  bool get isSuccess => exitCode == 0;
}
