enum SSHAuthType {
  password,
  privateKey,
}

class SSHHost {
  final String id;
  final String name;
  final String host;
  final int port;
  final String username;
  final SSHAuthType authType;
  final String? keyFilePath;
  final String groupName;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SSHHost({
    required this.id,
    required this.name,
    required this.host,
    this.port = 22,
    required this.username,
    required this.authType,
    this.keyFilePath,
    this.groupName = 'Default',
    required this.createdAt,
    required this.updatedAt,
  });

  SSHHost copyWith({
    String? id,
    String? name,
    String? host,
    int? port,
    String? username,
    SSHAuthType? authType,
    String? keyFilePath,
    String? groupName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SSHHost(
      id: id ?? this.id,
      name: name ?? this.name,
      host: host ?? this.host,
      port: port ?? this.port,
      username: username ?? this.username,
      authType: authType ?? this.authType,
      keyFilePath: keyFilePath ?? this.keyFilePath,
      groupName: groupName ?? this.groupName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
