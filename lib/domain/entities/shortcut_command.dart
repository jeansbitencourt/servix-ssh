class ShortcutCommand {
  final String id;
  final String? hostId; // null indicates a global shortcut available to all hosts
  final String name;
  final String command;
  final String? workingDirectory;
  final int timeoutSeconds;
  final String category;
  final DateTime createdAt;

  const ShortcutCommand({
    required this.id,
    this.hostId,
    required this.name,
    required this.command,
    this.workingDirectory,
    this.timeoutSeconds = 30,
    this.category = 'Geral',
    required this.createdAt,
  });

  ShortcutCommand copyWith({
    String? id,
    String? hostId,
    String? name,
    String? command,
    String? workingDirectory,
    int? timeoutSeconds,
    String? category,
    DateTime? createdAt,
  }) {
    return ShortcutCommand(
      id: id ?? this.id,
      hostId: hostId ?? this.hostId,
      name: name ?? this.name,
      command: command ?? this.command,
      workingDirectory: workingDirectory ?? this.workingDirectory,
      timeoutSeconds: timeoutSeconds ?? this.timeoutSeconds,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
