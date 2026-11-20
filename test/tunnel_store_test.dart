import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:servix/domain/entities/ssh_tunnel.dart';
import 'package:servix/domain/entities/tunnel_session.dart';
import 'package:servix/domain/repositories/tunnel_repository.dart';
import 'package:servix/presentation/stores/tunnel_store.dart';

void main() {
  test(
    'Startup restores only selected tunnels once and delegates shutdown',
    () async {
      final repository = _Repository();
      final store = TunnelStore(repository);
      final now = DateTime.now();
      SSHTunnel config(String id, {bool autoConnect = false}) => SSHTunnel(
        id: id,
        name: id,
        hostId: 'server',
        localPort: 3307,
        remoteHost: 'mysql.example',
        remotePort: 3306,
        autoConnect: autoConnect,
        createdAt: now,
        updatedAt: now,
      );
      final persisted = [
        config('manual'),
        config('startup', autoConnect: true),
      ];
      expect(repository.started, isEmpty);
      store.init();
      repository.configurations.add(persisted);
      await Future<void>.delayed(Duration.zero);
      expect(repository.started, ['startup']);
      repository.configurations.add(persisted);
      await Future<void>.delayed(Duration.zero);
      expect(repository.started, ['startup']);
      await store.shutdown();
      expect(repository.closed, isTrue);
      await repository.configurations.close();
    },
  );
}

class _Repository implements TunnelRepository {
  final configurations = StreamController<List<SSHTunnel>>();
  final started = <String>[];
  bool closed = false;

  @override
  Stream<List<SSHTunnel>> watchTunnels() => configurations.stream;

  @override
  Stream<(String, TunnelSession)> get sessions => const Stream.empty();

  @override
  Future<void> start(String id) async => started.add(id);

  @override
  Future<void> shutdown() async => closed = true;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
