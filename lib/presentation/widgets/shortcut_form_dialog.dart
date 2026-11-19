import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/entities/shortcut_command.dart';
import '../../domain/entities/ssh_host.dart';
import '../stores/shortcut_store.dart';

class ShortcutFormDialog extends StatefulWidget {
  final ShortcutCommand? shortcutToEdit;
  final List<SSHHost> availableHosts;
  final ShortcutStore shortcutStore;

  const ShortcutFormDialog({
    super.key,
    this.shortcutToEdit,
    required this.availableHosts,
    required this.shortcutStore,
  });

  @override
  State<ShortcutFormDialog> createState() => _ShortcutFormDialogState();
}

class _ShortcutFormDialogState extends State<ShortcutFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _commandController;
  late TextEditingController _categoryController;
  late TextEditingController _workDirController;
  late TextEditingController _timeoutController;

  String? _selectedHostId;

  @override
  void initState() {
    super.initState();
    final s = widget.shortcutToEdit;
    _nameController = TextEditingController(text: s?.name ?? '');
    _commandController = TextEditingController(text: s?.command ?? '');
    _categoryController = TextEditingController(text: s?.category ?? 'Geral');
    _workDirController = TextEditingController(text: s?.workingDirectory ?? '');
    _timeoutController = TextEditingController(
      text: (s?.timeoutSeconds ?? 30).toString(),
    );
    _selectedHostId = s?.hostId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _commandController.dispose();
    _categoryController.dispose();
    _workDirController.dispose();
    _timeoutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.shortcutToEdit != null;

    final compact = MediaQuery.sizeOf(context).width < 600;

    return Dialog(
      backgroundColor: AppTheme.darkSurface,
      insetPadding: EdgeInsets.symmetric(
        horizontal: compact ? 12 : 40,
        vertical: 24,
      ),
      child: Container(
        width: 620,
        padding: EdgeInsets.all(compact ? 16 : 28),
        decoration: BoxDecoration(
          color: AppTheme.darkSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.darkBorder),
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.flash_on_rounded,
                        color: AppTheme.accent,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isEditing
                                ? 'Editar Atalho de Comando'
                                : 'Novo Atalho de Comando',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isEditing
                                ? 'Modifique as instruções e opções do comando'
                                : 'Cadastre um comando rápido para execução remota em 1 clique',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, color: Color(0xFF94A3B8)),
                      splashRadius: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(color: AppTheme.darkBorder),
                const SizedBox(height: 20),

                // Name & Category
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nome do Atalho *',
                          hintText: 'ex: Verificar Uso de Disco',
                          prefixIcon: Icon(Icons.title, size: 18),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty
                            ? 'Nome é obrigatório'
                            : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _categoryController,
                        decoration: const InputDecoration(
                          labelText: 'Categoria',
                          hintText: 'ex: Sistema, Docker',
                          prefixIcon: Icon(Icons.category_outlined, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Command (Monospace)
                TextFormField(
                  controller: _commandController,
                  maxLines: 3,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
                  decoration: const InputDecoration(
                    labelText: 'Comando Remoto *',
                    hintText: 'ex: df -h && free -m',
                    alignLabelWithHint: true,
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(bottom: 45),
                      child: Icon(Icons.terminal, size: 18),
                    ),
                  ),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Comando é obrigatório'
                      : null,
                ),
                const SizedBox(height: 16),

                // Working Directory & Timeout
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: _workDirController,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Diretório de Trabalho (opcional)',
                          hintText: 'ex: /var/www/meu-app',
                          prefixIcon: Icon(
                            Icons.folder_open_outlined,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: _timeoutController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Timeout (s)',
                          hintText: '30',
                          prefixIcon: Icon(Icons.timer_outlined, size: 18),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return null;
                          final t = int.tryParse(v);
                          if (t == null || t <= 0) return 'Inválido';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Host Association Dropdown
                DropdownButtonFormField<String?>(
                  isExpanded: true,
                  initialValue: _selectedHostId,
                  dropdownColor: AppTheme.darkSurface,
                  decoration: const InputDecoration(
                    labelText: 'Vínculo com Servidor',
                    prefixIcon: Icon(Icons.link, size: 18),
                  ),
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text(
                        'Global (Disponível para qualquer servidor)',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ...widget.availableHosts.map(
                      (h) => DropdownMenuItem<String?>(
                        value: h.id,
                        child: Text(
                          '${h.name} (${h.host})',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                  onChanged: (val) {
                    setState(() {
                      _selectedHostId = val;
                    });
                  },
                ),

                const SizedBox(height: 24),
                const Divider(color: AppTheme.darkBorder),
                const SizedBox(height: 16),

                // Actions
                Wrap(
                  alignment: WrapAlignment.end,
                  spacing: 10,
                  runSpacing: 8,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancelar'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) return;

                        final shortcut = ShortcutCommand(
                          id: widget.shortcutToEdit?.id ?? const Uuid().v4(),
                          hostId: _selectedHostId,
                          name: _nameController.text.trim(),
                          command: _commandController.text.trim(),
                          workingDirectory:
                              _workDirController.text.trim().isNotEmpty
                              ? _workDirController.text.trim()
                              : null,
                          timeoutSeconds:
                              int.tryParse(_timeoutController.text.trim()) ??
                              30,
                          category: _categoryController.text.trim().isNotEmpty
                              ? _categoryController.text.trim()
                              : 'Geral',
                          createdAt:
                              widget.shortcutToEdit?.createdAt ??
                              DateTime.now(),
                        );

                        await widget.shortcutStore.saveShortcut(shortcut);

                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      },
                      icon: const Icon(Icons.save_rounded, size: 16),
                      label: Text(
                        isEditing ? 'Salvar Alterações' : 'Criar Atalho',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
