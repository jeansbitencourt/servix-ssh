import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/date_formatter.dart';
import '../../domain/entities/ssh_host.dart';
import '../../l10n/app_localizations.dart';
import '../stores/host_store.dart';
import '../stores/shortcut_store.dart';
import '../stores/terminal_session_store.dart';
import '../widgets/command_output_modal.dart';
import '../widgets/host_card.dart';
import '../widgets/host_form_dialog.dart';

class HostsView extends StatefulWidget {
  final HostStore hostStore;
  final ShortcutStore shortcutStore;
  final TerminalSessionStore terminalStore;
  final VoidCallback onNavigateToTerminal;

  const HostsView({
    super.key,
    required this.hostStore,
    required this.shortcutStore,
    required this.terminalStore,
    required this.onNavigateToTerminal,
  });

  @override
  State<HostsView> createState() => _HostsViewState();
}

class _HostsViewState extends State<HostsView> {
  bool _showDetails = false;

  HostStore get hostStore => widget.hostStore;
  ShortcutStore get shortcutStore => widget.shortcutStore;
  TerminalSessionStore get terminalStore => widget.terminalStore;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SignalBuilder(
      builder: (context) {
        final hosts = hostStore.filteredHosts.value;
        final selectedHost = hostStore.selectedHost.value;
        final groups = [null, ...hostStore.groups.value];
        final selectedGroup = hostStore.selectedGroup.value;
        final hasSearch = hostStore.searchQuery.value.isNotEmpty;
        final shortcuts = shortcutStore.shortcuts.value;
        final isTesting = hostStore.isTestingConnection.value;
        final testError = hostStore.connectionTestError.value;
        final testSuccess = hostStore.isConnectionSuccess.value;
        final testMessage = switch (testSuccess) {
          null => l10n.checkSshConnectivity,
          true => l10n.connectionTestSucceeded,
          false =>
            testError == null
                ? l10n.connectionTestReturnedFalse
                : l10n.connectionFailed(testError),
        };

        final lastRes = shortcutStore.lastResult.value;
        final isOutputOpen = shortcutStore.isOutputModalVisible.value;

        return LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 800;
            final showDetails = selectedHost != null && _showDetails;
            final listWidth = compact ? constraints.maxWidth : 320.0;

            return Stack(
              fit: StackFit.expand,
              children: [
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  width: listWidth,
                  child: Visibility(
                    visible: !compact || !showDetails,
                    maintainState: true,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppTheme.darkSurface,
                        border: Border(
                          right: BorderSide(color: AppTheme.darkBorder),
                        ),
                      ),
                      child: Column(
                        children: [
                          // Search & Actions Header
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                TextField(
                                  decoration: InputDecoration(
                                    hintText: l10n.hostSearchHint,
                                    prefixIcon: const Icon(
                                      Icons.search,
                                      size: 18,
                                    ),
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                    suffixIcon: hasSearch
                                        ? IconButton(
                                            icon: const Icon(
                                              Icons.clear,
                                              size: 16,
                                            ),
                                            onPressed: () =>
                                                hostStore.searchQuery.value =
                                                    '',
                                          )
                                        : null,
                                  ),
                                  onChanged: (v) =>
                                      hostStore.searchQuery.value = v,
                                ),
                                const SizedBox(height: 12),
                                // Group Chips
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: groups.map((g) {
                                      final isSelected = g == selectedGroup;
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          right: 6,
                                        ),
                                        child: ChoiceChip(
                                          label: Text(g ?? l10n.allGroups),
                                          selected: isSelected,
                                          onSelected: (_) =>
                                              hostStore.selectedGroup.value = g,
                                          selectedColor: AppTheme.primary
                                              .withValues(alpha: 0.2),
                                          labelStyle: TextStyle(
                                            fontSize: 12,
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            color: isSelected
                                                ? AppTheme.accent
                                                : const Color(0xFF94A3B8),
                                          ),
                                          side: BorderSide(
                                            color: isSelected
                                                ? AppTheme.primary
                                                : AppTheme.darkBorder,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(color: AppTheme.darkBorder, height: 1),

                          // Hosts List
                          Expanded(
                            child: hosts.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.dns_outlined,
                                          size: 40,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          l10n.noServersFound,
                                          style: TextStyle(
                                            color: Colors.grey[400],
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : ListView.separated(
                                    padding: const EdgeInsets.all(16),
                                    itemCount: hosts.length,
                                    separatorBuilder: (_, _) =>
                                        const SizedBox(height: 10),
                                    itemBuilder: (context, index) {
                                      final host = hosts[index];
                                      final isSelected =
                                          host.id == selectedHost?.id;

                                      return HostCard(
                                        host: host,
                                        isSelected: isSelected,
                                        onSelect: () {
                                          hostStore.selectHost(host);
                                          setState(() => _showDetails = true);
                                        },
                                        onOpenTerminal: () async {
                                          await terminalStore.openSession(host);
                                          widget.onNavigateToTerminal();
                                        },
                                        onEdit: () {
                                          showDialog(
                                            context: context,
                                            builder: (_) => HostFormDialog(
                                              hostToEdit: host,
                                              hostStore: hostStore,
                                            ),
                                          );
                                        },
                                        onDelete: () =>
                                            _confirmDelete(context, host),
                                      );
                                    },
                                  ),
                          ),

                          // Bottom Add Host Button
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(color: AppTheme.darkBorder),
                              ),
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) =>
                                        HostFormDialog(hostStore: hostStore),
                                  );
                                },
                                icon: const Icon(Icons.add_rounded, size: 18),
                                label: Text(l10n.addNewServer),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: compact ? 0 : listWidth,
                  right: 0,
                  child: Visibility(
                    visible: !compact || showDetails,
                    maintainState: true,
                    child: selectedHost == null
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.touch_app_outlined,
                                  size: 48,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  l10n.selectServerToInspect,
                                  style: TextStyle(
                                    color: Color(0xFF94A3B8),
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SingleChildScrollView(
                            padding: EdgeInsets.all(compact ? 16 : 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (compact) ...[
                                  TextButton.icon(
                                    onPressed: () =>
                                        setState(() => _showDetails = false),
                                    icon: const Icon(
                                      Icons.arrow_back_rounded,
                                      size: 18,
                                    ),
                                    label: Text(l10n.backToList),
                                  ),
                                  const SizedBox(height: 12),
                                ],
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primary.withValues(
                                          alpha: 0.15,
                                        ),
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(
                                          color: AppTheme.primary.withValues(
                                            alpha: 0.3,
                                          ),
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.dns_rounded,
                                        size: 36,
                                        color: AppTheme.accent,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Wrap(
                                            spacing: 12,
                                            runSpacing: 6,
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            children: [
                                              Text(
                                                selectedHost.name,
                                                style: const TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color:
                                                      AppTheme.darkSurfaceCard,
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  border: Border.all(
                                                    color: AppTheme.darkBorder,
                                                  ),
                                                ),
                                                child: Text(
                                                  selectedHost.groupName,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(0xFFCBD5E1),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            '${selectedHost.username}@${selectedHost.host}:${selectedHost.port}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFF94A3B8),
                                              fontFamily: 'monospace',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    await terminalStore.openSession(
                                      selectedHost,
                                    );
                                    widget.onNavigateToTerminal();
                                  },
                                  icon: const Icon(
                                    Icons.terminal_rounded,
                                    size: 18,
                                  ),
                                  label: Text(l10n.openTerminal),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.accent,
                                    foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 14,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 28),

                                // Connection Test Banner
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppTheme.darkSurfaceCard,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppTheme.darkBorder,
                                    ),
                                  ),
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      final status = Row(
                                        children: [
                                          Icon(
                                            testSuccess == true
                                                ? Icons.check_circle
                                                : testSuccess == false
                                                ? Icons.error
                                                : Icons.network_check_rounded,
                                            color: testSuccess == true
                                                ? AppTheme.success
                                                : testSuccess == false
                                                ? AppTheme.error
                                                : AppTheme.accent,
                                            size: 22,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              testMessage,
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: testSuccess == true
                                                    ? AppTheme.success
                                                    : testSuccess == false
                                                    ? AppTheme.error
                                                    : const Color(0xFFCBD5E1),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                      final testButton = OutlinedButton(
                                        onPressed: isTesting
                                            ? null
                                            : () => hostStore.testConnection(
                                                selectedHost,
                                              ),
                                        child: isTesting
                                            ? const SizedBox(
                                                width: 16,
                                                height: 16,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                    ),
                                              )
                                            : Text(l10n.testConnection),
                                      );
                                      if (constraints.maxWidth < 400) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            status,
                                            const SizedBox(height: 12),
                                            testButton,
                                          ],
                                        );
                                      }
                                      return Row(
                                        children: [
                                          Expanded(child: status),
                                          const SizedBox(width: 12),
                                          testButton,
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 28),

                                // Technical Info Card
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: AppTheme.darkSurfaceCard,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppTheme.darkBorder,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        l10n.accessParameters,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      _buildParamRow(
                                        l10n.hostAddress,
                                        selectedHost.host,
                                      ),
                                      _buildParamRow(
                                        l10n.sshPort,
                                        selectedHost.port.toString(),
                                      ),
                                      _buildParamRow(
                                        l10n.username,
                                        selectedHost.username,
                                      ),
                                      _buildParamRow(
                                        l10n.authenticationType,
                                        selectedHost.authType ==
                                                SSHAuthType.privateKey
                                            ? l10n.privateKeyType
                                            : l10n.keyringPassword,
                                      ),
                                      if (selectedHost.keyFilePath != null)
                                        _buildParamRow(
                                          l10n.keyFile,
                                          selectedHost.keyFilePath!,
                                        ),
                                      _buildParamRow(
                                        l10n.addedOn,
                                        DateFormatter.formatDateTime(
                                          selectedHost.createdAt,
                                          l10n.localeName,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 28),

                                // Associated Shortcuts
                                Wrap(
                                  spacing: 12,
                                  runSpacing: 4,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Text(
                                      l10n.serverShortcuts,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      l10n.availableShortcuts(
                                        shortcuts
                                            .where(
                                              (s) =>
                                                  s.hostId == null ||
                                                  s.hostId == selectedHost.id,
                                            )
                                            .length,
                                      ),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF94A3B8),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                _buildShortcutsGrid(
                                  context,
                                  selectedHost,
                                  shortcuts,
                                ),
                              ],
                            ),
                          ),
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
          },
        );
      },
    );
  }

  Widget _buildParamRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFFE2E8F0),
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShortcutsGrid(
    BuildContext context,
    SSHHost host,
    dynamic shortcuts,
  ) {
    final l10n = AppLocalizations.of(context);
    final available = shortcuts
        .where((s) => s.hostId == null || s.hostId == host.id)
        .toList();

    if (available.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.darkSurfaceCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.darkBorder),
        ),
        child: Center(
          child: Text(
            l10n.noServerShortcuts,
            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) => GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: constraints.maxWidth >= 540 ? 2 : 1,
          mainAxisExtent: 100,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
        ),
        itemCount: available.length,
        itemBuilder: (context, index) {
          final s = available[index];
          final isRunning = shortcutStore.isShortcutRunning(s.id);

          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.darkSurfaceCard,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.darkBorder),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        s.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$ ${s.command}',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 11,
                          color: Color(0xFF94A3B8),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: isRunning
                      ? null
                      : () => shortcutStore.execute(s, host),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  child: isRunning
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.play_arrow_rounded, size: 18),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, SSHHost host) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteServerTitle),
        content: Text(l10n.deleteServerConfirmation(host.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              hostStore.deleteHost(host.id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }
}
