import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/entities/ssh_host.dart';
import '../../domain/entities/ssh_tunnel.dart';
import '../../domain/entities/tunnel_session.dart';
import '../../l10n/app_localizations.dart';
import '../stores/host_store.dart';
import '../stores/tunnel_store.dart';
import '../widgets/operation_empty_state.dart';
import '../widgets/tunnel_form_dialog.dart';
import '../widgets/tunnel_icon.dart';

class TunnelsView extends StatelessWidget {
  const TunnelsView({
    super.key,
    required this.store,
    required this.hostStore,
    required this.onOpenServers,
  });

  final TunnelStore store;
  final HostStore hostStore;
  final VoidCallback onOpenServers;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SignalBuilder(
      builder: (context) {
        if (store.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (store.loadFailed.value) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                l10n.tunnelLoadError,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppTheme.error),
              ),
            ),
          );
        }

        final hosts = hostStore.hosts.value;
        final tunnels = store.tunnels.value;
        final newTunnel = ElevatedButton.icon(
          onPressed: hosts.isEmpty ? null : () => _edit(context, hosts),
          icon: const Icon(Icons.add, size: 18),
          label: Text(l10n.tunnelNew),
        );
        if (tunnels.isEmpty) {
          return OperationEmptyState(
            icon: const TunnelIcon(),
            title: l10n.tunnelEmpty,
            description: hosts.isEmpty
                ? l10n.tunnelAddServer
                : l10n.tunnelEmptyDescription,
            action: hosts.isEmpty
                ? ElevatedButton.icon(
                    onPressed: onOpenServers,
                    icon: const Icon(Icons.dns_rounded, size: 18),
                    label: Text(l10n.servers),
                  )
                : newTunnel,
          );
        }

        final sessions = store.sessions.value;
        return ListView(
          padding: EdgeInsets.all(
            MediaQuery.sizeOf(context).width < 600 ? 16 : 24,
          ),
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: [
                Text(
                  l10n.tunnels,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                newTunnel,
              ],
            ),
            const SizedBox(height: 20),
            for (final tunnel in tunnels)
              _card(
                context,
                tunnel,
                sessions[tunnel.id] ?? const TunnelSession(),
                hosts,
              ),
          ],
        );
      },
    );
  }

  Widget _card(
    BuildContext context,
    SSHTunnel tunnel,
    TunnelSession session,
    List<SSHHost> hosts,
  ) {
    final l10n = AppLocalizations.of(context);
    final host = hosts.where((host) => host.id == tunnel.hostId).firstOrNull;
    final (status, color) = switch (session.status) {
      TunnelStatus.disconnected => (
        l10n.tunnelDisconnected,
        Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      TunnelStatus.connecting => (l10n.tunnelConnecting, AppTheme.warning),
      TunnelStatus.connected => (l10n.tunnelConnected, AppTheme.success),
      TunnelStatus.disconnecting => (
        l10n.tunnelDisconnecting,
        AppTheme.warning,
      ),
      TunnelStatus.reconnecting => (l10n.tunnelReconnecting, AppTheme.warning),
      TunnelStatus.error => (l10n.tunnelError, AppTheme.error),
    };

    final issue =
        session.message ??
        switch (session.issue) {
          null => null,
          TunnelIssue.invalidConfiguration => l10n.tunnelInvalidConfiguration,
          TunnelIssue.configurationStorage => l10n.tunnelLoadError,
          TunnelIssue.missingServer => l10n.tunnelMissingServer,
          TunnelIssue.localPortInUse => l10n.tunnelPortInUse(tunnel.localPort),
          TunnelIssue.localListener => l10n.tunnelListenerError,
          TunnelIssue.sshUnavailable => l10n.sshServerUnavailable(
            host?.host ?? tunnel.hostId,
          ),
          TunnelIssue.authentication => l10n.sshAuthenticationFailed,
          TunnelIssue.hostKeyRejected => l10n.hostKeyRejected,
          TunnelIssue.hostKeyChanged => l10n.hostKeyChangedError,
          TunnelIssue.hostKeyStorage => l10n.hostKeyStorageError,
          TunnelIssue.forwardingRefused => l10n.tunnelForwardingRefused,
          TunnelIssue.destinationUnavailable =>
            l10n.tunnelDestinationUnavailable,
          TunnelIssue.transfer => l10n.tunnelTransferError,
          TunnelIssue.disconnected => l10n.tunnelUnexpectedDisconnect,
        };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tunnel.name,
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            if (host != null)
              Text(host.name, style: const TextStyle(color: Color(0xFF94A3B8))),
            const SizedBox(height: 8),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              children: [
                Text(
                  tunnel.localAddress,
                  style: const TextStyle(fontFamily: 'TerminalMono'),
                ),
                IconButton(
                  tooltip: l10n.tunnelCopy,
                  icon: const Icon(Icons.copy, size: 16),
                  onPressed: () async {
                    await Clipboard.setData(
                      ClipboardData(text: tunnel.localAddress),
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.tunnelCopied)),
                      );
                    }
                  },
                ),
                const Icon(Icons.arrow_forward, size: 16),
                SelectableText(
                  tunnel.remoteAddress,
                  style: const TextStyle(fontFamily: 'TerminalMono'),
                ),
              ],
            ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(color: color, fontSize: 12),
                  ),
                ),
                if (session.status == TunnelStatus.connected)
                  Text(l10n.tunnelConnections(session.connections)),
              ],
            ),
            if (issue != null) ...[
              const SizedBox(height: 8),
              Text(issue, style: const TextStyle(color: AppTheme.error)),
            ],
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (session.status.isActive)
                  OutlinedButton.icon(
                    onPressed: session.status == TunnelStatus.disconnecting
                        ? null
                        : () => store.stop(tunnel.id),
                    icon: const Icon(Icons.stop),
                    label: Text(l10n.tunnelStop),
                  )
                else
                  ElevatedButton.icon(
                    onPressed: () => store.start(tunnel),
                    icon: const Icon(Icons.play_arrow),
                    label: Text(l10n.tunnelStart),
                  ),
                IconButton(
                  tooltip: l10n.edit,
                  onPressed: session.status.isActive || hosts.isEmpty
                      ? null
                      : () => _edit(context, hosts, tunnel),
                  icon: const Icon(Icons.edit_outlined),
                ),
                IconButton(
                  tooltip: l10n.delete,
                  onPressed: () => _delete(context, tunnel),
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _edit(
    BuildContext context,
    List<SSHHost> hosts, [
    SSHTunnel? tunnel,
  ]) => showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) =>
        TunnelFormDialog(hosts: hosts, tunnel: tunnel, save: store.save),
  );

  Future<void> _delete(BuildContext context, SSHTunnel tunnel) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.tunnelDeleteTitle),
        content: Text(l10n.tunnelDeleteBody(tunnel.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    try {
      await store.delete(tunnel.id);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.tunnelDeleteError)));
      }
    }
  }
}
