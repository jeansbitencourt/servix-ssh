import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dartssh2/dartssh2.dart';
import 'package:uuid/uuid.dart';
import 'package:xterm/xterm.dart';

import '../../core/errors/exceptions.dart';
import '../../domain/entities/command_result.dart';
import '../../domain/entities/ssh_host.dart';
import '../../domain/entities/terminal_session.dart';
import '../../l10n/system_localizations.dart';

import 'ssh_connection_factory.dart';

class SSHRemoteDatasource {
  final Uuid _uuid;

  final SSHConnectionFactory _connections;

  SSHRemoteDatasource(this._connections, {Uuid? uuid})
    : _uuid = uuid ?? const Uuid();

  Future<bool> testConnection(
    SSHHost host, {
    String? password,
    String? passphrase,
  }) async {
    SSHClient? client;
    try {
      client = await _connections.connect(
        host,
        password: password,
        passphrase: passphrase,
        timeout: const Duration(seconds: 10),
      );
      return true;
    } finally {
      if (client != null) await closeSSHClient(client);
    }
  }

  Future<CommandResult> runCommand(
    SSHHost host,
    String command, {
    String? password,
    String? passphrase,
    int timeoutSeconds = 30,
    String? shortcutId,
  }) async {
    SSHClient? client;
    final stopwatch = Stopwatch()..start();

    try {
      client = await _connections.connect(
        host,
        password: password,
        passphrase: passphrase,
        timeout: const Duration(seconds: 15),
      );

      final session = await client
          .execute(command)
          .timeout(
            Duration(seconds: timeoutSeconds),
            onTimeout: () => throw SSHExecutionException(
              systemLocalizations.commandTimedOut(timeoutSeconds),
            ),
          );

      final stdoutBuffer = StringBuffer();
      final stderrBuffer = StringBuffer();

      final stdoutFuture = session.stdout.listen((data) {
        stdoutBuffer.write(utf8.decode(data, allowMalformed: true));
      }).asFuture();

      final stderrFuture = session.stderr.listen((data) {
        stderrBuffer.write(utf8.decode(data, allowMalformed: true));
      }).asFuture();

      await Future.wait([stdoutFuture, stderrFuture]);
      await session.done;

      stopwatch.stop();

      final exitCode = session.exitCode ?? 0;

      return CommandResult(
        id: _uuid.v4(),
        hostId: host.id,
        shortcutId: shortcutId,
        command: command,
        exitCode: exitCode,
        stdout: stdoutBuffer.toString(),
        stderr: stderrBuffer.toString(),
        durationMs: stopwatch.elapsedMilliseconds,
        executedAt: DateTime.now(),
      );
    } catch (e) {
      stopwatch.stop();
      if (e is AppException) rethrow;
      throw SSHExecutionException(
        systemLocalizations.sshCommandFailed(e.toString()),
        details: e,
      );
    } finally {
      if (client != null) await closeSSHClient(client);
    }
  }

  Future<TerminalSession> createInteractiveShell(
    SSHHost host, {
    String? password,
    String? passphrase,
  }) async {
    final terminal = Terminal(maxLines: 10000);
    final sessionId = _uuid.v4();

    final session = TerminalSession(
      id: sessionId,
      host: host,
      title: '${host.name} (${host.username}@${host.host})',
      terminal: terminal,
      createdAt: DateTime.now(),
      status: TerminalSessionStatus.connecting,
    );

    try {
      terminal.write(
        '${systemLocalizations.terminalConnectingTo('${host.username}@${host.host}:${host.port}')}\r\n',
      );

      final client = await _connections.connect(
        host,
        password: password,
        passphrase: passphrase,
        timeout: const Duration(seconds: 15),
      );

      session.client = client;

      final sshSession = await client
          .shell(
            pty: SSHPtyConfig(
              width: terminal.viewWidth > 0 ? terminal.viewWidth : 80,
              height: terminal.viewHeight > 0 ? terminal.viewHeight : 24,
              type: 'xterm-256color',
            ),
          )
          .timeout(const Duration(seconds: 15));

      session.sshSession = sshSession;
      session.status = TerminalSessionStatus.connected;
      terminal.write(
        '\x1b[32m${systemLocalizations.terminalConnectionSucceeded}\x1b[0m\r\n\r\n',
      );

      // Pipe SSH stdout & stderr to Terminal
      sshSession.stdout.listen(
        (data) {
          terminal.write(utf8.decode(data, allowMalformed: true));
        },
        onError: (err) {
          terminal.write(
            '\r\n\x1b[31m${systemLocalizations.terminalReadError(err.toString())}\x1b[0m\r\n',
          );
        },
      );

      sshSession.stderr.listen((data) {
        terminal.write(utf8.decode(data, allowMalformed: true));
      });

      // Pipe Terminal input to SSH
      terminal.onOutput = (output) {
        if (session.status == TerminalSessionStatus.connected) {
          sshSession.write(Uint8List.fromList(utf8.encode(output)));
        }
      };

      // Handle Terminal Resize
      terminal.onResize = (width, height, pixelWidth, pixelHeight) {
        if (session.status == TerminalSessionStatus.connected) {
          sshSession.resizeTerminal(width, height, pixelWidth, pixelHeight);
        }
      };

      // Handle termination
      sshSession.done
          .then((_) async {
            session.status = TerminalSessionStatus.disconnected;
            terminal.write(
              '\r\n\x1b[33m${systemLocalizations.remoteSessionClosed}\x1b[0m\r\n',
            );
            await closeSSHClient(client);
          })
          .catchError((err) async {
            await closeSSHClient(client);
            session.status = TerminalSessionStatus.error;
            session.errorMessage = err.toString();
            terminal.write(
              '\r\n\x1b[31m${systemLocalizations.terminalDisconnectedWithError(err.toString())}\x1b[0m\r\n',
            );
          });

      return session;
    } catch (e) {
      final client = session.client;
      if (client != null) await closeSSHClient(client);
      session.status = TerminalSessionStatus.error;
      session.errorMessage = e.toString();
      terminal.write(
        '\r\n\x1b[31m${systemLocalizations.connectionFailed(e.toString())}\x1b[0m\r\n',
      );
      return session;
    }
  }
}
