import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

import '../../core/errors/exceptions.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/ssh_host.dart';
import '../../domain/entities/ssh_tunnel.dart';
import '../../l10n/app_localizations.dart';
import 'tunnel_icon.dart';

class TunnelFormDialog extends StatefulWidget {
  const TunnelFormDialog({
    super.key,
    required this.hosts,
    required this.save,
    this.tunnel,
  });

  final List<SSHHost> hosts;
  final Future<void> Function(SSHTunnel) save;
  final SSHTunnel? tunnel;

  @override
  State<TunnelFormDialog> createState() => _TunnelFormDialogState();
}

class _TunnelFormDialogState extends State<TunnelFormDialog> {
  final _form = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.tunnel?.name);
  late final _remoteHost = TextEditingController(
    text: widget.tunnel?.remoteHost,
  );
  late final _remotePort = TextEditingController(
    text: widget.tunnel?.remotePort.toString(),
  );
  late final _localPort = TextEditingController(
    text: widget.tunnel?.localPort.toString(),
  );
  late String? _hostId = widget.tunnel?.hostId ?? widget.hosts.firstOrNull?.id;
  late bool _autoReconnect = widget.tunnel?.autoReconnect ?? false;
  late bool _autoConnect = widget.tunnel?.autoConnect ?? false;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _remoteHost.dispose();
    _remotePort.dispose();
    _localPort.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving || !_form.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context);
    setState(() {
      _saving = true;
      _error = null;
    });
    final now = DateTime.now();
    try {
      await widget.save(
        SSHTunnel(
          id: widget.tunnel?.id ?? const Uuid().v4(),
          name: _name.text.trim(),
          hostId: _hostId!,
          localPort: int.parse(_localPort.text),
          remoteHost: _remoteHost.text.trim(),
          remotePort: int.parse(_remotePort.text),
          autoReconnect: _autoReconnect,
          autoConnect: _autoConnect,
          createdAt: widget.tunnel?.createdAt ?? now,
          updatedAt: now,
        ),
      );
      if (mounted) Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error is AppException ? error.message : l10n.tunnelSaveError;
        _saving = false;
      });
    }
  }

  InputDecoration _input(String label, IconData icon, {String? hint}) =>
      InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 18),
      );

  Widget _port(TextEditingController controller, String label, String example) {
    final l10n = AppLocalizations.of(context);
    return TextFormField(
      controller: controller,
      decoration: _input(label, Icons.numbers, hint: example),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (value) => SSHTunnel.isValidPort(int.tryParse(value ?? ''))
          ? null
          : l10n.tunnelPortInvalid,
    );
  }

  Widget _fieldGroup(bool compact, List<(int, Widget)> fields) => compact
      ? Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16,
          children: [for (final (_, field) in fields) field],
        )
      : Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            for (final (flex, field) in fields)
              Expanded(flex: flex, child: field),
          ],
        );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isEditing = widget.tunnel != null;
    final narrowWindow = MediaQuery.sizeOf(context).width < 600;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: narrowWindow ? 12 : 40,
        vertical: 24,
      ),
      child: SizedBox(
        width: 680,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(narrowWindow ? 16 : 28),
          child: Form(
            key: _form,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 540;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppTheme.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const IconTheme(
                            data: IconThemeData(
                              size: 24,
                              color: AppTheme.accent,
                            ),
                            child: TunnelIcon(),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isEditing ? l10n.tunnelEdit : l10n.tunnelNew,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                l10n.tunnelFormDescription,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: l10n.close,
                          onPressed: _saving
                              ? null
                              : () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.close,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 20),
                    _fieldGroup(compact, [
                      (
                        3,
                        TextFormField(
                          controller: _name,
                          autofocus: true,
                          decoration: _input(
                            l10n.tunnelName,
                            Icons.label_outline,
                          ),
                          validator: (value) => (value ?? '').trim().isEmpty
                              ? l10n.tunnelNameRequired
                              : null,
                        ),
                      ),
                      (
                        2,
                        DropdownButtonFormField<String>(
                          initialValue: widget.hosts.any((h) => h.id == _hostId)
                              ? _hostId
                              : null,
                          isExpanded: true,
                          decoration: _input(
                            l10n.tunnelServer,
                            Icons.dns_rounded,
                          ),
                          items: widget.hosts
                              .map(
                                (host) => DropdownMenuItem(
                                  value: host.id,
                                  child: Text(
                                    host.name,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (id) => _hostId = id,
                          validator: (id) =>
                              id == null ? l10n.tunnelMissingServer : null,
                        ),
                      ),
                    ]),
                    const SizedBox(height: 16),
                    _fieldGroup(compact, [
                      (
                        2,
                        TextFormField(
                          controller: _remoteHost,
                          decoration: _input(
                            l10n.tunnelRemoteHost,
                            Icons.cloud_outlined,
                          ),
                          validator: (value) =>
                              SSHTunnel.isValidRemoteHost((value ?? '').trim())
                              ? null
                              : l10n.tunnelInvalidTarget,
                        ),
                      ),
                      (1, _port(_remotePort, l10n.tunnelRemotePort, '3306')),
                      (1, _port(_localPort, l10n.tunnelLocalPort, '3307')),
                    ]),
                    const SizedBox(height: 12),
                    _fieldGroup(compact, [
                      (
                        1,
                        _option(
                          l10n.tunnelAutoReconnect,
                          _autoReconnect,
                          (value) => _autoReconnect = value,
                        ),
                      ),
                      (
                        1,
                        _option(
                          l10n.tunnelAutoConnect,
                          _autoConnect,
                          (value) => _autoConnect = value,
                        ),
                      ),
                    ]),
                    if (_error != null)
                      Text(
                        _error!,
                        style: const TextStyle(color: AppTheme.error),
                      ),
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 16),
                    Wrap(
                      alignment: WrapAlignment.end,
                      spacing: 10,
                      runSpacing: 8,
                      children: [
                        TextButton(
                          onPressed: _saving
                              ? null
                              : () => Navigator.pop(context),
                          child: Text(l10n.cancel),
                        ),
                        ElevatedButton.icon(
                          onPressed: _saving ? null : _save,
                          icon: const Icon(Icons.save_rounded, size: 16),
                          label: Text(
                            isEditing ? l10n.saveChanges : l10n.tunnelCreate,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _option(String label, bool enabled, ValueChanged<bool> onChanged) =>
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        dense: true,
        title: Text(label, style: Theme.of(context).textTheme.bodyMedium),
        value: enabled,
        onChanged: (value) => setState(() => onChanged(value)),
      );
}
