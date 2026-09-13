import 'package:flutter/material.dart';
import 'package:xterm/xterm.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/terminal_theme.dart';
import '../../domain/entities/terminal_session.dart';

class TerminalTabView extends StatefulWidget {
  final TerminalSession session;
  final VoidCallback onReconnect;
  final VoidCallback onClose;

  const TerminalTabView({
    super.key,
    required this.session,
    required this.onReconnect,
    required this.onClose,
  });

  @override
  State<TerminalTabView> createState() => _TerminalTabViewState();
}

class _TerminalTabViewState extends State<TerminalTabView> {
  double _fontSize = 14.0;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _clearTerminal() {
    widget.session.terminal.write('\x1b[2J\x1b[H');
  }

  @override
  Widget build(BuildContext context) {
    final status = widget.session.status;
    final host = widget.session.host;

    Color statusColor;
    String statusText;

    switch (status) {
      case TerminalSessionStatus.connected:
        statusColor = AppTheme.success;
        statusText = 'Conectado';
        break;
      case TerminalSessionStatus.connecting:
        statusColor = AppTheme.warning;
        statusText = 'Conectando...';
        break;
      case TerminalSessionStatus.disconnected:
        statusColor = const Color(0xFF94A3B8);
        statusText = 'Desconectado';
        break;
      case TerminalSessionStatus.error:
        statusColor = AppTheme.error;
        statusText = 'Erro';
        break;
    }

    return Container(
      color: const Color(0xFF0A0E17),
      child: Column(
        children: [
          // Terminal Toolbar
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              color: AppTheme.darkSurface,
              border: Border(bottom: BorderSide(color: AppTheme.darkBorder)),
            ),
            child: Row(
              children: [
                // Status indicator
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: statusColor.withValues(alpha: 0.5),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: statusColor,
                  ),
                ),
                const SizedBox(width: 14),
                Container(
                  height: 16,
                  width: 1,
                  color: AppTheme.darkBorder,
                ),
                const SizedBox(width: 14),
                Text(
                  '${host.username}@${host.host}:${host.port}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'monospace',
                    color: Color(0xFFCBD5E1),
                  ),
                ),
                const Spacer(),

                // Font size zoom controls
                IconButton(
                  onPressed: () {
                    if (_fontSize > 10) setState(() => _fontSize -= 1);
                  },
                  icon: const Icon(Icons.remove, size: 16),
                  splashRadius: 14,
                  tooltip: 'Diminuir Fonte',
                ),
                Text(
                  '${_fontSize.toInt()}px',
                  style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                ),
                IconButton(
                  onPressed: () {
                    if (_fontSize < 24) setState(() => _fontSize += 1);
                  },
                  icon: const Icon(Icons.add, size: 16),
                  splashRadius: 14,
                  tooltip: 'Aumentar Fonte',
                ),
                const SizedBox(width: 8),

                // Clear screen
                IconButton(
                  onPressed: _clearTerminal,
                  icon: const Icon(Icons.cleaning_services_outlined, size: 16),
                  splashRadius: 14,
                  tooltip: 'Limpar Tela',
                ),
                const SizedBox(width: 4),

                // Reconnect button
                IconButton(
                  onPressed: widget.onReconnect,
                  icon: const Icon(Icons.refresh, size: 16),
                  splashRadius: 14,
                  tooltip: 'Reconectar',
                ),
                const SizedBox(width: 4),

                // Close tab
                IconButton(
                  onPressed: widget.onClose,
                  icon: const Icon(Icons.close, size: 16),
                  splashRadius: 14,
                  tooltip: 'Fechar Terminal',
                ),
              ],
            ),
          ),

          // Embedded xterm TerminalView
          Expanded(
            child: TerminalView(
              widget.session.terminal,
              theme: AppTerminalTheme.dark,
              textStyle: TerminalStyle(
                fontSize: _fontSize,
                fontFamily: 'monospace',
                fontFamilyFallback: const ['JetBrains Mono', 'Fira Code', 'DejaVu Sans Mono', 'monospace'],
              ),
              focusNode: _focusNode,
              autofocus: true,
              padding: const EdgeInsets.all(14),
            ),
          ),
        ],
      ),
    );
  }
}
