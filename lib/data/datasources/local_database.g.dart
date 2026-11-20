// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_database.dart';

// ignore_for_file: type=lint
class $HostsTableTable extends HostsTable
    with TableInfo<$HostsTableTable, HostEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HostsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hostMeta = const VerificationMeta('host');
  @override
  late final GeneratedColumn<String> host = GeneratedColumn<String>(
    'host',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _portMeta = const VerificationMeta('port');
  @override
  late final GeneratedColumn<int> port = GeneratedColumn<int>(
    'port',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(22),
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authTypeMeta = const VerificationMeta(
    'authType',
  );
  @override
  late final GeneratedColumn<String> authType = GeneratedColumn<String>(
    'auth_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _keyFilePathMeta = const VerificationMeta(
    'keyFilePath',
  );
  @override
  late final GeneratedColumn<String> keyFilePath = GeneratedColumn<String>(
    'key_file_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _groupNameMeta = const VerificationMeta(
    'groupName',
  );
  @override
  late final GeneratedColumn<String> groupName = GeneratedColumn<String>(
    'group_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Default'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    host,
    port,
    username,
    authType,
    keyFilePath,
    groupName,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hosts_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<HostEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('host')) {
      context.handle(
        _hostMeta,
        host.isAcceptableOrUnknown(data['host']!, _hostMeta),
      );
    } else if (isInserting) {
      context.missing(_hostMeta);
    }
    if (data.containsKey('port')) {
      context.handle(
        _portMeta,
        port.isAcceptableOrUnknown(data['port']!, _portMeta),
      );
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('auth_type')) {
      context.handle(
        _authTypeMeta,
        authType.isAcceptableOrUnknown(data['auth_type']!, _authTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_authTypeMeta);
    }
    if (data.containsKey('key_file_path')) {
      context.handle(
        _keyFilePathMeta,
        keyFilePath.isAcceptableOrUnknown(
          data['key_file_path']!,
          _keyFilePathMeta,
        ),
      );
    }
    if (data.containsKey('group_name')) {
      context.handle(
        _groupNameMeta,
        groupName.isAcceptableOrUnknown(data['group_name']!, _groupNameMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HostEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HostEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      host: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}host'],
      )!,
      port: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}port'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      authType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}auth_type'],
      )!,
      keyFilePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key_file_path'],
      ),
      groupName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_name'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $HostsTableTable createAlias(String alias) {
    return $HostsTableTable(attachedDatabase, alias);
  }
}

class HostEntry extends DataClass implements Insertable<HostEntry> {
  final String id;
  final String name;
  final String host;
  final int port;
  final String username;
  final String authType;
  final String? keyFilePath;
  final String groupName;
  final DateTime createdAt;
  final DateTime updatedAt;
  const HostEntry({
    required this.id,
    required this.name,
    required this.host,
    required this.port,
    required this.username,
    required this.authType,
    this.keyFilePath,
    required this.groupName,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['host'] = Variable<String>(host);
    map['port'] = Variable<int>(port);
    map['username'] = Variable<String>(username);
    map['auth_type'] = Variable<String>(authType);
    if (!nullToAbsent || keyFilePath != null) {
      map['key_file_path'] = Variable<String>(keyFilePath);
    }
    map['group_name'] = Variable<String>(groupName);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  HostsTableCompanion toCompanion(bool nullToAbsent) {
    return HostsTableCompanion(
      id: Value(id),
      name: Value(name),
      host: Value(host),
      port: Value(port),
      username: Value(username),
      authType: Value(authType),
      keyFilePath: keyFilePath == null && nullToAbsent
          ? const Value.absent()
          : Value(keyFilePath),
      groupName: Value(groupName),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory HostEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HostEntry(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      host: serializer.fromJson<String>(json['host']),
      port: serializer.fromJson<int>(json['port']),
      username: serializer.fromJson<String>(json['username']),
      authType: serializer.fromJson<String>(json['authType']),
      keyFilePath: serializer.fromJson<String?>(json['keyFilePath']),
      groupName: serializer.fromJson<String>(json['groupName']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'host': serializer.toJson<String>(host),
      'port': serializer.toJson<int>(port),
      'username': serializer.toJson<String>(username),
      'authType': serializer.toJson<String>(authType),
      'keyFilePath': serializer.toJson<String?>(keyFilePath),
      'groupName': serializer.toJson<String>(groupName),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  HostEntry copyWith({
    String? id,
    String? name,
    String? host,
    int? port,
    String? username,
    String? authType,
    Value<String?> keyFilePath = const Value.absent(),
    String? groupName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => HostEntry(
    id: id ?? this.id,
    name: name ?? this.name,
    host: host ?? this.host,
    port: port ?? this.port,
    username: username ?? this.username,
    authType: authType ?? this.authType,
    keyFilePath: keyFilePath.present ? keyFilePath.value : this.keyFilePath,
    groupName: groupName ?? this.groupName,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  HostEntry copyWithCompanion(HostsTableCompanion data) {
    return HostEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      host: data.host.present ? data.host.value : this.host,
      port: data.port.present ? data.port.value : this.port,
      username: data.username.present ? data.username.value : this.username,
      authType: data.authType.present ? data.authType.value : this.authType,
      keyFilePath: data.keyFilePath.present
          ? data.keyFilePath.value
          : this.keyFilePath,
      groupName: data.groupName.present ? data.groupName.value : this.groupName,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HostEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('host: $host, ')
          ..write('port: $port, ')
          ..write('username: $username, ')
          ..write('authType: $authType, ')
          ..write('keyFilePath: $keyFilePath, ')
          ..write('groupName: $groupName, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    host,
    port,
    username,
    authType,
    keyFilePath,
    groupName,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HostEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.host == this.host &&
          other.port == this.port &&
          other.username == this.username &&
          other.authType == this.authType &&
          other.keyFilePath == this.keyFilePath &&
          other.groupName == this.groupName &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class HostsTableCompanion extends UpdateCompanion<HostEntry> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> host;
  final Value<int> port;
  final Value<String> username;
  final Value<String> authType;
  final Value<String?> keyFilePath;
  final Value<String> groupName;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const HostsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.host = const Value.absent(),
    this.port = const Value.absent(),
    this.username = const Value.absent(),
    this.authType = const Value.absent(),
    this.keyFilePath = const Value.absent(),
    this.groupName = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HostsTableCompanion.insert({
    required String id,
    required String name,
    required String host,
    this.port = const Value.absent(),
    required String username,
    required String authType,
    this.keyFilePath = const Value.absent(),
    this.groupName = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       host = Value(host),
       username = Value(username),
       authType = Value(authType),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<HostEntry> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? host,
    Expression<int>? port,
    Expression<String>? username,
    Expression<String>? authType,
    Expression<String>? keyFilePath,
    Expression<String>? groupName,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (host != null) 'host': host,
      if (port != null) 'port': port,
      if (username != null) 'username': username,
      if (authType != null) 'auth_type': authType,
      if (keyFilePath != null) 'key_file_path': keyFilePath,
      if (groupName != null) 'group_name': groupName,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HostsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? host,
    Value<int>? port,
    Value<String>? username,
    Value<String>? authType,
    Value<String?>? keyFilePath,
    Value<String>? groupName,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return HostsTableCompanion(
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
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (host.present) {
      map['host'] = Variable<String>(host.value);
    }
    if (port.present) {
      map['port'] = Variable<int>(port.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (authType.present) {
      map['auth_type'] = Variable<String>(authType.value);
    }
    if (keyFilePath.present) {
      map['key_file_path'] = Variable<String>(keyFilePath.value);
    }
    if (groupName.present) {
      map['group_name'] = Variable<String>(groupName.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HostsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('host: $host, ')
          ..write('port: $port, ')
          ..write('username: $username, ')
          ..write('authType: $authType, ')
          ..write('keyFilePath: $keyFilePath, ')
          ..write('groupName: $groupName, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShortcutCommandsTableTable extends ShortcutCommandsTable
    with TableInfo<$ShortcutCommandsTableTable, ShortcutEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShortcutCommandsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hostIdMeta = const VerificationMeta('hostId');
  @override
  late final GeneratedColumn<String> hostId = GeneratedColumn<String>(
    'host_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _commandMeta = const VerificationMeta(
    'command',
  );
  @override
  late final GeneratedColumn<String> command = GeneratedColumn<String>(
    'command',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workingDirectoryMeta = const VerificationMeta(
    'workingDirectory',
  );
  @override
  late final GeneratedColumn<String> workingDirectory = GeneratedColumn<String>(
    'working_directory',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timeoutSecondsMeta = const VerificationMeta(
    'timeoutSeconds',
  );
  @override
  late final GeneratedColumn<int> timeoutSeconds = GeneratedColumn<int>(
    'timeout_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(30),
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Geral'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    hostId,
    name,
    command,
    workingDirectory,
    timeoutSeconds,
    category,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shortcut_commands_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShortcutEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('host_id')) {
      context.handle(
        _hostIdMeta,
        hostId.isAcceptableOrUnknown(data['host_id']!, _hostIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('command')) {
      context.handle(
        _commandMeta,
        command.isAcceptableOrUnknown(data['command']!, _commandMeta),
      );
    } else if (isInserting) {
      context.missing(_commandMeta);
    }
    if (data.containsKey('working_directory')) {
      context.handle(
        _workingDirectoryMeta,
        workingDirectory.isAcceptableOrUnknown(
          data['working_directory']!,
          _workingDirectoryMeta,
        ),
      );
    }
    if (data.containsKey('timeout_seconds')) {
      context.handle(
        _timeoutSecondsMeta,
        timeoutSeconds.isAcceptableOrUnknown(
          data['timeout_seconds']!,
          _timeoutSecondsMeta,
        ),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShortcutEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShortcutEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      hostId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}host_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      command: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}command'],
      )!,
      workingDirectory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}working_directory'],
      ),
      timeoutSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}timeout_seconds'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ShortcutCommandsTableTable createAlias(String alias) {
    return $ShortcutCommandsTableTable(attachedDatabase, alias);
  }
}

class ShortcutEntry extends DataClass implements Insertable<ShortcutEntry> {
  final String id;
  final String? hostId;
  final String name;
  final String command;
  final String? workingDirectory;
  final int timeoutSeconds;
  final String category;
  final DateTime createdAt;
  const ShortcutEntry({
    required this.id,
    this.hostId,
    required this.name,
    required this.command,
    this.workingDirectory,
    required this.timeoutSeconds,
    required this.category,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || hostId != null) {
      map['host_id'] = Variable<String>(hostId);
    }
    map['name'] = Variable<String>(name);
    map['command'] = Variable<String>(command);
    if (!nullToAbsent || workingDirectory != null) {
      map['working_directory'] = Variable<String>(workingDirectory);
    }
    map['timeout_seconds'] = Variable<int>(timeoutSeconds);
    map['category'] = Variable<String>(category);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ShortcutCommandsTableCompanion toCompanion(bool nullToAbsent) {
    return ShortcutCommandsTableCompanion(
      id: Value(id),
      hostId: hostId == null && nullToAbsent
          ? const Value.absent()
          : Value(hostId),
      name: Value(name),
      command: Value(command),
      workingDirectory: workingDirectory == null && nullToAbsent
          ? const Value.absent()
          : Value(workingDirectory),
      timeoutSeconds: Value(timeoutSeconds),
      category: Value(category),
      createdAt: Value(createdAt),
    );
  }

  factory ShortcutEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShortcutEntry(
      id: serializer.fromJson<String>(json['id']),
      hostId: serializer.fromJson<String?>(json['hostId']),
      name: serializer.fromJson<String>(json['name']),
      command: serializer.fromJson<String>(json['command']),
      workingDirectory: serializer.fromJson<String?>(json['workingDirectory']),
      timeoutSeconds: serializer.fromJson<int>(json['timeoutSeconds']),
      category: serializer.fromJson<String>(json['category']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'hostId': serializer.toJson<String?>(hostId),
      'name': serializer.toJson<String>(name),
      'command': serializer.toJson<String>(command),
      'workingDirectory': serializer.toJson<String?>(workingDirectory),
      'timeoutSeconds': serializer.toJson<int>(timeoutSeconds),
      'category': serializer.toJson<String>(category),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ShortcutEntry copyWith({
    String? id,
    Value<String?> hostId = const Value.absent(),
    String? name,
    String? command,
    Value<String?> workingDirectory = const Value.absent(),
    int? timeoutSeconds,
    String? category,
    DateTime? createdAt,
  }) => ShortcutEntry(
    id: id ?? this.id,
    hostId: hostId.present ? hostId.value : this.hostId,
    name: name ?? this.name,
    command: command ?? this.command,
    workingDirectory: workingDirectory.present
        ? workingDirectory.value
        : this.workingDirectory,
    timeoutSeconds: timeoutSeconds ?? this.timeoutSeconds,
    category: category ?? this.category,
    createdAt: createdAt ?? this.createdAt,
  );
  ShortcutEntry copyWithCompanion(ShortcutCommandsTableCompanion data) {
    return ShortcutEntry(
      id: data.id.present ? data.id.value : this.id,
      hostId: data.hostId.present ? data.hostId.value : this.hostId,
      name: data.name.present ? data.name.value : this.name,
      command: data.command.present ? data.command.value : this.command,
      workingDirectory: data.workingDirectory.present
          ? data.workingDirectory.value
          : this.workingDirectory,
      timeoutSeconds: data.timeoutSeconds.present
          ? data.timeoutSeconds.value
          : this.timeoutSeconds,
      category: data.category.present ? data.category.value : this.category,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShortcutEntry(')
          ..write('id: $id, ')
          ..write('hostId: $hostId, ')
          ..write('name: $name, ')
          ..write('command: $command, ')
          ..write('workingDirectory: $workingDirectory, ')
          ..write('timeoutSeconds: $timeoutSeconds, ')
          ..write('category: $category, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    hostId,
    name,
    command,
    workingDirectory,
    timeoutSeconds,
    category,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShortcutEntry &&
          other.id == this.id &&
          other.hostId == this.hostId &&
          other.name == this.name &&
          other.command == this.command &&
          other.workingDirectory == this.workingDirectory &&
          other.timeoutSeconds == this.timeoutSeconds &&
          other.category == this.category &&
          other.createdAt == this.createdAt);
}

class ShortcutCommandsTableCompanion extends UpdateCompanion<ShortcutEntry> {
  final Value<String> id;
  final Value<String?> hostId;
  final Value<String> name;
  final Value<String> command;
  final Value<String?> workingDirectory;
  final Value<int> timeoutSeconds;
  final Value<String> category;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ShortcutCommandsTableCompanion({
    this.id = const Value.absent(),
    this.hostId = const Value.absent(),
    this.name = const Value.absent(),
    this.command = const Value.absent(),
    this.workingDirectory = const Value.absent(),
    this.timeoutSeconds = const Value.absent(),
    this.category = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShortcutCommandsTableCompanion.insert({
    required String id,
    this.hostId = const Value.absent(),
    required String name,
    required String command,
    this.workingDirectory = const Value.absent(),
    this.timeoutSeconds = const Value.absent(),
    this.category = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       command = Value(command),
       createdAt = Value(createdAt);
  static Insertable<ShortcutEntry> custom({
    Expression<String>? id,
    Expression<String>? hostId,
    Expression<String>? name,
    Expression<String>? command,
    Expression<String>? workingDirectory,
    Expression<int>? timeoutSeconds,
    Expression<String>? category,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (hostId != null) 'host_id': hostId,
      if (name != null) 'name': name,
      if (command != null) 'command': command,
      if (workingDirectory != null) 'working_directory': workingDirectory,
      if (timeoutSeconds != null) 'timeout_seconds': timeoutSeconds,
      if (category != null) 'category': category,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShortcutCommandsTableCompanion copyWith({
    Value<String>? id,
    Value<String?>? hostId,
    Value<String>? name,
    Value<String>? command,
    Value<String?>? workingDirectory,
    Value<int>? timeoutSeconds,
    Value<String>? category,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ShortcutCommandsTableCompanion(
      id: id ?? this.id,
      hostId: hostId ?? this.hostId,
      name: name ?? this.name,
      command: command ?? this.command,
      workingDirectory: workingDirectory ?? this.workingDirectory,
      timeoutSeconds: timeoutSeconds ?? this.timeoutSeconds,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (hostId.present) {
      map['host_id'] = Variable<String>(hostId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (command.present) {
      map['command'] = Variable<String>(command.value);
    }
    if (workingDirectory.present) {
      map['working_directory'] = Variable<String>(workingDirectory.value);
    }
    if (timeoutSeconds.present) {
      map['timeout_seconds'] = Variable<int>(timeoutSeconds.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShortcutCommandsTableCompanion(')
          ..write('id: $id, ')
          ..write('hostId: $hostId, ')
          ..write('name: $name, ')
          ..write('command: $command, ')
          ..write('workingDirectory: $workingDirectory, ')
          ..write('timeoutSeconds: $timeoutSeconds, ')
          ..write('category: $category, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExecutionHistoryTableTable extends ExecutionHistoryTable
    with TableInfo<$ExecutionHistoryTableTable, ExecutionHistoryEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExecutionHistoryTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hostIdMeta = const VerificationMeta('hostId');
  @override
  late final GeneratedColumn<String> hostId = GeneratedColumn<String>(
    'host_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shortcutIdMeta = const VerificationMeta(
    'shortcutId',
  );
  @override
  late final GeneratedColumn<String> shortcutId = GeneratedColumn<String>(
    'shortcut_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _commandMeta = const VerificationMeta(
    'command',
  );
  @override
  late final GeneratedColumn<String> command = GeneratedColumn<String>(
    'command',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exitCodeMeta = const VerificationMeta(
    'exitCode',
  );
  @override
  late final GeneratedColumn<int> exitCode = GeneratedColumn<int>(
    'exit_code',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stdoutMeta = const VerificationMeta('stdout');
  @override
  late final GeneratedColumn<String> stdout = GeneratedColumn<String>(
    'stdout',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stderrMeta = const VerificationMeta('stderr');
  @override
  late final GeneratedColumn<String> stderr = GeneratedColumn<String>(
    'stderr',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMsMeta = const VerificationMeta(
    'durationMs',
  );
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _executedAtMeta = const VerificationMeta(
    'executedAt',
  );
  @override
  late final GeneratedColumn<DateTime> executedAt = GeneratedColumn<DateTime>(
    'executed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    hostId,
    shortcutId,
    command,
    exitCode,
    stdout,
    stderr,
    durationMs,
    executedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'execution_history_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExecutionHistoryEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('host_id')) {
      context.handle(
        _hostIdMeta,
        hostId.isAcceptableOrUnknown(data['host_id']!, _hostIdMeta),
      );
    } else if (isInserting) {
      context.missing(_hostIdMeta);
    }
    if (data.containsKey('shortcut_id')) {
      context.handle(
        _shortcutIdMeta,
        shortcutId.isAcceptableOrUnknown(data['shortcut_id']!, _shortcutIdMeta),
      );
    }
    if (data.containsKey('command')) {
      context.handle(
        _commandMeta,
        command.isAcceptableOrUnknown(data['command']!, _commandMeta),
      );
    } else if (isInserting) {
      context.missing(_commandMeta);
    }
    if (data.containsKey('exit_code')) {
      context.handle(
        _exitCodeMeta,
        exitCode.isAcceptableOrUnknown(data['exit_code']!, _exitCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_exitCodeMeta);
    }
    if (data.containsKey('stdout')) {
      context.handle(
        _stdoutMeta,
        stdout.isAcceptableOrUnknown(data['stdout']!, _stdoutMeta),
      );
    } else if (isInserting) {
      context.missing(_stdoutMeta);
    }
    if (data.containsKey('stderr')) {
      context.handle(
        _stderrMeta,
        stderr.isAcceptableOrUnknown(data['stderr']!, _stderrMeta),
      );
    } else if (isInserting) {
      context.missing(_stderrMeta);
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
        _durationMsMeta,
        durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
      );
    } else if (isInserting) {
      context.missing(_durationMsMeta);
    }
    if (data.containsKey('executed_at')) {
      context.handle(
        _executedAtMeta,
        executedAt.isAcceptableOrUnknown(data['executed_at']!, _executedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_executedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExecutionHistoryEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExecutionHistoryEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      hostId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}host_id'],
      )!,
      shortcutId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shortcut_id'],
      ),
      command: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}command'],
      )!,
      exitCode: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exit_code'],
      )!,
      stdout: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stdout'],
      )!,
      stderr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stderr'],
      )!,
      durationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_ms'],
      )!,
      executedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}executed_at'],
      )!,
    );
  }

  @override
  $ExecutionHistoryTableTable createAlias(String alias) {
    return $ExecutionHistoryTableTable(attachedDatabase, alias);
  }
}

class ExecutionHistoryEntry extends DataClass
    implements Insertable<ExecutionHistoryEntry> {
  final String id;
  final String hostId;
  final String? shortcutId;
  final String command;
  final int exitCode;
  final String stdout;
  final String stderr;
  final int durationMs;
  final DateTime executedAt;
  const ExecutionHistoryEntry({
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
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['host_id'] = Variable<String>(hostId);
    if (!nullToAbsent || shortcutId != null) {
      map['shortcut_id'] = Variable<String>(shortcutId);
    }
    map['command'] = Variable<String>(command);
    map['exit_code'] = Variable<int>(exitCode);
    map['stdout'] = Variable<String>(stdout);
    map['stderr'] = Variable<String>(stderr);
    map['duration_ms'] = Variable<int>(durationMs);
    map['executed_at'] = Variable<DateTime>(executedAt);
    return map;
  }

  ExecutionHistoryTableCompanion toCompanion(bool nullToAbsent) {
    return ExecutionHistoryTableCompanion(
      id: Value(id),
      hostId: Value(hostId),
      shortcutId: shortcutId == null && nullToAbsent
          ? const Value.absent()
          : Value(shortcutId),
      command: Value(command),
      exitCode: Value(exitCode),
      stdout: Value(stdout),
      stderr: Value(stderr),
      durationMs: Value(durationMs),
      executedAt: Value(executedAt),
    );
  }

  factory ExecutionHistoryEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExecutionHistoryEntry(
      id: serializer.fromJson<String>(json['id']),
      hostId: serializer.fromJson<String>(json['hostId']),
      shortcutId: serializer.fromJson<String?>(json['shortcutId']),
      command: serializer.fromJson<String>(json['command']),
      exitCode: serializer.fromJson<int>(json['exitCode']),
      stdout: serializer.fromJson<String>(json['stdout']),
      stderr: serializer.fromJson<String>(json['stderr']),
      durationMs: serializer.fromJson<int>(json['durationMs']),
      executedAt: serializer.fromJson<DateTime>(json['executedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'hostId': serializer.toJson<String>(hostId),
      'shortcutId': serializer.toJson<String?>(shortcutId),
      'command': serializer.toJson<String>(command),
      'exitCode': serializer.toJson<int>(exitCode),
      'stdout': serializer.toJson<String>(stdout),
      'stderr': serializer.toJson<String>(stderr),
      'durationMs': serializer.toJson<int>(durationMs),
      'executedAt': serializer.toJson<DateTime>(executedAt),
    };
  }

  ExecutionHistoryEntry copyWith({
    String? id,
    String? hostId,
    Value<String?> shortcutId = const Value.absent(),
    String? command,
    int? exitCode,
    String? stdout,
    String? stderr,
    int? durationMs,
    DateTime? executedAt,
  }) => ExecutionHistoryEntry(
    id: id ?? this.id,
    hostId: hostId ?? this.hostId,
    shortcutId: shortcutId.present ? shortcutId.value : this.shortcutId,
    command: command ?? this.command,
    exitCode: exitCode ?? this.exitCode,
    stdout: stdout ?? this.stdout,
    stderr: stderr ?? this.stderr,
    durationMs: durationMs ?? this.durationMs,
    executedAt: executedAt ?? this.executedAt,
  );
  ExecutionHistoryEntry copyWithCompanion(ExecutionHistoryTableCompanion data) {
    return ExecutionHistoryEntry(
      id: data.id.present ? data.id.value : this.id,
      hostId: data.hostId.present ? data.hostId.value : this.hostId,
      shortcutId: data.shortcutId.present
          ? data.shortcutId.value
          : this.shortcutId,
      command: data.command.present ? data.command.value : this.command,
      exitCode: data.exitCode.present ? data.exitCode.value : this.exitCode,
      stdout: data.stdout.present ? data.stdout.value : this.stdout,
      stderr: data.stderr.present ? data.stderr.value : this.stderr,
      durationMs: data.durationMs.present
          ? data.durationMs.value
          : this.durationMs,
      executedAt: data.executedAt.present
          ? data.executedAt.value
          : this.executedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExecutionHistoryEntry(')
          ..write('id: $id, ')
          ..write('hostId: $hostId, ')
          ..write('shortcutId: $shortcutId, ')
          ..write('command: $command, ')
          ..write('exitCode: $exitCode, ')
          ..write('stdout: $stdout, ')
          ..write('stderr: $stderr, ')
          ..write('durationMs: $durationMs, ')
          ..write('executedAt: $executedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    hostId,
    shortcutId,
    command,
    exitCode,
    stdout,
    stderr,
    durationMs,
    executedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExecutionHistoryEntry &&
          other.id == this.id &&
          other.hostId == this.hostId &&
          other.shortcutId == this.shortcutId &&
          other.command == this.command &&
          other.exitCode == this.exitCode &&
          other.stdout == this.stdout &&
          other.stderr == this.stderr &&
          other.durationMs == this.durationMs &&
          other.executedAt == this.executedAt);
}

class ExecutionHistoryTableCompanion
    extends UpdateCompanion<ExecutionHistoryEntry> {
  final Value<String> id;
  final Value<String> hostId;
  final Value<String?> shortcutId;
  final Value<String> command;
  final Value<int> exitCode;
  final Value<String> stdout;
  final Value<String> stderr;
  final Value<int> durationMs;
  final Value<DateTime> executedAt;
  final Value<int> rowid;
  const ExecutionHistoryTableCompanion({
    this.id = const Value.absent(),
    this.hostId = const Value.absent(),
    this.shortcutId = const Value.absent(),
    this.command = const Value.absent(),
    this.exitCode = const Value.absent(),
    this.stdout = const Value.absent(),
    this.stderr = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.executedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExecutionHistoryTableCompanion.insert({
    required String id,
    required String hostId,
    this.shortcutId = const Value.absent(),
    required String command,
    required int exitCode,
    required String stdout,
    required String stderr,
    required int durationMs,
    required DateTime executedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       hostId = Value(hostId),
       command = Value(command),
       exitCode = Value(exitCode),
       stdout = Value(stdout),
       stderr = Value(stderr),
       durationMs = Value(durationMs),
       executedAt = Value(executedAt);
  static Insertable<ExecutionHistoryEntry> custom({
    Expression<String>? id,
    Expression<String>? hostId,
    Expression<String>? shortcutId,
    Expression<String>? command,
    Expression<int>? exitCode,
    Expression<String>? stdout,
    Expression<String>? stderr,
    Expression<int>? durationMs,
    Expression<DateTime>? executedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (hostId != null) 'host_id': hostId,
      if (shortcutId != null) 'shortcut_id': shortcutId,
      if (command != null) 'command': command,
      if (exitCode != null) 'exit_code': exitCode,
      if (stdout != null) 'stdout': stdout,
      if (stderr != null) 'stderr': stderr,
      if (durationMs != null) 'duration_ms': durationMs,
      if (executedAt != null) 'executed_at': executedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExecutionHistoryTableCompanion copyWith({
    Value<String>? id,
    Value<String>? hostId,
    Value<String?>? shortcutId,
    Value<String>? command,
    Value<int>? exitCode,
    Value<String>? stdout,
    Value<String>? stderr,
    Value<int>? durationMs,
    Value<DateTime>? executedAt,
    Value<int>? rowid,
  }) {
    return ExecutionHistoryTableCompanion(
      id: id ?? this.id,
      hostId: hostId ?? this.hostId,
      shortcutId: shortcutId ?? this.shortcutId,
      command: command ?? this.command,
      exitCode: exitCode ?? this.exitCode,
      stdout: stdout ?? this.stdout,
      stderr: stderr ?? this.stderr,
      durationMs: durationMs ?? this.durationMs,
      executedAt: executedAt ?? this.executedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (hostId.present) {
      map['host_id'] = Variable<String>(hostId.value);
    }
    if (shortcutId.present) {
      map['shortcut_id'] = Variable<String>(shortcutId.value);
    }
    if (command.present) {
      map['command'] = Variable<String>(command.value);
    }
    if (exitCode.present) {
      map['exit_code'] = Variable<int>(exitCode.value);
    }
    if (stdout.present) {
      map['stdout'] = Variable<String>(stdout.value);
    }
    if (stderr.present) {
      map['stderr'] = Variable<String>(stderr.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (executedAt.present) {
      map['executed_at'] = Variable<DateTime>(executedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExecutionHistoryTableCompanion(')
          ..write('id: $id, ')
          ..write('hostId: $hostId, ')
          ..write('shortcutId: $shortcutId, ')
          ..write('command: $command, ')
          ..write('exitCode: $exitCode, ')
          ..write('stdout: $stdout, ')
          ..write('stderr: $stderr, ')
          ..write('durationMs: $durationMs, ')
          ..write('executedAt: $executedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TrustedHostKeysTableTable extends TrustedHostKeysTable
    with TableInfo<$TrustedHostKeysTableTable, TrustedHostKeyEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrustedHostKeysTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _hostnameMeta = const VerificationMeta(
    'hostname',
  );
  @override
  late final GeneratedColumn<String> hostname = GeneratedColumn<String>(
    'hostname',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _portMeta = const VerificationMeta('port');
  @override
  late final GeneratedColumn<int> port = GeneratedColumn<int>(
    'port',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _algorithmMeta = const VerificationMeta(
    'algorithm',
  );
  @override
  late final GeneratedColumn<String> algorithm = GeneratedColumn<String>(
    'algorithm',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fingerprintMeta = const VerificationMeta(
    'fingerprint',
  );
  @override
  late final GeneratedColumn<String> fingerprint = GeneratedColumn<String>(
    'fingerprint',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _firstConfirmedAtMeta = const VerificationMeta(
    'firstConfirmedAt',
  );
  @override
  late final GeneratedColumn<DateTime> firstConfirmedAt =
      GeneratedColumn<DateTime>(
        'first_confirmed_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _lastVerifiedAtMeta = const VerificationMeta(
    'lastVerifiedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastVerifiedAt =
      GeneratedColumn<DateTime>(
        'last_verified_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    hostname,
    port,
    algorithm,
    fingerprint,
    firstConfirmedAt,
    lastVerifiedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trusted_host_keys_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<TrustedHostKeyEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('hostname')) {
      context.handle(
        _hostnameMeta,
        hostname.isAcceptableOrUnknown(data['hostname']!, _hostnameMeta),
      );
    } else if (isInserting) {
      context.missing(_hostnameMeta);
    }
    if (data.containsKey('port')) {
      context.handle(
        _portMeta,
        port.isAcceptableOrUnknown(data['port']!, _portMeta),
      );
    } else if (isInserting) {
      context.missing(_portMeta);
    }
    if (data.containsKey('algorithm')) {
      context.handle(
        _algorithmMeta,
        algorithm.isAcceptableOrUnknown(data['algorithm']!, _algorithmMeta),
      );
    } else if (isInserting) {
      context.missing(_algorithmMeta);
    }
    if (data.containsKey('fingerprint')) {
      context.handle(
        _fingerprintMeta,
        fingerprint.isAcceptableOrUnknown(
          data['fingerprint']!,
          _fingerprintMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fingerprintMeta);
    }
    if (data.containsKey('first_confirmed_at')) {
      context.handle(
        _firstConfirmedAtMeta,
        firstConfirmedAt.isAcceptableOrUnknown(
          data['first_confirmed_at']!,
          _firstConfirmedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_firstConfirmedAtMeta);
    }
    if (data.containsKey('last_verified_at')) {
      context.handle(
        _lastVerifiedAtMeta,
        lastVerifiedAt.isAcceptableOrUnknown(
          data['last_verified_at']!,
          _lastVerifiedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastVerifiedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {hostname, port};
  @override
  TrustedHostKeyEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrustedHostKeyEntry(
      hostname: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hostname'],
      )!,
      port: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}port'],
      )!,
      algorithm: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}algorithm'],
      )!,
      fingerprint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fingerprint'],
      )!,
      firstConfirmedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}first_confirmed_at'],
      )!,
      lastVerifiedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_verified_at'],
      )!,
    );
  }

  @override
  $TrustedHostKeysTableTable createAlias(String alias) {
    return $TrustedHostKeysTableTable(attachedDatabase, alias);
  }
}

class TrustedHostKeyEntry extends DataClass
    implements Insertable<TrustedHostKeyEntry> {
  final String hostname;
  final int port;
  final String algorithm;
  final String fingerprint;
  final DateTime firstConfirmedAt;
  final DateTime lastVerifiedAt;
  const TrustedHostKeyEntry({
    required this.hostname,
    required this.port,
    required this.algorithm,
    required this.fingerprint,
    required this.firstConfirmedAt,
    required this.lastVerifiedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['hostname'] = Variable<String>(hostname);
    map['port'] = Variable<int>(port);
    map['algorithm'] = Variable<String>(algorithm);
    map['fingerprint'] = Variable<String>(fingerprint);
    map['first_confirmed_at'] = Variable<DateTime>(firstConfirmedAt);
    map['last_verified_at'] = Variable<DateTime>(lastVerifiedAt);
    return map;
  }

  TrustedHostKeysTableCompanion toCompanion(bool nullToAbsent) {
    return TrustedHostKeysTableCompanion(
      hostname: Value(hostname),
      port: Value(port),
      algorithm: Value(algorithm),
      fingerprint: Value(fingerprint),
      firstConfirmedAt: Value(firstConfirmedAt),
      lastVerifiedAt: Value(lastVerifiedAt),
    );
  }

  factory TrustedHostKeyEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrustedHostKeyEntry(
      hostname: serializer.fromJson<String>(json['hostname']),
      port: serializer.fromJson<int>(json['port']),
      algorithm: serializer.fromJson<String>(json['algorithm']),
      fingerprint: serializer.fromJson<String>(json['fingerprint']),
      firstConfirmedAt: serializer.fromJson<DateTime>(json['firstConfirmedAt']),
      lastVerifiedAt: serializer.fromJson<DateTime>(json['lastVerifiedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'hostname': serializer.toJson<String>(hostname),
      'port': serializer.toJson<int>(port),
      'algorithm': serializer.toJson<String>(algorithm),
      'fingerprint': serializer.toJson<String>(fingerprint),
      'firstConfirmedAt': serializer.toJson<DateTime>(firstConfirmedAt),
      'lastVerifiedAt': serializer.toJson<DateTime>(lastVerifiedAt),
    };
  }

  TrustedHostKeyEntry copyWith({
    String? hostname,
    int? port,
    String? algorithm,
    String? fingerprint,
    DateTime? firstConfirmedAt,
    DateTime? lastVerifiedAt,
  }) => TrustedHostKeyEntry(
    hostname: hostname ?? this.hostname,
    port: port ?? this.port,
    algorithm: algorithm ?? this.algorithm,
    fingerprint: fingerprint ?? this.fingerprint,
    firstConfirmedAt: firstConfirmedAt ?? this.firstConfirmedAt,
    lastVerifiedAt: lastVerifiedAt ?? this.lastVerifiedAt,
  );
  TrustedHostKeyEntry copyWithCompanion(TrustedHostKeysTableCompanion data) {
    return TrustedHostKeyEntry(
      hostname: data.hostname.present ? data.hostname.value : this.hostname,
      port: data.port.present ? data.port.value : this.port,
      algorithm: data.algorithm.present ? data.algorithm.value : this.algorithm,
      fingerprint: data.fingerprint.present
          ? data.fingerprint.value
          : this.fingerprint,
      firstConfirmedAt: data.firstConfirmedAt.present
          ? data.firstConfirmedAt.value
          : this.firstConfirmedAt,
      lastVerifiedAt: data.lastVerifiedAt.present
          ? data.lastVerifiedAt.value
          : this.lastVerifiedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrustedHostKeyEntry(')
          ..write('hostname: $hostname, ')
          ..write('port: $port, ')
          ..write('algorithm: $algorithm, ')
          ..write('fingerprint: $fingerprint, ')
          ..write('firstConfirmedAt: $firstConfirmedAt, ')
          ..write('lastVerifiedAt: $lastVerifiedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    hostname,
    port,
    algorithm,
    fingerprint,
    firstConfirmedAt,
    lastVerifiedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrustedHostKeyEntry &&
          other.hostname == this.hostname &&
          other.port == this.port &&
          other.algorithm == this.algorithm &&
          other.fingerprint == this.fingerprint &&
          other.firstConfirmedAt == this.firstConfirmedAt &&
          other.lastVerifiedAt == this.lastVerifiedAt);
}

class TrustedHostKeysTableCompanion
    extends UpdateCompanion<TrustedHostKeyEntry> {
  final Value<String> hostname;
  final Value<int> port;
  final Value<String> algorithm;
  final Value<String> fingerprint;
  final Value<DateTime> firstConfirmedAt;
  final Value<DateTime> lastVerifiedAt;
  final Value<int> rowid;
  const TrustedHostKeysTableCompanion({
    this.hostname = const Value.absent(),
    this.port = const Value.absent(),
    this.algorithm = const Value.absent(),
    this.fingerprint = const Value.absent(),
    this.firstConfirmedAt = const Value.absent(),
    this.lastVerifiedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TrustedHostKeysTableCompanion.insert({
    required String hostname,
    required int port,
    required String algorithm,
    required String fingerprint,
    required DateTime firstConfirmedAt,
    required DateTime lastVerifiedAt,
    this.rowid = const Value.absent(),
  }) : hostname = Value(hostname),
       port = Value(port),
       algorithm = Value(algorithm),
       fingerprint = Value(fingerprint),
       firstConfirmedAt = Value(firstConfirmedAt),
       lastVerifiedAt = Value(lastVerifiedAt);
  static Insertable<TrustedHostKeyEntry> custom({
    Expression<String>? hostname,
    Expression<int>? port,
    Expression<String>? algorithm,
    Expression<String>? fingerprint,
    Expression<DateTime>? firstConfirmedAt,
    Expression<DateTime>? lastVerifiedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (hostname != null) 'hostname': hostname,
      if (port != null) 'port': port,
      if (algorithm != null) 'algorithm': algorithm,
      if (fingerprint != null) 'fingerprint': fingerprint,
      if (firstConfirmedAt != null) 'first_confirmed_at': firstConfirmedAt,
      if (lastVerifiedAt != null) 'last_verified_at': lastVerifiedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TrustedHostKeysTableCompanion copyWith({
    Value<String>? hostname,
    Value<int>? port,
    Value<String>? algorithm,
    Value<String>? fingerprint,
    Value<DateTime>? firstConfirmedAt,
    Value<DateTime>? lastVerifiedAt,
    Value<int>? rowid,
  }) {
    return TrustedHostKeysTableCompanion(
      hostname: hostname ?? this.hostname,
      port: port ?? this.port,
      algorithm: algorithm ?? this.algorithm,
      fingerprint: fingerprint ?? this.fingerprint,
      firstConfirmedAt: firstConfirmedAt ?? this.firstConfirmedAt,
      lastVerifiedAt: lastVerifiedAt ?? this.lastVerifiedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (hostname.present) {
      map['hostname'] = Variable<String>(hostname.value);
    }
    if (port.present) {
      map['port'] = Variable<int>(port.value);
    }
    if (algorithm.present) {
      map['algorithm'] = Variable<String>(algorithm.value);
    }
    if (fingerprint.present) {
      map['fingerprint'] = Variable<String>(fingerprint.value);
    }
    if (firstConfirmedAt.present) {
      map['first_confirmed_at'] = Variable<DateTime>(firstConfirmedAt.value);
    }
    if (lastVerifiedAt.present) {
      map['last_verified_at'] = Variable<DateTime>(lastVerifiedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrustedHostKeysTableCompanion(')
          ..write('hostname: $hostname, ')
          ..write('port: $port, ')
          ..write('algorithm: $algorithm, ')
          ..write('fingerprint: $fingerprint, ')
          ..write('firstConfirmedAt: $firstConfirmedAt, ')
          ..write('lastVerifiedAt: $lastVerifiedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TunnelsTableTable extends TunnelsTable
    with TableInfo<$TunnelsTableTable, TunnelEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TunnelsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hostIdMeta = const VerificationMeta('hostId');
  @override
  late final GeneratedColumn<String> hostId = GeneratedColumn<String>(
    'host_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES hosts_table (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _localHostMeta = const VerificationMeta(
    'localHost',
  );
  @override
  late final GeneratedColumn<String> localHost = GeneratedColumn<String>(
    'local_host',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('127.0.0.1'),
  );
  static const VerificationMeta _localPortMeta = const VerificationMeta(
    'localPort',
  );
  @override
  late final GeneratedColumn<int> localPort = GeneratedColumn<int>(
    'local_port',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _remoteHostMeta = const VerificationMeta(
    'remoteHost',
  );
  @override
  late final GeneratedColumn<String> remoteHost = GeneratedColumn<String>(
    'remote_host',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _remotePortMeta = const VerificationMeta(
    'remotePort',
  );
  @override
  late final GeneratedColumn<int> remotePort = GeneratedColumn<int>(
    'remote_port',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _autoReconnectMeta = const VerificationMeta(
    'autoReconnect',
  );
  @override
  late final GeneratedColumn<bool> autoReconnect = GeneratedColumn<bool>(
    'auto_reconnect',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("auto_reconnect" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _autoConnectMeta = const VerificationMeta(
    'autoConnect',
  );
  @override
  late final GeneratedColumn<bool> autoConnect = GeneratedColumn<bool>(
    'auto_connect',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("auto_connect" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    hostId,
    localHost,
    localPort,
    remoteHost,
    remotePort,
    autoReconnect,
    autoConnect,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tunnels_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<TunnelEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('host_id')) {
      context.handle(
        _hostIdMeta,
        hostId.isAcceptableOrUnknown(data['host_id']!, _hostIdMeta),
      );
    } else if (isInserting) {
      context.missing(_hostIdMeta);
    }
    if (data.containsKey('local_host')) {
      context.handle(
        _localHostMeta,
        localHost.isAcceptableOrUnknown(data['local_host']!, _localHostMeta),
      );
    }
    if (data.containsKey('local_port')) {
      context.handle(
        _localPortMeta,
        localPort.isAcceptableOrUnknown(data['local_port']!, _localPortMeta),
      );
    } else if (isInserting) {
      context.missing(_localPortMeta);
    }
    if (data.containsKey('remote_host')) {
      context.handle(
        _remoteHostMeta,
        remoteHost.isAcceptableOrUnknown(data['remote_host']!, _remoteHostMeta),
      );
    } else if (isInserting) {
      context.missing(_remoteHostMeta);
    }
    if (data.containsKey('remote_port')) {
      context.handle(
        _remotePortMeta,
        remotePort.isAcceptableOrUnknown(data['remote_port']!, _remotePortMeta),
      );
    } else if (isInserting) {
      context.missing(_remotePortMeta);
    }
    if (data.containsKey('auto_reconnect')) {
      context.handle(
        _autoReconnectMeta,
        autoReconnect.isAcceptableOrUnknown(
          data['auto_reconnect']!,
          _autoReconnectMeta,
        ),
      );
    }
    if (data.containsKey('auto_connect')) {
      context.handle(
        _autoConnectMeta,
        autoConnect.isAcceptableOrUnknown(
          data['auto_connect']!,
          _autoConnectMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TunnelEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TunnelEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      hostId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}host_id'],
      )!,
      localHost: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_host'],
      )!,
      localPort: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}local_port'],
      )!,
      remoteHost: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_host'],
      )!,
      remotePort: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}remote_port'],
      )!,
      autoReconnect: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}auto_reconnect'],
      )!,
      autoConnect: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}auto_connect'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TunnelsTableTable createAlias(String alias) {
    return $TunnelsTableTable(attachedDatabase, alias);
  }
}

class TunnelEntry extends DataClass implements Insertable<TunnelEntry> {
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
  const TunnelEntry({
    required this.id,
    required this.name,
    required this.hostId,
    required this.localHost,
    required this.localPort,
    required this.remoteHost,
    required this.remotePort,
    required this.autoReconnect,
    required this.autoConnect,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['host_id'] = Variable<String>(hostId);
    map['local_host'] = Variable<String>(localHost);
    map['local_port'] = Variable<int>(localPort);
    map['remote_host'] = Variable<String>(remoteHost);
    map['remote_port'] = Variable<int>(remotePort);
    map['auto_reconnect'] = Variable<bool>(autoReconnect);
    map['auto_connect'] = Variable<bool>(autoConnect);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TunnelsTableCompanion toCompanion(bool nullToAbsent) {
    return TunnelsTableCompanion(
      id: Value(id),
      name: Value(name),
      hostId: Value(hostId),
      localHost: Value(localHost),
      localPort: Value(localPort),
      remoteHost: Value(remoteHost),
      remotePort: Value(remotePort),
      autoReconnect: Value(autoReconnect),
      autoConnect: Value(autoConnect),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TunnelEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TunnelEntry(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      hostId: serializer.fromJson<String>(json['hostId']),
      localHost: serializer.fromJson<String>(json['localHost']),
      localPort: serializer.fromJson<int>(json['localPort']),
      remoteHost: serializer.fromJson<String>(json['remoteHost']),
      remotePort: serializer.fromJson<int>(json['remotePort']),
      autoReconnect: serializer.fromJson<bool>(json['autoReconnect']),
      autoConnect: serializer.fromJson<bool>(json['autoConnect']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'hostId': serializer.toJson<String>(hostId),
      'localHost': serializer.toJson<String>(localHost),
      'localPort': serializer.toJson<int>(localPort),
      'remoteHost': serializer.toJson<String>(remoteHost),
      'remotePort': serializer.toJson<int>(remotePort),
      'autoReconnect': serializer.toJson<bool>(autoReconnect),
      'autoConnect': serializer.toJson<bool>(autoConnect),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TunnelEntry copyWith({
    String? id,
    String? name,
    String? hostId,
    String? localHost,
    int? localPort,
    String? remoteHost,
    int? remotePort,
    bool? autoReconnect,
    bool? autoConnect,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => TunnelEntry(
    id: id ?? this.id,
    name: name ?? this.name,
    hostId: hostId ?? this.hostId,
    localHost: localHost ?? this.localHost,
    localPort: localPort ?? this.localPort,
    remoteHost: remoteHost ?? this.remoteHost,
    remotePort: remotePort ?? this.remotePort,
    autoReconnect: autoReconnect ?? this.autoReconnect,
    autoConnect: autoConnect ?? this.autoConnect,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TunnelEntry copyWithCompanion(TunnelsTableCompanion data) {
    return TunnelEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      hostId: data.hostId.present ? data.hostId.value : this.hostId,
      localHost: data.localHost.present ? data.localHost.value : this.localHost,
      localPort: data.localPort.present ? data.localPort.value : this.localPort,
      remoteHost: data.remoteHost.present
          ? data.remoteHost.value
          : this.remoteHost,
      remotePort: data.remotePort.present
          ? data.remotePort.value
          : this.remotePort,
      autoReconnect: data.autoReconnect.present
          ? data.autoReconnect.value
          : this.autoReconnect,
      autoConnect: data.autoConnect.present
          ? data.autoConnect.value
          : this.autoConnect,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TunnelEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('hostId: $hostId, ')
          ..write('localHost: $localHost, ')
          ..write('localPort: $localPort, ')
          ..write('remoteHost: $remoteHost, ')
          ..write('remotePort: $remotePort, ')
          ..write('autoReconnect: $autoReconnect, ')
          ..write('autoConnect: $autoConnect, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    hostId,
    localHost,
    localPort,
    remoteHost,
    remotePort,
    autoReconnect,
    autoConnect,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TunnelEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.hostId == this.hostId &&
          other.localHost == this.localHost &&
          other.localPort == this.localPort &&
          other.remoteHost == this.remoteHost &&
          other.remotePort == this.remotePort &&
          other.autoReconnect == this.autoReconnect &&
          other.autoConnect == this.autoConnect &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TunnelsTableCompanion extends UpdateCompanion<TunnelEntry> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> hostId;
  final Value<String> localHost;
  final Value<int> localPort;
  final Value<String> remoteHost;
  final Value<int> remotePort;
  final Value<bool> autoReconnect;
  final Value<bool> autoConnect;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TunnelsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.hostId = const Value.absent(),
    this.localHost = const Value.absent(),
    this.localPort = const Value.absent(),
    this.remoteHost = const Value.absent(),
    this.remotePort = const Value.absent(),
    this.autoReconnect = const Value.absent(),
    this.autoConnect = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TunnelsTableCompanion.insert({
    required String id,
    required String name,
    required String hostId,
    this.localHost = const Value.absent(),
    required int localPort,
    required String remoteHost,
    required int remotePort,
    this.autoReconnect = const Value.absent(),
    this.autoConnect = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       hostId = Value(hostId),
       localPort = Value(localPort),
       remoteHost = Value(remoteHost),
       remotePort = Value(remotePort),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<TunnelEntry> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? hostId,
    Expression<String>? localHost,
    Expression<int>? localPort,
    Expression<String>? remoteHost,
    Expression<int>? remotePort,
    Expression<bool>? autoReconnect,
    Expression<bool>? autoConnect,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (hostId != null) 'host_id': hostId,
      if (localHost != null) 'local_host': localHost,
      if (localPort != null) 'local_port': localPort,
      if (remoteHost != null) 'remote_host': remoteHost,
      if (remotePort != null) 'remote_port': remotePort,
      if (autoReconnect != null) 'auto_reconnect': autoReconnect,
      if (autoConnect != null) 'auto_connect': autoConnect,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TunnelsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? hostId,
    Value<String>? localHost,
    Value<int>? localPort,
    Value<String>? remoteHost,
    Value<int>? remotePort,
    Value<bool>? autoReconnect,
    Value<bool>? autoConnect,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return TunnelsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      hostId: hostId ?? this.hostId,
      localHost: localHost ?? this.localHost,
      localPort: localPort ?? this.localPort,
      remoteHost: remoteHost ?? this.remoteHost,
      remotePort: remotePort ?? this.remotePort,
      autoReconnect: autoReconnect ?? this.autoReconnect,
      autoConnect: autoConnect ?? this.autoConnect,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (hostId.present) {
      map['host_id'] = Variable<String>(hostId.value);
    }
    if (localHost.present) {
      map['local_host'] = Variable<String>(localHost.value);
    }
    if (localPort.present) {
      map['local_port'] = Variable<int>(localPort.value);
    }
    if (remoteHost.present) {
      map['remote_host'] = Variable<String>(remoteHost.value);
    }
    if (remotePort.present) {
      map['remote_port'] = Variable<int>(remotePort.value);
    }
    if (autoReconnect.present) {
      map['auto_reconnect'] = Variable<bool>(autoReconnect.value);
    }
    if (autoConnect.present) {
      map['auto_connect'] = Variable<bool>(autoConnect.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TunnelsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('hostId: $hostId, ')
          ..write('localHost: $localHost, ')
          ..write('localPort: $localPort, ')
          ..write('remoteHost: $remoteHost, ')
          ..write('remotePort: $remotePort, ')
          ..write('autoReconnect: $autoReconnect, ')
          ..write('autoConnect: $autoConnect, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $HostsTableTable hostsTable = $HostsTableTable(this);
  late final $ShortcutCommandsTableTable shortcutCommandsTable =
      $ShortcutCommandsTableTable(this);
  late final $ExecutionHistoryTableTable executionHistoryTable =
      $ExecutionHistoryTableTable(this);
  late final $TrustedHostKeysTableTable trustedHostKeysTable =
      $TrustedHostKeysTableTable(this);
  late final $TunnelsTableTable tunnelsTable = $TunnelsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    hostsTable,
    shortcutCommandsTable,
    executionHistoryTable,
    trustedHostKeysTable,
    tunnelsTable,
  ];
}

typedef $$HostsTableTableCreateCompanionBuilder = HostsTableCompanion Function({
  required String id,
  required String name,
  required String host,
  Value<int> port,
  required String username,
  required String authType,
  Value<String?> keyFilePath,
  Value<String> groupName,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$HostsTableTableUpdateCompanionBuilder = HostsTableCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> host,
  Value<int> port,
  Value<String> username,
  Value<String> authType,
  Value<String?> keyFilePath,
  Value<String> groupName,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$HostsTableTableReferences
    extends BaseReferences<_$AppDatabase, $HostsTableTable, HostEntry> {
  $$HostsTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TunnelsTableTable, List<TunnelEntry>>
  _tunnelsTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.tunnelsTable,
    aliasName: 'hosts_table__id__tunnels_table__host_id',
  );

  $$TunnelsTableTableProcessedTableManager get tunnelsTableRefs {
    final manager = $$TunnelsTableTableTableManager(
      $_db,
      $_db.tunnelsTable,
    ).filter((f) => f.hostId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_tunnelsTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$HostsTableTableFilterComposer
    extends Composer<_$AppDatabase, $HostsTableTable> {
  $$HostsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get host => $composableBuilder(
    column: $table.host,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get port => $composableBuilder(
    column: $table.port,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authType => $composableBuilder(
    column: $table.authType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get keyFilePath => $composableBuilder(
    column: $table.keyFilePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get groupName => $composableBuilder(
    column: $table.groupName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> tunnelsTableRefs(
    Expression<bool> Function($$TunnelsTableTableFilterComposer f) f,
  ) {
    final $$TunnelsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tunnelsTable,
      getReferencedColumn: (t) => t.hostId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TunnelsTableTableFilterComposer(
            $db: $db,
            $table: $db.tunnelsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HostsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $HostsTableTable> {
  $$HostsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get host => $composableBuilder(
    column: $table.host,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get port => $composableBuilder(
    column: $table.port,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authType => $composableBuilder(
    column: $table.authType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get keyFilePath => $composableBuilder(
    column: $table.keyFilePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get groupName => $composableBuilder(
    column: $table.groupName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HostsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $HostsTableTable> {
  $$HostsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get host =>
      $composableBuilder(column: $table.host, builder: (column) => column);

  GeneratedColumn<int> get port =>
      $composableBuilder(column: $table.port, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get authType =>
      $composableBuilder(column: $table.authType, builder: (column) => column);

  GeneratedColumn<String> get keyFilePath => $composableBuilder(
    column: $table.keyFilePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get groupName =>
      $composableBuilder(column: $table.groupName, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> tunnelsTableRefs<T extends Object>(
    Expression<T> Function($$TunnelsTableTableAnnotationComposer a) f,
  ) {
    final $$TunnelsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tunnelsTable,
      getReferencedColumn: (t) => t.hostId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TunnelsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.tunnelsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HostsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HostsTableTable,
          HostEntry,
          $$HostsTableTableFilterComposer,
          $$HostsTableTableOrderingComposer,
          $$HostsTableTableAnnotationComposer,
          $$HostsTableTableCreateCompanionBuilder,
          $$HostsTableTableUpdateCompanionBuilder,
          (HostEntry, $$HostsTableTableReferences),
          HostEntry,
          PrefetchHooks Function({bool tunnelsTableRefs})
        > {
  $$HostsTableTableTableManager(_$AppDatabase db, $HostsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HostsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HostsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HostsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> host = const Value.absent(),
                Value<int> port = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String> authType = const Value.absent(),
                Value<String?> keyFilePath = const Value.absent(),
                Value<String> groupName = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HostsTableCompanion(
                id: id,
                name: name,
                host: host,
                port: port,
                username: username,
                authType: authType,
                keyFilePath: keyFilePath,
                groupName: groupName,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String host,
                Value<int> port = const Value.absent(),
                required String username,
                required String authType,
                Value<String?> keyFilePath = const Value.absent(),
                Value<String> groupName = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => HostsTableCompanion.insert(
                id: id,
                name: name,
                host: host,
                port: port,
                username: username,
                authType: authType,
                keyFilePath: keyFilePath,
                groupName: groupName,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$HostsTableTable, HostEntry>(table),
                  $$HostsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({tunnelsTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (tunnelsTableRefs) db.tunnelsTable],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (tunnelsTableRefs)
                    await $_getPrefetchedDataByColumns<
                      HostEntry,
                      $HostsTableTable,
                      TunnelEntry,
                      $TunnelsTableTable
                    >(
                      currentTable: table,
                      referencedTable: $$HostsTableTableReferences
                          ._tunnelsTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$HostsTableTableReferences(
                            db,
                            table,
                            p0,
                          ).tunnelsTableRefs,
                      currentColumn: 'id',
                      referencedColumn: 'host_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$HostsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HostsTableTable,
      HostEntry,
      $$HostsTableTableFilterComposer,
      $$HostsTableTableOrderingComposer,
      $$HostsTableTableAnnotationComposer,
      $$HostsTableTableCreateCompanionBuilder,
      $$HostsTableTableUpdateCompanionBuilder,
      (HostEntry, $$HostsTableTableReferences),
      HostEntry,
      PrefetchHooks Function({bool tunnelsTableRefs})
    >;
typedef $$ShortcutCommandsTableTableCreateCompanionBuilder =
    ShortcutCommandsTableCompanion Function({
      required String id,
      Value<String?> hostId,
      required String name,
      required String command,
      Value<String?> workingDirectory,
      Value<int> timeoutSeconds,
      Value<String> category,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$ShortcutCommandsTableTableUpdateCompanionBuilder =
    ShortcutCommandsTableCompanion Function({
      Value<String> id,
      Value<String?> hostId,
      Value<String> name,
      Value<String> command,
      Value<String?> workingDirectory,
      Value<int> timeoutSeconds,
      Value<String> category,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$ShortcutCommandsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ShortcutCommandsTableTable> {
  $$ShortcutCommandsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hostId => $composableBuilder(
    column: $table.hostId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get command => $composableBuilder(
    column: $table.command,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workingDirectory => $composableBuilder(
    column: $table.workingDirectory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timeoutSeconds => $composableBuilder(
    column: $table.timeoutSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ShortcutCommandsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ShortcutCommandsTableTable> {
  $$ShortcutCommandsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hostId => $composableBuilder(
    column: $table.hostId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get command => $composableBuilder(
    column: $table.command,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workingDirectory => $composableBuilder(
    column: $table.workingDirectory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timeoutSeconds => $composableBuilder(
    column: $table.timeoutSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ShortcutCommandsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShortcutCommandsTableTable> {
  $$ShortcutCommandsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get hostId =>
      $composableBuilder(column: $table.hostId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get command =>
      $composableBuilder(column: $table.command, builder: (column) => column);

  GeneratedColumn<String> get workingDirectory => $composableBuilder(
    column: $table.workingDirectory,
    builder: (column) => column,
  );

  GeneratedColumn<int> get timeoutSeconds => $composableBuilder(
    column: $table.timeoutSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ShortcutCommandsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShortcutCommandsTableTable,
          ShortcutEntry,
          $$ShortcutCommandsTableTableFilterComposer,
          $$ShortcutCommandsTableTableOrderingComposer,
          $$ShortcutCommandsTableTableAnnotationComposer,
          $$ShortcutCommandsTableTableCreateCompanionBuilder,
          $$ShortcutCommandsTableTableUpdateCompanionBuilder,
          (
            ShortcutEntry,
            BaseReferences<
              _$AppDatabase,
              $ShortcutCommandsTableTable,
              ShortcutEntry
            >,
          ),
          ShortcutEntry,
          PrefetchHooks Function()
        > {
  $$ShortcutCommandsTableTableTableManager(
    _$AppDatabase db,
    $ShortcutCommandsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShortcutCommandsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ShortcutCommandsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ShortcutCommandsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> hostId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> command = const Value.absent(),
                Value<String?> workingDirectory = const Value.absent(),
                Value<int> timeoutSeconds = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShortcutCommandsTableCompanion(
                id: id,
                hostId: hostId,
                name: name,
                command: command,
                workingDirectory: workingDirectory,
                timeoutSeconds: timeoutSeconds,
                category: category,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> hostId = const Value.absent(),
                required String name,
                required String command,
                Value<String?> workingDirectory = const Value.absent(),
                Value<int> timeoutSeconds = const Value.absent(),
                Value<String> category = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => ShortcutCommandsTableCompanion.insert(
                id: id,
                hostId: hostId,
                name: name,
                command: command,
                workingDirectory: workingDirectory,
                timeoutSeconds: timeoutSeconds,
                category: category,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ShortcutCommandsTableTable, ShortcutEntry>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $ShortcutCommandsTableTable,
                    ShortcutEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ShortcutCommandsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShortcutCommandsTableTable,
      ShortcutEntry,
      $$ShortcutCommandsTableTableFilterComposer,
      $$ShortcutCommandsTableTableOrderingComposer,
      $$ShortcutCommandsTableTableAnnotationComposer,
      $$ShortcutCommandsTableTableCreateCompanionBuilder,
      $$ShortcutCommandsTableTableUpdateCompanionBuilder,
      (
        ShortcutEntry,
        BaseReferences<
          _$AppDatabase,
          $ShortcutCommandsTableTable,
          ShortcutEntry
        >,
      ),
      ShortcutEntry,
      PrefetchHooks Function()
    >;
typedef $$ExecutionHistoryTableTableCreateCompanionBuilder =
    ExecutionHistoryTableCompanion Function({
      required String id,
      required String hostId,
      Value<String?> shortcutId,
      required String command,
      required int exitCode,
      required String stdout,
      required String stderr,
      required int durationMs,
      required DateTime executedAt,
      Value<int> rowid,
    });
typedef $$ExecutionHistoryTableTableUpdateCompanionBuilder =
    ExecutionHistoryTableCompanion Function({
      Value<String> id,
      Value<String> hostId,
      Value<String?> shortcutId,
      Value<String> command,
      Value<int> exitCode,
      Value<String> stdout,
      Value<String> stderr,
      Value<int> durationMs,
      Value<DateTime> executedAt,
      Value<int> rowid,
    });

class $$ExecutionHistoryTableTableFilterComposer
    extends Composer<_$AppDatabase, $ExecutionHistoryTableTable> {
  $$ExecutionHistoryTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hostId => $composableBuilder(
    column: $table.hostId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shortcutId => $composableBuilder(
    column: $table.shortcutId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get command => $composableBuilder(
    column: $table.command,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get exitCode => $composableBuilder(
    column: $table.exitCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stdout => $composableBuilder(
    column: $table.stdout,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stderr => $composableBuilder(
    column: $table.stderr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get executedAt => $composableBuilder(
    column: $table.executedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExecutionHistoryTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ExecutionHistoryTableTable> {
  $$ExecutionHistoryTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hostId => $composableBuilder(
    column: $table.hostId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shortcutId => $composableBuilder(
    column: $table.shortcutId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get command => $composableBuilder(
    column: $table.command,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get exitCode => $composableBuilder(
    column: $table.exitCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stdout => $composableBuilder(
    column: $table.stdout,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stderr => $composableBuilder(
    column: $table.stderr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get executedAt => $composableBuilder(
    column: $table.executedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExecutionHistoryTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExecutionHistoryTableTable> {
  $$ExecutionHistoryTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get hostId =>
      $composableBuilder(column: $table.hostId, builder: (column) => column);

  GeneratedColumn<String> get shortcutId => $composableBuilder(
    column: $table.shortcutId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get command =>
      $composableBuilder(column: $table.command, builder: (column) => column);

  GeneratedColumn<int> get exitCode =>
      $composableBuilder(column: $table.exitCode, builder: (column) => column);

  GeneratedColumn<String> get stdout =>
      $composableBuilder(column: $table.stdout, builder: (column) => column);

  GeneratedColumn<String> get stderr =>
      $composableBuilder(column: $table.stderr, builder: (column) => column);

  GeneratedColumn<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get executedAt => $composableBuilder(
    column: $table.executedAt,
    builder: (column) => column,
  );
}

class $$ExecutionHistoryTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExecutionHistoryTableTable,
          ExecutionHistoryEntry,
          $$ExecutionHistoryTableTableFilterComposer,
          $$ExecutionHistoryTableTableOrderingComposer,
          $$ExecutionHistoryTableTableAnnotationComposer,
          $$ExecutionHistoryTableTableCreateCompanionBuilder,
          $$ExecutionHistoryTableTableUpdateCompanionBuilder,
          (
            ExecutionHistoryEntry,
            BaseReferences<
              _$AppDatabase,
              $ExecutionHistoryTableTable,
              ExecutionHistoryEntry
            >,
          ),
          ExecutionHistoryEntry,
          PrefetchHooks Function()
        > {
  $$ExecutionHistoryTableTableTableManager(
    _$AppDatabase db,
    $ExecutionHistoryTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExecutionHistoryTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ExecutionHistoryTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ExecutionHistoryTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> hostId = const Value.absent(),
                Value<String?> shortcutId = const Value.absent(),
                Value<String> command = const Value.absent(),
                Value<int> exitCode = const Value.absent(),
                Value<String> stdout = const Value.absent(),
                Value<String> stderr = const Value.absent(),
                Value<int> durationMs = const Value.absent(),
                Value<DateTime> executedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExecutionHistoryTableCompanion(
                id: id,
                hostId: hostId,
                shortcutId: shortcutId,
                command: command,
                exitCode: exitCode,
                stdout: stdout,
                stderr: stderr,
                durationMs: durationMs,
                executedAt: executedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String hostId,
                Value<String?> shortcutId = const Value.absent(),
                required String command,
                required int exitCode,
                required String stdout,
                required String stderr,
                required int durationMs,
                required DateTime executedAt,
                Value<int> rowid = const Value.absent(),
              }) => ExecutionHistoryTableCompanion.insert(
                id: id,
                hostId: hostId,
                shortcutId: shortcutId,
                command: command,
                exitCode: exitCode,
                stdout: stdout,
                stderr: stderr,
                durationMs: durationMs,
                executedAt: executedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $ExecutionHistoryTableTable,
                    ExecutionHistoryEntry
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ExecutionHistoryTableTable,
                    ExecutionHistoryEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExecutionHistoryTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExecutionHistoryTableTable,
      ExecutionHistoryEntry,
      $$ExecutionHistoryTableTableFilterComposer,
      $$ExecutionHistoryTableTableOrderingComposer,
      $$ExecutionHistoryTableTableAnnotationComposer,
      $$ExecutionHistoryTableTableCreateCompanionBuilder,
      $$ExecutionHistoryTableTableUpdateCompanionBuilder,
      (
        ExecutionHistoryEntry,
        BaseReferences<
          _$AppDatabase,
          $ExecutionHistoryTableTable,
          ExecutionHistoryEntry
        >,
      ),
      ExecutionHistoryEntry,
      PrefetchHooks Function()
    >;
typedef $$TrustedHostKeysTableTableCreateCompanionBuilder =
    TrustedHostKeysTableCompanion Function({
      required String hostname,
      required int port,
      required String algorithm,
      required String fingerprint,
      required DateTime firstConfirmedAt,
      required DateTime lastVerifiedAt,
      Value<int> rowid,
    });
typedef $$TrustedHostKeysTableTableUpdateCompanionBuilder =
    TrustedHostKeysTableCompanion Function({
      Value<String> hostname,
      Value<int> port,
      Value<String> algorithm,
      Value<String> fingerprint,
      Value<DateTime> firstConfirmedAt,
      Value<DateTime> lastVerifiedAt,
      Value<int> rowid,
    });

class $$TrustedHostKeysTableTableFilterComposer
    extends Composer<_$AppDatabase, $TrustedHostKeysTableTable> {
  $$TrustedHostKeysTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get hostname => $composableBuilder(
    column: $table.hostname,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get port => $composableBuilder(
    column: $table.port,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get algorithm => $composableBuilder(
    column: $table.algorithm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fingerprint => $composableBuilder(
    column: $table.fingerprint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get firstConfirmedAt => $composableBuilder(
    column: $table.firstConfirmedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastVerifiedAt => $composableBuilder(
    column: $table.lastVerifiedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TrustedHostKeysTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TrustedHostKeysTableTable> {
  $$TrustedHostKeysTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get hostname => $composableBuilder(
    column: $table.hostname,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get port => $composableBuilder(
    column: $table.port,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get algorithm => $composableBuilder(
    column: $table.algorithm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fingerprint => $composableBuilder(
    column: $table.fingerprint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get firstConfirmedAt => $composableBuilder(
    column: $table.firstConfirmedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastVerifiedAt => $composableBuilder(
    column: $table.lastVerifiedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TrustedHostKeysTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TrustedHostKeysTableTable> {
  $$TrustedHostKeysTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get hostname =>
      $composableBuilder(column: $table.hostname, builder: (column) => column);

  GeneratedColumn<int> get port =>
      $composableBuilder(column: $table.port, builder: (column) => column);

  GeneratedColumn<String> get algorithm =>
      $composableBuilder(column: $table.algorithm, builder: (column) => column);

  GeneratedColumn<String> get fingerprint => $composableBuilder(
    column: $table.fingerprint,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get firstConfirmedAt => $composableBuilder(
    column: $table.firstConfirmedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastVerifiedAt => $composableBuilder(
    column: $table.lastVerifiedAt,
    builder: (column) => column,
  );
}

class $$TrustedHostKeysTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TrustedHostKeysTableTable,
          TrustedHostKeyEntry,
          $$TrustedHostKeysTableTableFilterComposer,
          $$TrustedHostKeysTableTableOrderingComposer,
          $$TrustedHostKeysTableTableAnnotationComposer,
          $$TrustedHostKeysTableTableCreateCompanionBuilder,
          $$TrustedHostKeysTableTableUpdateCompanionBuilder,
          (
            TrustedHostKeyEntry,
            BaseReferences<
              _$AppDatabase,
              $TrustedHostKeysTableTable,
              TrustedHostKeyEntry
            >,
          ),
          TrustedHostKeyEntry,
          PrefetchHooks Function()
        > {
  $$TrustedHostKeysTableTableTableManager(
    _$AppDatabase db,
    $TrustedHostKeysTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrustedHostKeysTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TrustedHostKeysTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$TrustedHostKeysTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> hostname = const Value.absent(),
                Value<int> port = const Value.absent(),
                Value<String> algorithm = const Value.absent(),
                Value<String> fingerprint = const Value.absent(),
                Value<DateTime> firstConfirmedAt = const Value.absent(),
                Value<DateTime> lastVerifiedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TrustedHostKeysTableCompanion(
                hostname: hostname,
                port: port,
                algorithm: algorithm,
                fingerprint: fingerprint,
                firstConfirmedAt: firstConfirmedAt,
                lastVerifiedAt: lastVerifiedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String hostname,
                required int port,
                required String algorithm,
                required String fingerprint,
                required DateTime firstConfirmedAt,
                required DateTime lastVerifiedAt,
                Value<int> rowid = const Value.absent(),
              }) => TrustedHostKeysTableCompanion.insert(
                hostname: hostname,
                port: port,
                algorithm: algorithm,
                fingerprint: fingerprint,
                firstConfirmedAt: firstConfirmedAt,
                lastVerifiedAt: lastVerifiedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TrustedHostKeysTableTable, TrustedHostKeyEntry>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $TrustedHostKeysTableTable,
                    TrustedHostKeyEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TrustedHostKeysTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TrustedHostKeysTableTable,
      TrustedHostKeyEntry,
      $$TrustedHostKeysTableTableFilterComposer,
      $$TrustedHostKeysTableTableOrderingComposer,
      $$TrustedHostKeysTableTableAnnotationComposer,
      $$TrustedHostKeysTableTableCreateCompanionBuilder,
      $$TrustedHostKeysTableTableUpdateCompanionBuilder,
      (
        TrustedHostKeyEntry,
        BaseReferences<
          _$AppDatabase,
          $TrustedHostKeysTableTable,
          TrustedHostKeyEntry
        >,
      ),
      TrustedHostKeyEntry,
      PrefetchHooks Function()
    >;
typedef $$TunnelsTableTableCreateCompanionBuilder =
    TunnelsTableCompanion Function({
      required String id,
      required String name,
      required String hostId,
      Value<String> localHost,
      required int localPort,
      required String remoteHost,
      required int remotePort,
      Value<bool> autoReconnect,
      Value<bool> autoConnect,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$TunnelsTableTableUpdateCompanionBuilder =
    TunnelsTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> hostId,
      Value<String> localHost,
      Value<int> localPort,
      Value<String> remoteHost,
      Value<int> remotePort,
      Value<bool> autoReconnect,
      Value<bool> autoConnect,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$TunnelsTableTableReferences
    extends BaseReferences<_$AppDatabase, $TunnelsTableTable, TunnelEntry> {
  $$TunnelsTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $HostsTableTable _hostIdTable(_$AppDatabase db) =>
      db.hostsTable.createAlias('tunnels_table__host_id__hosts_table__id');

  $$HostsTableTableProcessedTableManager get hostId {
    final $_column = $_itemColumn<String>('host_id')!;

    final manager = $$HostsTableTableTableManager(
      $_db,
      $_db.hostsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_hostIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TunnelsTableTableFilterComposer
    extends Composer<_$AppDatabase, $TunnelsTableTable> {
  $$TunnelsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localHost => $composableBuilder(
    column: $table.localHost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get localPort => $composableBuilder(
    column: $table.localPort,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remoteHost => $composableBuilder(
    column: $table.remoteHost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get remotePort => $composableBuilder(
    column: $table.remotePort,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoReconnect => $composableBuilder(
    column: $table.autoReconnect,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoConnect => $composableBuilder(
    column: $table.autoConnect,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$HostsTableTableFilterComposer get hostId {
    final $$HostsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.hostId,
      referencedTable: $db.hostsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HostsTableTableFilterComposer(
            $db: $db,
            $table: $db.hostsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TunnelsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TunnelsTableTable> {
  $$TunnelsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localHost => $composableBuilder(
    column: $table.localHost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get localPort => $composableBuilder(
    column: $table.localPort,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remoteHost => $composableBuilder(
    column: $table.remoteHost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get remotePort => $composableBuilder(
    column: $table.remotePort,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoReconnect => $composableBuilder(
    column: $table.autoReconnect,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoConnect => $composableBuilder(
    column: $table.autoConnect,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$HostsTableTableOrderingComposer get hostId {
    final $$HostsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.hostId,
      referencedTable: $db.hostsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HostsTableTableOrderingComposer(
            $db: $db,
            $table: $db.hostsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TunnelsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TunnelsTableTable> {
  $$TunnelsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get localHost =>
      $composableBuilder(column: $table.localHost, builder: (column) => column);

  GeneratedColumn<int> get localPort =>
      $composableBuilder(column: $table.localPort, builder: (column) => column);

  GeneratedColumn<String> get remoteHost => $composableBuilder(
    column: $table.remoteHost,
    builder: (column) => column,
  );

  GeneratedColumn<int> get remotePort => $composableBuilder(
    column: $table.remotePort,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get autoReconnect => $composableBuilder(
    column: $table.autoReconnect,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get autoConnect => $composableBuilder(
    column: $table.autoConnect,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$HostsTableTableAnnotationComposer get hostId {
    final $$HostsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.hostId,
      referencedTable: $db.hostsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HostsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.hostsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TunnelsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TunnelsTableTable,
          TunnelEntry,
          $$TunnelsTableTableFilterComposer,
          $$TunnelsTableTableOrderingComposer,
          $$TunnelsTableTableAnnotationComposer,
          $$TunnelsTableTableCreateCompanionBuilder,
          $$TunnelsTableTableUpdateCompanionBuilder,
          (TunnelEntry, $$TunnelsTableTableReferences),
          TunnelEntry,
          PrefetchHooks Function({bool hostId})
        > {
  $$TunnelsTableTableTableManager(_$AppDatabase db, $TunnelsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TunnelsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TunnelsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TunnelsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> hostId = const Value.absent(),
                Value<String> localHost = const Value.absent(),
                Value<int> localPort = const Value.absent(),
                Value<String> remoteHost = const Value.absent(),
                Value<int> remotePort = const Value.absent(),
                Value<bool> autoReconnect = const Value.absent(),
                Value<bool> autoConnect = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TunnelsTableCompanion(
                id: id,
                name: name,
                hostId: hostId,
                localHost: localHost,
                localPort: localPort,
                remoteHost: remoteHost,
                remotePort: remotePort,
                autoReconnect: autoReconnect,
                autoConnect: autoConnect,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String hostId,
                Value<String> localHost = const Value.absent(),
                required int localPort,
                required String remoteHost,
                required int remotePort,
                Value<bool> autoReconnect = const Value.absent(),
                Value<bool> autoConnect = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => TunnelsTableCompanion.insert(
                id: id,
                name: name,
                hostId: hostId,
                localHost: localHost,
                localPort: localPort,
                remoteHost: remoteHost,
                remotePort: remotePort,
                autoReconnect: autoReconnect,
                autoConnect: autoConnect,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TunnelsTableTable, TunnelEntry>(table),
                  $$TunnelsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({hostId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (hostId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.hostId,
                        referencedTable: $$TunnelsTableTableReferences
                            ._hostIdTable(db),
                        referencedColumn: $$TunnelsTableTableReferences
                            ._hostIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TunnelsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TunnelsTableTable,
      TunnelEntry,
      $$TunnelsTableTableFilterComposer,
      $$TunnelsTableTableOrderingComposer,
      $$TunnelsTableTableAnnotationComposer,
      $$TunnelsTableTableCreateCompanionBuilder,
      $$TunnelsTableTableUpdateCompanionBuilder,
      (TunnelEntry, $$TunnelsTableTableReferences),
      TunnelEntry,
      PrefetchHooks Function({bool hostId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$HostsTableTableTableManager get hostsTable =>
      $$HostsTableTableTableManager(_db, _db.hostsTable);
  $$ShortcutCommandsTableTableTableManager get shortcutCommandsTable =>
      $$ShortcutCommandsTableTableTableManager(_db, _db.shortcutCommandsTable);
  $$ExecutionHistoryTableTableTableManager get executionHistoryTable =>
      $$ExecutionHistoryTableTableTableManager(_db, _db.executionHistoryTable);
  $$TrustedHostKeysTableTableTableManager get trustedHostKeysTable =>
      $$TrustedHostKeysTableTableTableManager(_db, _db.trustedHostKeysTable);
  $$TunnelsTableTableTableManager get tunnelsTable =>
      $$TunnelsTableTableTableManager(_db, _db.tunnelsTable);
}
