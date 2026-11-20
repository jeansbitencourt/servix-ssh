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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $HostsTableTable hostsTable = $HostsTableTable(this);
  late final $ShortcutCommandsTableTable shortcutCommandsTable =
      $ShortcutCommandsTableTable(this);
  late final $ExecutionHistoryTableTable executionHistoryTable =
      $ExecutionHistoryTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    hostsTable,
    shortcutCommandsTable,
    executionHistoryTable,
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
          (
            HostEntry,
            BaseReferences<_$AppDatabase, $HostsTableTable, HostEntry>,
          ),
          HostEntry,
          PrefetchHooks Function()
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
                  BaseReferences<_$AppDatabase, $HostsTableTable, HostEntry>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
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
      (HostEntry, BaseReferences<_$AppDatabase, $HostsTableTable, HostEntry>),
      HostEntry,
      PrefetchHooks Function()
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

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$HostsTableTableTableManager get hostsTable =>
      $$HostsTableTableTableManager(_db, _db.hostsTable);
  $$ShortcutCommandsTableTableTableManager get shortcutCommandsTable =>
      $$ShortcutCommandsTableTableTableManager(_db, _db.shortcutCommandsTable);
  $$ExecutionHistoryTableTableTableManager get executionHistoryTable =>
      $$ExecutionHistoryTableTableTableManager(_db, _db.executionHistoryTable);
}
