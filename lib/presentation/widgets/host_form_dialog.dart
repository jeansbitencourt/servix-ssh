import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/ssh_host.dart';
import '../stores/host_store.dart';

class HostFormDialog extends StatefulWidget {
  final SSHHost? hostToEdit;
  final HostStore hostStore;

  const HostFormDialog({
    super.key,
    this.hostToEdit,
    required this.hostStore,
  });

  @override
  State<HostFormDialog> createState() => _HostFormDialogState();
}

class _HostFormDialogState extends State<HostFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _hostController;
  late TextEditingController _portController;
  late TextEditingController _usernameController;
  late TextEditingController _groupController;
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
    _groupController = TextEditingController(text: h?.groupName ?? 'Default');
    _passwordController = TextEditingController();
    _keyPathController = TextEditingController(text: h?.keyFilePath ?? '');
    _passphraseController = TextEditingController();

    _authType = h?.authType ?? SSHAuthType.password;
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
    final result = await FilePicker.platform.pickFiles(
      dialogTitle: 'Selecionar Arquivo de Chave SSH Privada',
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _keyPathController.text = result.files.single.path!;
      });
    }
  }

  SSHHost _buildHostFromForm() {
    return SSHHost(
      id: widget.hostToEdit?.id ?? const Uuid().v4(),
      name: _nameController.text.trim(),
      host: _hostController.text.trim(),
      port: int.tryParse(_portController.text.trim()) ?? 22,
      username: _usernameController.text.trim(),
      authType: _authType,
      keyFilePath: _authType == SSHAuthType.privateKey ? _keyPathController.text.trim() : null,
      groupName: _groupController.text.trim().isEmpty ? 'Default' : _groupController.text.trim(),
      createdAt: widget.hostToEdit?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.hostToEdit != null;

    return Dialog(
      backgroundColor: AppTheme.darkSurface,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      child: Container(
        width: 680,
        padding: const EdgeInsets.all(28),
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
                      child: const Icon(Icons.storage_rounded, color: AppTheme.accent),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEditing ? 'Editar Conexão SSH' : 'Nova Conexão SSH',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isEditing
                              ? 'Atualize os dados e credenciais do servidor'
                              : 'Configure as credenciais e parâmetros de acesso ao servidor',
                          style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                        ),
                      ],
                    ),
                    const Spacer(),
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
                        decoration: const InputDecoration(
                          labelText: 'Nome do Servidor *',
                          hintText: 'ex: VPS Produção 01',
                          prefixIcon: Icon(Icons.label_outline, size: 18),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Nome é obrigatório' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _groupController,
                        decoration: const InputDecoration(
                          labelText: 'Grupo / Tag',
                          hintText: 'ex: Produção',
                          prefixIcon: Icon(Icons.folder_outlined, size: 18),
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
                        decoration: const InputDecoration(
                          labelText: 'Host / IP *',
                          hintText: 'ex: 192.168.1.100 ou vps.dominio.com',
                          prefixIcon: Icon(Icons.cloud_outlined, size: 18),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Host é obrigatório' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: _portController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Porta',
                          hintText: '22',
                          prefixIcon: Icon(Icons.numbers, size: 18),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return null;
                          final p = int.tryParse(v);
                          if (p == null || p <= 0 || p > 65535) return 'Inválida';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Usuário SSH *',
                          hintText: 'ex: root, ubuntu',
                          prefixIcon: Icon(Icons.person_outline, size: 18),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Usuário é obrigatório' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Auth Type Selector
                const Text(
                  'Tipo de Autenticação',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFE2E8F0),
                  ),
                ),
                const SizedBox(height: 8),
                SegmentedButton<SSHAuthType>(
                  segments: const [
                    ButtonSegment(
                      value: SSHAuthType.password,
                      label: Text('Senha'),
                      icon: Icon(Icons.password_rounded, size: 16),
                    ),
                    ButtonSegment(
                      value: SSHAuthType.privateKey,
                      label: Text('Chave Privada (SSH Key)'),
                      icon: Icon(Icons.key_rounded, size: 16),
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
                      labelText: isEditing ? 'Nova Senha (deixe em branco para manter a atual)' : 'Senha SSH *',
                      hintText: '••••••••••••',
                      prefixIcon: const Icon(Icons.lock_outline, size: 18),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, size: 18),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    validator: (v) {
                      if (!isEditing && (v == null || v.isEmpty)) {
                        return 'Senha é obrigatória para novas conexões';
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
                          decoration: const InputDecoration(
                            labelText: 'Caminho do Arquivo de Chave Privada *',
                            hintText: '/home/usuario/.ssh/id_rsa ou id_ed25519',
                            prefixIcon: Icon(Icons.insert_drive_file_outlined, size: 18),
                          ),
                          validator: (v) {
                            if (_authType == SSHAuthType.privateKey && (v == null || v.trim().isEmpty)) {
                              return 'Caminho do arquivo de chave é obrigatório';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: _pickKeyFile,
                        icon: const Icon(Icons.file_open_outlined, size: 16),
                        label: const Text('Procurar...'),
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
                      labelText: 'Passphrase da Chave (opcional)',
                      hintText: 'Deixe vazio se a chave não for criptografada',
                      prefixIcon: const Icon(Icons.lock_clock_outlined, size: 18),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassphrase ? Icons.visibility_off : Icons.visibility, size: 18),
                        onPressed: () => setState(() => _obscurePassphrase = !_obscurePassphrase),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 24),
                const Divider(color: AppTheme.darkBorder),
                const SizedBox(height: 16),

                // Actions: Test connection + Save / Cancel
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) return;
                        final host = _buildHostFromForm();
                        final pw = _passwordController.text.isNotEmpty ? _passwordController.text : null;
                        final passph = _passphraseController.text.isNotEmpty ? _passphraseController.text : null;

                        final ok = await widget.hostStore.testConnection(
                          host,
                          password: pw,
                          passphrase: passph,
                        );

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: ok ? AppTheme.success : AppTheme.error,
                              content: Text(ok
                                  ? 'Conexão SSH bem-sucedida!'
                                  : 'Falha ao conectar: ${widget.hostStore.connectionTestResult.value ?? ""}'),
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.network_check_rounded, size: 16),
                      label: const Text('Testar Conexão'),
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancelar'),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          onPressed: () async {
                            if (!_formKey.currentState!.validate()) return;
                            final host = _buildHostFromForm();
                            final pw = _passwordController.text.isNotEmpty ? _passwordController.text : null;
                            final passph = _passphraseController.text.isNotEmpty ? _passphraseController.text : null;

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
                          label: Text(isEditing ? 'Salvar Alterações' : 'Cadastrar Servidor'),
                        ),
                      ],
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
