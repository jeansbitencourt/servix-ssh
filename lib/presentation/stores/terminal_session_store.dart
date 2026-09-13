import 'package:signals_flutter/signals_flutter.dart';
import '../../domain/entities/ssh_host.dart';
import '../../domain/entities/terminal_session.dart';
import '../../domain/usecases/open_ssh_session_usecase.dart';

class TerminalSessionStore {
  final OpenSSHSessionUseCase _openSSHSessionUseCase;

  TerminalSessionStore(this._openSSHSessionUseCase);

  final sessions = signal<List<TerminalSession>>([]);
  final activeSessionId = signal<String?>(null);

  late final activeSession = computed<TerminalSession?>(() {
    final id = activeSessionId.value;
    if (id == null) return null;
    return sessions.value.where((s) => s.id == id).firstOrNull;
  });

  Future<TerminalSession> openSession(SSHHost host) async {
    final session = await _openSSHSessionUseCase.call(host);

    final updated = List<TerminalSession>.from(sessions.value)..add(session);
    sessions.value = updated;
    activeSessionId.value = session.id;

    return session;
  }

  void setActiveSession(String id) {
    activeSessionId.value = id;
  }

  void closeSession(String id) {
    final target = sessions.value.where((s) => s.id == id).firstOrNull;
    target?.close();

    final updated = sessions.value.where((s) => s.id != id).toList();
    sessions.value = updated;

    if (activeSessionId.value == id) {
      activeSessionId.value = updated.isNotEmpty ? updated.last.id : null;
    }
  }

  void closeAll() {
    for (final session in sessions.value) {
      session.close();
    }
    sessions.value = [];
    activeSessionId.value = null;
  }
}
