import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/entities/ssh_host.dart';
import '../../l10n/app_localizations.dart';
import '../stores/host_store.dart';

class HostFormDialog extends StatefulWidget {
  final SSHHost? hostToEdit;
  final HostStore hostStore;

  const HostFormDialog({super.key, this.hostToEdit, required this.hostStore});

  @override
  State<HostFormDialog> createState() => _HostFormDialogState();
}

class _HostFormDialogState extends State<HostFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _hostController;
  late TextEditingController _portController;
  late TextEditingController _usernameController;
  late final TextEditingController _groupController;
  bool _hasInitializedGroup = false;
  late TextEditingController _passwordController;
  late TextEditingController _keyPathController;
  late TextEditingController _passphraseController;

  late SSHAuthType _authType;
  bool _obscurePassword = true;
  bool _obscurePassphrase = true;

  @override
  void initState() {
    super.initState();
    final h = widget.hostToEdit;
    _nameController = TextEditingController(text: h?.name ?? '');
    _hostController = TextEditingController(text: h?.host ?? '');
    _portController = TextEditingController(text: (h?.port ?? 22).toString());
    _usernameController = TextEditingController(text: h?.username ?? '');
    _passwordController = TextEditingController();
    _keyPathController = TextEditingController(text: h?.keyFilePath ?? '');
    _passphraseController = TextEditingController();

    _authType = h?.authType ?? SSHAuthType.password;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_hasInitializedGroup) return;

    final l10n = AppLocalizations.of(context);
    _groupController = TextEditingController(
      text: widget.hostToEdit?.groupName ?? l10n.defaultGroup,
    );
    _hasInitializedGroup = true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _hostController.dispose();
    _portController.dispose();
    _usernameController.dispose();
    _groupController.dispose();
    _passwordController.dispose();
    _keyPathController.dispose();
    _passphraseController.dispose();
    super.dispose();
  }

  Future<void> _pickKeyFile() async {
    final l10n = AppLocalizations.of(context);
    try {
      final file = await openFile(confirmButtonText: l10n.selectKey);
      if (!mounted || file == null) return;

      _keyPathController.text = file.path;
    } on PlatformException {
      if (!mounted) return;

      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.filePickerError),
          content: Text(l10n.enterKeyPathInstead),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.close),
            ),
          ],
        ),
      );
    }
  }

  SSHHost _buildHostFromForm(AppLocalizations l10n) {
    return SSHHost(
      id: widget.hostToEdit?.id ?? const Uuid().v4(),
      name: _nameController.text.trim(),
      host: _hostController.text.trim(),
      port: int.tryParse(_portController.text.trim()) ?? 22,
      username: _usernameController.text.trim(),
      authType: _authType,
      keyFilePath: _authType == SSHAuthType.privateKey
          ? _keyPathController.text.trim()
          : null,
      groupName: _groupController.text.trim().isEmpty
          ? l10n.defaultGroup
          : _groupController.text.trim(),
      createdAt: widget.hostToEdit?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isEditing = widget.hostToEdit != null;

    final compact = MediaQuery.sizeOf(context).width < 600;

    return Dialog(
      backgroundColor: AppTheme.darkSurface,
      insetPadding: EdgeInsets.symmetric(
        horizontal: compact ? 12 : 40,
        vertical: 24,
      ),
      child: Container(
        width: 680,
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
                        Icons.storage_rounded,
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
                                ? l10n.editSshConnection
                                : l10n.newSshConnection,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isEditing
                                ? l10n.editSshConnectionDescription
                                : l10n.newSshConnectionDescription,
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

                // Name & Group
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: l10n.serverNameField,
                          hintText: l10n.serverNameHint,
                          prefixIcon: const Icon(Icons.label_outline, size: 18),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty
                            ? l10n.nameRequired
                            : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _groupController,
                        decoration: InputDecoration(
                          labelText: l10n.serverGroupField,
                          hintText: l10n.serverGroupHint,
                          prefixIcon: const Icon(
                            Icons.folder_outlined,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Host, Port & Username
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: _hostController,
                        decoration: InputDecoration(
                          labelText: l10n.hostField,
                          hintText: l10n.hostHint,
                          prefixIcon: const Icon(
                            Icons.cloud_outlined,
                            size: 18,
                          ),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty
                            ? l10n.hostRequired
                            : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: _portController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: l10n.portField,
                          hintText: '22',
                          prefixIcon: const Icon(Icons.numbers, size: 18),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return null;
                          final p = int.tryParse(v);
                          if (p == null || p <= 0 || p > 65535) {
                            return l10n.invalidPort;
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: l10n.sshUsernameField,
                          hintText: l10n.sshUsernameHint,
                          prefixIcon: const Icon(
                            Icons.person_outline,
                            size: 18,
                          ),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty
                            ? l10n.usernameRequired
                            : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Auth Type Selector
                Text(
                  l10n.authenticationType,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFE2E8F0),
                  ),
                ),
                const SizedBox(height: 8),
                SegmentedButton<SSHAuthType>(
                  segments: [
                    ButtonSegment(
                      value: SSHAuthType.password,
                      label: Text(l10n.password),
                      icon: const Icon(Icons.password_rounded, size: 16),
                    ),
                    ButtonSegment(
                      value: SSHAuthType.privateKey,
                      label: Text(l10n.privateKeyAuthentication),
                      icon: const Icon(Icons.key_rounded, size: 16),
                    ),
                  ],
                  selected: {_authType},
                  onSelectionChanged: (newSet) {
                    setState(() {
                      _authType = newSet.first;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Conditional Auth Fields
                if (_authType == SSHAuthType.password) ...[
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: isEditing
                          ? l10n.newPasswordField
                          : l10n.sshPasswordField,
                      hintText: '••••••••••••',
                      prefixIcon: const Icon(Icons.lock_outline, size: 18),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          size: 18,
                        ),
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                    ),
                    validator: (v) {
                      if (!isEditing && (v == null || v.isEmpty)) {
                        return l10n.passwordRequired;
                      }
                      return null;
                    },
                  ),
                ] else ...[
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _keyPathController,
                          decoration: InputDecoration(
                            labelText: l10n.privateKeyPathField,
                            hintText: l10n.privateKeyPathHint,
                            prefixIcon: const Icon(
                              Icons.insert_drive_file_outlined,
                              size: 18,
                            ),
                          ),
                          validator: (v) {
                            if (_authType == SSHAuthType.privateKey &&
                                (v == null || v.trim().isEmpty)) {
                              return l10n.keyPathRequired;
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: _pickKeyFile,
                        icon: const Icon(Icons.file_open_outlined, size: 16),
                        label: Text(l10n.browseFiles),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.darkSurfaceCard,
                          foregroundColor: const Color(0xFFE2E8F0),
                          side: const BorderSide(color: AppTheme.darkBorder),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passphraseController,
                    obscureText: _obscurePassphrase,
                    decoration: InputDecoration(
                      labelText: l10n.keyPassphraseField,
                      hintText: l10n.keyPassphraseHint,
                      prefixIcon: const Icon(
                        Icons.lock_clock_outlined,
                        size: 18,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassphrase
                              ? Icons.visibility_off
                              : Icons.visibility,
                          size: 18,
                        ),
                        onPressed: () => setState(
                          () => _obscurePassphrase = !_obscurePassphrase,
                        ),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 24),
                const Divider(color: AppTheme.darkBorder),
                const SizedBox(height: 16),

                // Actions: Test connection + Save / Cancel
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  spacing: 10,
                  runSpacing: 8,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) return;
                        final host = _buildHostFromForm(l10n);
                        final pw = _passwordController.text.isNotEmpty
                            ? _passwordController.text
                            : null;
                        final passph = _passphraseController.text.isNotEmpty
                            ? _passphraseController.text
                            : null;

                        final ok = await widget.hostStore.testConnection(
                          host,
                          password: pw,
                          passphrase: passph,
                        );

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: ok
                                  ? AppTheme.success
                                  : AppTheme.error,
                              content: Text(
                                ok
                                    ? l10n.connectionTestSucceeded
                                    : l10n.connectionFailed(
                                        widget
                                                .hostStore
                                                .connectionTestError
                                                .value ??
                                            l10n.connectionTestReturnedFalse,
                                      ),
                              ),
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.network_check_rounded, size: 16),
                      label: Text(l10n.testConnection),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(l10n.cancel),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) return;
                        final host = _buildHostFromForm(l10n);
                        final pw = _passwordController.text.isNotEmpty
                            ? _passwordController.text
                            : null;
                        final passph = _passphraseController.text.isNotEmpty
                            ? _passphraseController.text
                            : null;

                        await widget.hostStore.saveHost(
                          host,
                          password: pw,
                          passphrase: passph,
                        );

                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      },
                      icon: const Icon(Icons.save_rounded, size: 16),
                      label: Text(
                        isEditing ? l10n.saveChanges : l10n.addServer,
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
