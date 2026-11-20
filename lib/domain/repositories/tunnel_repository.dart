import '../entities/ssh_tunnel.dart';
import '../entities/tunnel_session.dart';

abstract interface class TunnelRepository {
  Stream<List<SSHTunnel>> watchTunnels();
  Future<void> save(SSHTunnel tunnel);
  Future<void> delete(String id);
  Stream<(String, TunnelSession)> get sessions;
  Future<void> start(String id);
  Future<void> stop(String id);
  Future<void> shutdown();
}
