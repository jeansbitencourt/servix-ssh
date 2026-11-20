import 'dart:async';
import 'dart:io';

import 'package:dartssh2/dartssh2.dart';

import '../../core/errors/exceptions.dart';
import '../../domain/entities/ssh_tunnel.dart';
import '../../domain/entities/tunnel_session.dart';
import '../../domain/repositories/host_repository.dart';
import 'ssh_connection_factory.dart';
import 'ssh_host_key_store.dart';

class SSHTunnelDatasource {
  SSHTunnelDatasource(
    this._hosts,
    this._connections, {
    this.reconnectDelay = const Duration(seconds: 1),
    this.keepAliveInterval = const Duration(seconds: 15),
  });

  final HostRepository _hosts;
  final SSHConnectionFactory _connections;
  final Duration reconnectDelay;
  final Duration keepAliveInterval;
  final _runs = <String, _TunnelRun>{};
  final _sessions = StreamController<(String, TunnelSession)>.broadcast();
  Future<void>? _shutdown;

  Stream<(String, TunnelSession)> get sessions => _sessions.stream;

  bool isRunning(String id) => _runs.containsKey(id);

  Future<void> start(SSHTunnel tunnel) {
    if (_shutdown != null) return Future.value();
    final current = _runs[tunnel.id];
    if (current != null) return current.started.future;
    final run = _TunnelRun(
      tunnel,
      _hosts,
      _connections,
      reconnectDelay,
      keepAliveInterval,
      (state) {
        if (!state.status.isActive) _runs.remove(tunnel.id);
        _sessions.add((tunnel.id, state));
      },
    );
    _runs[tunnel.id] = run;
    run.done = run.run();
    return run.started.future;
  }

  Future<void> stop(String id) async {
    final run = _runs[id];
    if (run == null) return;
    run.stop();
    await run.done;
  }

  Future<void> shutdown() => _shutdown ??= _stopAll();

  Future<void> _stopAll() async {
    await Future.wait(_runs.keys.toList().map(stop));
    unawaited(_sessions.close());
  }
}

class _TunnelRun {
  _TunnelRun(
    this.config,
    this.hosts,
    this.connections,
    this.initialDelay,
    this.keepAliveInterval,
    this.publish,
  );

  final SSHTunnel config;
  final HostRepository hosts;
  final SSHConnectionFactory connections;
  final Duration initialDelay;
  final Duration keepAliveInterval;
  final void Function(TunnelSession) publish;

  final started = Completer<void>();
  late final Future<void> done;
  final _relays = <_TunnelRelay>{};
  SSHConnectionCancellation? _attempt;
  Completer<TunnelIssue>? _outage;
  Timer? _keepAlive;
  Timer? _retryTimer;
  Completer<void>? _retryWait;
  var _stopping = false;
  var _listening = false;
  var _retryCount = 0;
  TunnelIssue? _forwardingIssue;

  Future<void> run() async {
    publish(const TunnelSession(status: TunnelStatus.connecting));
    try {
      while (!_stopping) {
        final (issue, message) = await _runOnce();
        if (_stopping) break;
        final canRetry =
            config.autoReconnect &&
            (issue == TunnelIssue.sshUnavailable ||
                issue == TunnelIssue.disconnected);
        publish(
          TunnelSession(
            status: canRetry ? TunnelStatus.reconnecting : TunnelStatus.error,
            issue: issue,
            message: message,
          ),
        );
        _markStarted();
        if (!canRetry) return;
        await _waitToRetry();
      }
      publish(const TunnelSession());
    } catch (_) {
      publish(
        const TunnelSession(
          status: TunnelStatus.error,
          issue: TunnelIssue.localListener,
        ),
      );
    } finally {
      _markStarted();
    }
  }

  void _markStarted() {
    if (!started.isCompleted) started.complete();
  }

  Future<(TunnelIssue, String?)> _runOnce() async {
    if (!config.isValid) return (TunnelIssue.invalidConfiguration, null);
    final attempt = SSHConnectionCancellation();
    _attempt = attempt;
    SSHClient? client;
    ServerSocket? listener;
    StreamSubscription<Socket>? subscription;
    try {
      final lookup = hosts
          .getHostById(config.hostId)
          .then(
            (host) => (host, false),
            onError: (Object _, StackTrace _) => (null, true),
          );
      final (host, storageFailed) = await Future.any([
        lookup,
        attempt.cancelled.then((_) => (null, false)),
      ]);
      if (storageFailed) return (TunnelIssue.configurationStorage, null);
      if (host == null || _stopping) return (TunnelIssue.missingServer, null);
      client = await connections.connect(host, cancellation: attempt);
      if (_stopping) return (TunnelIssue.disconnected, null);

      final outage = Completer<TunnelIssue>();
      _outage = outage;
      void fail(TunnelIssue issue) {
        if (!outage.isCompleted) outage.complete(issue);
      }

      final ssh = client;
      unawaited(
        ssh.done.then(
          (_) => fail(TunnelIssue.disconnected),
          onError: (Object error, StackTrace _) => fail(
            error is SSHHostkeyError
                ? TunnelIssue.hostKeyChanged
                : TunnelIssue.disconnected,
          ),
        ),
      );

      try {
        listener = await ServerSocket.bind(
          InternetAddress.loopbackIPv4,
          config.localPort,
        );
      } on SocketException catch (error) {
        const addressInUseCodes = {48, 98, 10048}; // macOS, Linux, Windows
        // dart:io detects an existing non-shared listener in this process
        // before asking the OS to bind and reports its own error.
        final alreadyBound =
            addressInUseCodes.contains(error.osError?.errorCode) ||
            (error.osError?.message.startsWith('The shared flag to bind()') ??
                false);
        return (
          alreadyBound ? TunnelIssue.localPortInUse : TunnelIssue.localListener,
          null,
        );
      }
      if (_stopping) return (TunnelIssue.disconnected, null);
      if (outage.isCompleted) return (await outage.future, null);
      if (ssh.isClosed) return (TunnelIssue.disconnected, null);

      subscription = listener.listen(
        (socket) => _accept(socket, ssh, attempt),
        onError: (Object _, StackTrace _) => fail(TunnelIssue.localListener),
        onDone: () => fail(TunnelIssue.localListener),
      );
      _retryCount = 0;
      _listening = true;
      _forwardingIssue = null;
      _publishConnected();
      _markStarted();

      var pingInFlight = false;
      _keepAlive = Timer.periodic(keepAliveInterval, (_) async {
        if (pingInFlight || outage.isCompleted) return;
        pingInFlight = true;
        try {
          await ssh.ping().timeout(keepAliveInterval);
        } catch (_) {
          fail(TunnelIssue.disconnected);
        } finally {
          pingInFlight = false;
        }
      });

      return (await outage.future, null);
    } on SSHHostKeyException catch (error) {
      return (
        switch (error.issue) {
          SSHHostKeyIssue.rejected => TunnelIssue.hostKeyRejected,
          SSHHostKeyIssue.changed => TunnelIssue.hostKeyChanged,
          SSHHostKeyIssue.storage => TunnelIssue.hostKeyStorage,
        },
        null,
      );
    } on SSHAuthenticationException catch (error) {
      return (TunnelIssue.authentication, error.message);
    } on SSHConnectionException catch (error) {
      return (TunnelIssue.sshUnavailable, error.message);
    } catch (_) {
      return (TunnelIssue.localListener, null);
    } finally {
      _listening = false;
      _keepAlive?.cancel();
      _keepAlive = null;
      _outage = null;
      final listenerClosed = listener?.close();
      final subscriptionCancelled = subscription?.cancel();
      final activeRelays = _relays.toList();
      for (final relay in activeRelays) {
        relay.close();
      }
      if (client != null) await closeSSHClient(client);
      attempt.cancel();
      await Future.wait(activeRelays.map((relay) => relay.done));
      _attempt = null;
      await subscriptionCancelled;
      await listenerClosed;
    }
  }

  void _accept(
    Socket socket,
    SSHClient client,
    SSHConnectionCancellation attempt,
  ) {
    if (_stopping || !_listening || _relays.length >= 128) {
      socket.destroy();
      if (_listening && !_stopping) _report(TunnelIssue.transfer);
      return;
    }
    final relay = _TunnelRelay(socket, () {
      if (!attempt.isCancelled) _report(TunnelIssue.transfer);
    });
    _relays.add(relay);
    relay.done = _serve(relay, client, attempt);
  }

  Future<void> _serve(
    _TunnelRelay relay,
    SSHClient client,
    SSHConnectionCancellation attempt,
  ) async {
    final socket = relay.socket;
    Future<SSHForwardChannel>? opening;
    try {
      opening = client.forwardLocal(
        sshSocketHostname(config.remoteHost),
        config.remotePort,
        localHost: socket.remoteAddress.address,
        localPort: socket.remotePort,
      );
      final channel = await opening.timeout(const Duration(seconds: 15));
      if (relay.closed) {
        channel.destroy();
        return;
      }
      relay.channel = channel;
      _forwardingIssue = null;
      _publishConnected();
      await relay.pipe();
    } on SSHChannelOpenError catch (error) {
      if (!attempt.isCancelled) {
        _report(
          error.code == 2
              ? TunnelIssue.destinationUnavailable
              : TunnelIssue.forwardingRefused,
        );
      }
    } on TimeoutException {
      if (!attempt.isCancelled) _report(TunnelIssue.destinationUnavailable);
      relay.close();
      // The pending channel open belongs to this SSH connection. Retain
      // its slot until it settles, even after closing the local socket.
      try {
        (await opening)?.destroy();
      } catch (_) {
        // The transport has discarded the outstanding channel open.
      }
    } catch (_) {
      if (!relay.closed && !client.isClosed) _report(TunnelIssue.transfer);
    } finally {
      relay.close();
      _relays.remove(relay);
      if (!attempt.isCancelled) _publishConnected();
    }
  }

  void _report(TunnelIssue issue) {
    _forwardingIssue = issue;
    _publishConnected();
  }

  void _publishConnected() {
    if (_listening && !_stopping && !(_outage?.isCompleted ?? true)) {
      publish(
        TunnelSession(
          status: TunnelStatus.connected,
          connections: _relays
              .where((relay) => relay.channel != null && !relay.closed)
              .length,
          issue: _forwardingIssue,
        ),
      );
    }
  }

  Future<void> _waitToRetry() async {
    final multiplier = 1 << _retryCount;
    if (_retryCount < 5) _retryCount++;
    final delay = initialDelay * multiplier;
    final wait = _retryWait = Completer<void>();
    const maxDelay = Duration(seconds: 30);
    _retryTimer = Timer(delay > maxDelay ? maxDelay : delay, wait.complete);
    await wait.future;
    _retryWait = null;
    _retryTimer = null;
  }

  void stop() {
    if (_stopping) return;
    _stopping = true;
    publish(const TunnelSession(status: TunnelStatus.disconnecting));
    final outage = _outage;
    if (outage == null) {
      _attempt?.cancel();
    } else if (!outage.isCompleted) {
      outage.complete(TunnelIssue.disconnected);
    }
    _retryTimer?.cancel();
    final retry = _retryWait;
    if (retry != null && !retry.isCompleted) retry.complete();
  }
}

class _TunnelRelay {
  _TunnelRelay(this.socket, this._onError) {
    unawaited(socket.done.then((_) {}, onError: _handleLocalError));
  }

  final Socket socket;
  final void Function() _onError;
  SSHForwardChannel? channel;
  final _closed = Completer<void>();
  bool get closed => _closed.isCompleted;
  late final Future<void> done;

  void _handleLocalError(Object error, StackTrace stack) {
    if (closed) return;
    _onError();
    close();
  }

  Future<void> pipe() async {
    final ssh = channel!;
    // Keep both paths as addStream chains so pauses propagate to the TCP
    // reader and to the SSH receive window. Only forward bytes to dartssh2.
    final transfer = Future.wait([
      () async {
        await ssh.sink.addStream(socket.handleError(_handleLocalError));
        if (!closed) await ssh.sink.close(); // Send SSH EOF.
      }(),
      () async {
        await socket.addStream(ssh.stream);
        if (!closed) await socket.close(); // Close only the TCP write side.
      }(),
    ], eagerError: true);
    await Future.any([transfer, _closed.future]);
  }

  void close() {
    if (closed) return;
    _closed.complete();
    socket.destroy();
    channel?.destroy();
  }
}
