import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/entities/shortcut_command.dart';
import '../../domain/entities/ssh_host.dart';
import '../stores/host_store.dart';
import '../stores/shortcut_store.dart';
import '../widgets/command_output_modal.dart';
import '../widgets/shortcut_card.dart';
import '../widgets/shortcut_form_dialog.dart';

class ShortcutsView extends StatefulWidget {
  final ShortcutStore shortcutStore;
  final HostStore hostStore;

  const ShortcutsView({
    super.key,
    required this.shortcutStore,
    required this.hostStore,
  });

  @override
  State<ShortcutsView> createState() => _ShortcutsViewState();
}

class _ShortcutsViewState extends State<ShortcutsView> {
  SSHHost? _selectedTargetHost;

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (context) {
        final shortcuts = widget.shortcutStore.filteredShortcuts.value;
        final categories = widget.shortcutStore.categories.value;
        final selectedCategory = widget.shortcutStore.categoryFilter.value;
        final hosts = widget.hostStore.hosts.value;

        final runningShortcuts = widget.shortcutStore.runningShortcutIds.value;
        final lastRes = widget.shortcutStore.lastResult.value;
        final isOutputOpen = widget.shortcutStore.isOutputModalVisible.value;

        // Default target host if none selected
        final effectiveTarget =
            hosts
                .where((host) => host.id == _selectedTargetHost?.id)
                .firstOrNull ??
            hosts.firstOrNull;

        return LayoutBuilder(
          builder: (context, constraints) {
            final padding = constraints.maxWidth < 560 ? 16.0 : 28.0;
            final contentWidth = constraints.maxWidth - padding * 2;
            final columns = contentWidth >= 952
                ? 3
                : contentWidth >= 624
                ? 2
                : 1;

            return Stack(
              fit: StackFit.expand,
              children: [
                CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        padding,
                        padding,
                        padding,
                        24,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header & Target Host Selector
                            Wrap(
                              spacing: 14,
                              runSpacing: 12,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Atalhos de Comandos Remotos',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Execute comandos de diagnóstico, deploys e manutenção remotamente em 1 clique.',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                  ],
                                ),
                                // Target Host Dropdown
                                Container(
                                  width: 280,
                                  height: 44,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.darkSurfaceCard,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: AppTheme.darkBorder,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.dns_rounded,
                                        size: 16,
                                        color: AppTheme.accent,
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Alvo: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF94A3B8),
                                        ),
                                      ),
                                      Expanded(
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<SSHHost>(
                                            isExpanded: true,
                                            value: effectiveTarget,
                                            dropdownColor: AppTheme.darkSurface,
                                            hint: const Text(
                                              'Selecione um Servidor',
                                              style: TextStyle(fontSize: 13),
                                            ),
                                            items: hosts
                                                .map(
                                                  (h) => DropdownMenuItem(
                                                    value: h,
                                                    child: Text(
                                                      '${h.name} (${h.host})',
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                            onChanged: (val) {
                                              setState(() {
                                                _selectedTargetHost = val;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Add Shortcut Button
                                ElevatedButton.icon(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => ShortcutFormDialog(
                                        availableHosts: hosts,
                                        shortcutStore: widget.shortcutStore,
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.add_rounded, size: 18),
                                  label: const Text('Novo Atalho'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Category Filter Pills
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: categories.map((cat) {
                                  final isSelected = cat == selectedCategory;
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: ChoiceChip(
                                      label: Text(cat),
                                      selected: isSelected,
                                      onSelected: (_) =>
                                          widget
                                                  .shortcutStore
                                                  .categoryFilter
                                                  .value =
                                              cat,
                                      selectedColor: AppTheme.primary
                                          .withValues(alpha: 0.2),
                                      labelStyle: TextStyle(
                                        fontSize: 13,
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
                    ),
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        padding,
                        0,
                        padding,
                        padding,
                      ),
                      sliver: shortcuts.isEmpty
                          ? SliverToBoxAdapter(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.flash_off_outlined,
                                    size: 48,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Nenhum atalho encontrado para esta categoria',
                                    style: TextStyle(
                                      color: Color(0xFF94A3B8),
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (_) => ShortcutFormDialog(
                                          availableHosts: hosts,
                                          shortcutStore: widget.shortcutStore,
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.add, size: 16),
                                    label: const Text(
                                      'Cadastrar Primeiro Atalho',
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : SliverGrid.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: columns,
                                    mainAxisExtent: 190,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                  ),
                              itemCount: shortcuts.length,
                              itemBuilder: (context, index) {
                                final shortcut = shortcuts[index];
                                final isRunning = runningShortcuts.contains(
                                  shortcut.id,
                                );

                                return ShortcutCard(
                                  shortcut: shortcut,
                                  isRunning: isRunning,
                                  onExecute: () {
                                    if (effectiveTarget == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Cadastre ou selecione um servidor alvo para executar o comando!',
                                              ),
                                              backgroundColor: AppTheme.warning,
                                            ),
                                          );
                                      return;
                                    }
                                    widget.shortcutStore.execute(
                                      shortcut,
                                      effectiveTarget,
                                    );
                                  },
                                  onEdit: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => ShortcutFormDialog(
                                        shortcutToEdit: shortcut,
                                        availableHosts: hosts,
                                        shortcutStore: widget.shortcutStore,
                                      ),
                                    );
                                  },
                                  onDelete: () =>
                                      _confirmDelete(context, shortcut),
                                );
                              },
                            ),
                    ),
                  ],
                ),

                // Output modal overlay
                if (isOutputOpen && lastRes != null)
                  CommandOutputModal(
                    result: lastRes,
                    onRerun: effectiveTarget != null
                        ? () {
                            final currentShortcut = shortcuts
                                .where((s) => s.id == lastRes.shortcutId)
                                .firstOrNull;
                            if (currentShortcut != null) {
                              widget.shortcutStore.execute(
                                currentShortcut,
                                effectiveTarget,
                              );
                            }
                          }
                        : null,
                    onClose: () => widget.shortcutStore.closeOutputModal(),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, ShortcutCommand shortcut) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir Atalho?'),
        content: Text(
          'Tem certeza que deseja remover o atalho "${shortcut.name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              widget.shortcutStore.deleteShortcut(shortcut.id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}
