import 'package:drift/drift.dart';
import '../../domain/entities/ssh_host.dart';
import '../datasources/local_database.dart';

class SSHHostModel {
  static SSHHost fromEntry(HostEntry entry) {
    return SSHHost(
      id: entry.id,
      name: entry.name,
      host: entry.host,
      port: entry.port,
      username: entry.username,
      authType: entry.authType == 'privateKey' ? SSHAuthType.privateKey : SSHAuthType.password,
      keyFilePath: entry.keyFilePath,
      groupName: entry.groupName,
      createdAt: entry.createdAt,
      updatedAt: entry.updatedAt,
    );
  }

  static HostsTableCompanion toCompanion(SSHHost host) {
    return HostsTableCompanion.insert(
      id: host.id,
      name: host.name,
      host: host.host,
      port: Value(host.port),
      username: host.username,
      authType: host.authType == SSHAuthType.privateKey ? 'privateKey' : 'password',
      keyFilePath: host.keyFilePath != null ? Value(host.keyFilePath) : const Value.absent(),
      groupName: Value(host.groupName),
      createdAt: host.createdAt,
      updatedAt: host.updatedAt,
    );
  }
}
