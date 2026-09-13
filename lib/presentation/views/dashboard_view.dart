import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_formatter.dart';
import '../../domain/entities/ssh_host.dart';
import '../stores/host_store.dart';
import '../stores/shortcut_store.dart';
import '../stores/terminal_session_store.dart';
import '../widgets/command_output_modal.dart';
import '../widgets/host_form_dialog.dart';

class DashboardView extends StatelessWidget {
  final HostStore hostStore;
  final ShortcutStore shortcutStore;
  final TerminalSessionStore terminalStore;
  final Function(int) onNavigateToTab;

  const DashboardView({
    super.key,
    required this.hostStore,
    required this.shortcutStore,
    required this.terminalStore,
    required this.onNavigateToTab,
  });

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(builder: (context) {
      final hosts = hostStore.hosts.value;
      final shortcuts = shortcutStore.shortcuts.value;
      final history = shortcutStore.executionHistory.value;
      final activeSessions = terminalStore.sessions.value;
      final lastRes = shortcutStore.lastResult.value;
      final isOutputOpen = shortcutStore.isOutputModalVisible.value;

      return Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome header
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Painel de Controle SSH',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Gerencie conexões, monitore servidores e dispare atalhos rápidos com 1 clique.',
                          style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                        ),
                      ],
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => HostFormDialog(hostStore: hostStore),
                        );
                      },
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: const Text('Novo Servidor'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // KPI Stat Cards
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricCard(
                        context,
                        title: 'Servidores Cadastrados',
                        value: hosts.length.toString(),
                        icon: Icons.dns_rounded,
                        color: AppTheme.primary,
                        onTap: () => onNavigateToTab(1),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildMetricCard(
                        context,
                        title: 'Atalhos Configurados',
                        value: shortcuts.length.toString(),
                        icon: Icons.flash_on_rounded,
                        color: AppTheme.accent,
                        onTap: () => onNavigateToTab(2),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildMetricCard(
                        context,
                        title: 'Terminais Ativos',
                        value: activeSessions.length.toString(),
                        icon: Icons.terminal_rounded,
                        color: AppTheme.success,
                        onTap: () => onNavigateToTab(3),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildMetricCard(
                        context,
                        title: 'Execuções Registradas',
                        value: history.length.toString(),
                        icon: Icons.history_rounded,
                        color: AppTheme.warning,
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Quick Execution & Active Servers
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Quick Run Shortcuts (Left flex: 3)
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppTheme.darkSurfaceCard,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppTheme.darkBorder),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.bolt_rounded, color: AppTheme.accent, size: 20),
                                const SizedBox(width: 8),
                                const Text(
                                  'Ações Rápidas de 1 Clique',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const Spacer(),
                                TextButton(
                                  onPressed: () => onNavigateToTab(2),
                                  child: const Text('Ver Todos'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            if (shortcuts.isEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 24),
                                child: Center(
                                  child: Text(
                                    'Nenhum atalho cadastrado ainda.',
                                    style: TextStyle(color: Colors.grey[500]),
                                  ),
                                ),
                              )
                            else
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: shortcuts.take(4).length,
                                separatorBuilder: (_, _) => const Divider(color: AppTheme.darkBorder, height: 16),
                                itemBuilder: (context, index) {
                                  final s = shortcuts[index];
                                  final isRunning = shortcutStore.isShortcutRunning(s.id);

                                  return Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: AppTheme.primary.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Icon(Icons.terminal, size: 16, color: AppTheme.primary),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              s.name,
                                              style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                                            ),
                                            Text(
                                              '\$ ${s.command}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'monospace',
                                                color: Color(0xFF94A3B8),
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      OutlinedButton(
                                        onPressed: isRunning || hosts.isEmpty
                                            ? null
                                            : () => _executeOnHost(context, s, hosts),
                                        child: isRunning
                                            ? const SizedBox(
                                                width: 14,
                                                height: 14,
                                                child: CircularProgressIndicator(strokeWidth: 2),
                                              )
                                            : const Text('Executar'),
                                      ),
                                    ],
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),

                    // Quick Host Connect (Right flex: 2)
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppTheme.darkSurfaceCard,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppTheme.darkBorder),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.speed_rounded, color: AppTheme.primary, size: 20),
                                const SizedBox(width: 8),
                                const Text(
                                  'Acesso Rápido',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const Spacer(),
                                TextButton(
                                  onPressed: () => onNavigateToTab(1),
                                  child: const Text('Servidores'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            if (hosts.isEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 24),
                                child: Center(
                                  child: Text(
                                    'Nenhum servidor cadastrado.',
                                    style: TextStyle(color: Colors.grey[500]),
                                  ),
                                ),
                              )
                            else
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: hosts.take(4).length,
                                separatorBuilder: (_, _) => const Divider(color: AppTheme.darkBorder, height: 16),
                                itemBuilder: (context, index) {
                                  final h = hosts[index];
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              h.name,
                                              style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                                            ),
                                            Text(
                                              '${h.username}@${h.host}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'monospace',
                                                color: Color(0xFF94A3B8),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          await terminalStore.openSession(h);
                                          onNavigateToTab(3);
                                        },
                                        icon: const Icon(Icons.terminal_rounded, size: 18, color: AppTheme.accent),
                                        tooltip: 'Abrir Terminal',
                                      ),
                                    ],
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Recent Execution History Table
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.darkSurfaceCard,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppTheme.darkBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Histórico de Execuções Recentes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (history.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32),
                          child: Center(
                            child: Text(
                              'Nenhum comando foi executado ainda.',
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                          ),
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: history.take(6).length,
                          separatorBuilder: (_, _) => const Divider(color: AppTheme.darkBorder, height: 12),
                          itemBuilder: (context, index) {
                            final item = history[index];
                            final isSuccess = item.isSuccess;

                            return InkWell(
                              onTap: () => shortcutStore.showResult(item),
                              borderRadius: BorderRadius.circular(8),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                child: Row(
                                  children: [
                                    Icon(
                                      isSuccess ? Icons.check_circle_outline : Icons.error_outline,
                                      color: isSuccess ? AppTheme.success : AppTheme.error,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        '\$ ${item.command}',
                                        style: const TextStyle(
                                          fontFamily: 'monospace',
                                          fontSize: 13,
                                          color: Color(0xFFE2E8F0),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: (isSuccess ? AppTheme.success : AppTheme.error)
                                            .withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        'Exit ${item.exitCode}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: isSuccess ? AppTheme.success : AppTheme.error,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      DateFormatter.formatDuration(item.durationMs),
                                      style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                                    ),
                                    const SizedBox(width: 16),
                                    Text(
                                      DateFormatter.formatDateTime(item.executedAt),
                                      style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Output modal overlay
          if (isOutputOpen && lastRes != null)
            CommandOutputModal(
              result: lastRes,
              onClose: () => shortcutStore.closeOutputModal(),
            ),
        ],
      );
    });
  }

  void _executeOnHost(BuildContext context, dynamic shortcut, List<SSHHost> hosts) {
    if (hosts.length == 1) {
      shortcutStore.execute(shortcut, hosts.first);
    } else {
      // Pick host
      showDialog(
        context: context,
        builder: (ctx) => SimpleDialog(
          title: const Text('Selecionar Servidor'),
          children: hosts
              .map(
                (h) => SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(ctx);
                    shortcutStore.execute(shortcut, h);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.dns_rounded, size: 16, color: AppTheme.accent),
                        const SizedBox(width: 10),
                        Text('${h.name} (${h.host})'),
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

  Widget _buildMetricCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.darkSurfaceCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.darkBorder),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
