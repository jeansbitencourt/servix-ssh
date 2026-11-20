import 'dart:async';

import 'package:signals_flutter/signals_flutter.dart';

import '../../domain/entities/ssh_tunnel.dart';
import '../../domain/entities/tunnel_session.dart';
import '../../domain/repositories/tunnel_repository.dart';

class TunnelStore {
  TunnelStore(this._repository);

  final TunnelRepository _repository;
  final tunnels = signal<List<SSHTunnel>>([]);
  final sessions = signal<Map<String, TunnelSession>>({});
  final loading = signal(true);
  final loadFailed = signal(false);

  StreamSubscription<List<SSHTunnel>>? _configs;
  StreamSubscription<(String, TunnelSession)>? _sessions;
  bool _restored = false;
  bool _closed = false;

  void init() {
    if (_closed || _configs != null) return;
    _sessions = _repository.sessions.listen((event) {
      final (id, session) = event;
      sessions.value = {...sessions.value, id: session};
    });
    _configs = _repository.watchTunnels().listen(
      (list) {
        tunnels.value = list;
        loading.value = false;
        loadFailed.value = false;
        final ids = list.map((tunnel) => tunnel.id).toSet();
        sessions.value = Map.of(sessions.value)
          ..removeWhere((id, _) => !ids.contains(id));
        if (!_restored) {
          _restored = true;
          for (final tunnel in list.where((tunnel) => tunnel.autoConnect)) {
            unawaited(start(tunnel));
          }
        }
      },
      onError: (Object _, StackTrace _) {
        loading.value = false;
        loadFailed.value = true;
      },
    );
  }

  Future<void> save(SSHTunnel tunnel) => _repository.save(tunnel);
  Future<void> delete(String id) => _repository.delete(id);
  Future<void> start(SSHTunnel tunnel) async {
    try {
      await _repository.start(tunnel.id);
    } catch (_) {
      if (_closed) return;
      sessions.value = {
        ...sessions.value,
        tunnel.id: const TunnelSession(
          status: TunnelStatus.error,
          issue: TunnelIssue.configurationStorage,
        ),
      };
    }
  }

  Future<void> stop(String id) => _repository.stop(id);

  Future<void> shutdown() async {
    _closed = true;
    await _configs?.cancel();
    await _repository.shutdown();
    await _sessions?.cancel();
  }
}
