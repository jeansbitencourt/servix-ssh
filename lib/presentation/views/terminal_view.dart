import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/entities/ssh_host.dart';
import '../../domain/entities/terminal_session.dart';
import '../stores/host_store.dart';
import '../stores/terminal_session_store.dart';
import '../widgets/terminal_tab_view.dart';

class TerminalViewScreen extends StatelessWidget {
  final TerminalSessionStore terminalStore;
  final HostStore hostStore;
  final bool isVisible;

  const TerminalViewScreen({
    super.key,
    required this.terminalStore,
    required this.hostStore,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (context) {
        final sessions = terminalStore.sessions.value;
        final activeId = terminalStore.activeSessionId.value;
        final hosts = hostStore.hosts.value;

        if (sessions.isEmpty) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppTheme.darkSurfaceCard,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.darkBorder),
                    ),
                    child: const Icon(
                      Icons.terminal_rounded,
                      size: 64,
                      color: AppTheme.accent,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Nenhum Terminal Aberto',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Abra uma sessão SSH interativa direta para executar comandos no servidor.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () => _showOpenSessionDialog(context, hosts),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Iniciar Sessão SSH'),
                  ),
                ],
              ),
            ),
          );
        }

        final activeIndex = sessions.indexWhere((s) => s.id == activeId);
        final validIndex = activeIndex >= 0 ? activeIndex : 0;

        return Column(
          children: [
            // Top Tab Bar
            Container(
              height: 42,
              decoration: const BoxDecoration(
                color: AppTheme.darkSurface,
                border: Border(bottom: BorderSide(color: AppTheme.darkBorder)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: sessions.length,
                      itemBuilder: (context, index) {
                        final s = sessions[index];
                        final isActive = index == validIndex;

                        Color dotColor =
                            s.status == TerminalSessionStatus.connected
                            ? AppTheme.success
                            : s.status == TerminalSessionStatus.connecting
                            ? AppTheme.warning
                            : const Color(0xFF64748B);

                        return InkWell(
                          onTap: () => terminalStore.setActiveSession(s.id),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? const Color(0xFF0A0E17)
                                  : Colors.transparent,
                              border: Border(
                                right: const BorderSide(
                                  color: AppTheme.darkBorder,
                                ),
                                top: isActive
                                    ? const BorderSide(
                                        color: AppTheme.accent,
                                        width: 2,
                                      )
                                    : BorderSide.none,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: dotColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: 200,
                                  ),
                                  child: Tooltip(
                                    message: s.title,
                                    child: Text(
                                      s.host.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: isActive
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: isActive
                                            ? Colors.white
                                            : const Color(0xFF94A3B8),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                InkWell(
                                  onTap: () => terminalStore.closeSession(s.id),
                                  borderRadius: BorderRadius.circular(10),
                                  child: const Padding(
                                    padding: EdgeInsets.all(2),
                                    child: Icon(
                                      Icons.close,
                                      size: 14,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Add New Terminal Session Button
                  IconButton(
                    onPressed: () => _showOpenSessionDialog(context, hosts),
                    icon: const Icon(Icons.add, size: 18),
                    splashRadius: 16,
                    tooltip: 'Nova Sessão SSH',
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),

            // Multi-tab Terminal View Body (IndexedStack to keep background PTY buffers alive!)
            Expanded(
              child: IndexedStack(
                index: validIndex,
                children: sessions.map((s) {
                  return TerminalTabView(
                    key: ValueKey(s.id),
                    session: s,
                    isActive: isVisible && s.id == sessions[validIndex].id,
                    onReconnect: () async {
                      terminalStore.closeSession(s.id);
                      await terminalStore.openSession(s.host);
                    },
                    onClose: () => terminalStore.closeSession(s.id),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showOpenSessionDialog(BuildContext context, List<SSHHost> hosts) {
    if (hosts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Cadastre pelo menos um servidor antes de abrir um terminal!',
          ),
          backgroundColor: AppTheme.warning,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Conectar ao Servidor'),
        children: hosts
            .map(
              (h) => SimpleDialogOption(
                onPressed: () async {
                  Navigator.pop(ctx);
                  await terminalStore.openSession(h);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.dns_rounded,
                          size: 16,
                          color: AppTheme.accent,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              h.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              '${h.username}@${h.host}:${h.port}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF94A3B8),
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        size: 16,
                        color: Color(0xFF64748B),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
