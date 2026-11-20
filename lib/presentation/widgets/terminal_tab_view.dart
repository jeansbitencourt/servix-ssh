import 'package:flutter/material.dart';
import 'package:xterm/xterm.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme/terminal_theme.dart';
import '../../domain/entities/terminal_session.dart';
import '../../l10n/app_localizations.dart';

class TerminalTabView extends StatefulWidget {
  final TerminalSession session;
  final bool isActive;
  final VoidCallback onReconnect;
  final VoidCallback onClose;

  const TerminalTabView({
    super.key,
    required this.session,
    required this.isActive,
    required this.onReconnect,
    required this.onClose,
  });

  @override
  State<TerminalTabView> createState() => _TerminalTabViewState();
}

enum _TerminalAction { clear, reconnect, close }

class _TerminalTabViewState extends State<TerminalTabView> {
  double _fontSize = AppTerminalTheme.textStyle.fontSize;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.isActive) _focusAfterLayout();
  }

  @override
  void didUpdateWidget(covariant TerminalTabView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) _focusAfterLayout();
  }

  void _focusAfterLayout() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.isActive) _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _adjustFontSize(double delta) {
    setState(() => _fontSize += delta);
    _focusNode.requestFocus();
  }

  void _runAction(_TerminalAction action) {
    switch (action) {
      case _TerminalAction.clear:
        widget.session.terminal.write('\x1b[2J\x1b[H');
        _focusAfterLayout();
      case _TerminalAction.reconnect:
        widget.onReconnect();
      case _TerminalAction.close:
        widget.onClose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final host = widget.session.host;
    final address = '${host.username}@${host.host}:${host.port}';
    final (statusText, statusColor) = switch (widget.session.status) {
      TerminalSessionStatus.connected => (
        l10n.terminalConnected,
        AppTheme.success,
      ),
      TerminalSessionStatus.connecting => (
        l10n.terminalConnecting,
        AppTheme.warning,
      ),
      TerminalSessionStatus.disconnected => (
        l10n.terminalDisconnected,
        const Color(0xFF94A3B8),
      ),
      TerminalSessionStatus.error => (l10n.terminalError, AppTheme.error),
    };

    return Column(
      children: [
        Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: const BoxDecoration(
            color: AppTheme.darkSurface,
            border: Border(bottom: BorderSide(color: AppTheme.darkBorder)),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 480;
              return Row(
                children: [
                  const SizedBox(width: 4),
                  Tooltip(
                    message: '$statusText · $address',
                    child: Icon(Icons.circle, size: 8, color: statusColor),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            statusText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12, color: statusColor),
                          ),
                        ),
                        if (!compact) ...[
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 3,
                            child: Tooltip(
                              message: address,
                              child: Text(
                                address,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontFamily: AppTerminalTheme.fontFamily,
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  _toolbarButton(
                    Icons.remove,
                    l10n.decreaseFontSize,
                    _fontSize > 10 ? () => _adjustFontSize(-1) : null,
                  ),
                  SizedBox(
                    width: 28,
                    child: Text(
                      '${_fontSize.toInt()}px',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 11,
                        fontFamily: AppTerminalTheme.fontFamily,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ),
                  _toolbarButton(
                    Icons.add,
                    l10n.increaseFontSize,
                    _fontSize < 24 ? () => _adjustFontSize(1) : null,
                  ),
                  if (compact)
                    PopupMenuButton<_TerminalAction>(
                      icon: const Icon(Icons.more_vert, size: 16),
                      tooltip: l10n.terminalActions,
                      onSelected: _runAction,
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: _TerminalAction.clear,
                          child: Text(l10n.clearScreen),
                        ),
                        PopupMenuItem(
                          value: _TerminalAction.reconnect,
                          child: Text(l10n.reconnect),
                        ),
                        PopupMenuItem(
                          value: _TerminalAction.close,
                          child: Text(l10n.closeTerminal),
                        ),
                      ],
                    )
                  else ...[
                    _toolbarButton(
                      Icons.cleaning_services_outlined,
                      l10n.clearScreen,
                      () => _runAction(_TerminalAction.clear),
                    ),
                    _toolbarButton(
                      Icons.refresh,
                      l10n.reconnect,
                      widget.onReconnect,
                    ),
                    _toolbarButton(
                      Icons.close,
                      l10n.closeTerminal,
                      widget.onClose,
                    ),
                  ],
                ],
              );
            },
          ),
        ),
        Expanded(
          child: ExcludeFocus(
            excluding: !widget.isActive,
            child: TerminalView(
              widget.session.terminal,
              theme: AppTerminalTheme.dark,
              textStyle: AppTerminalTheme.textStyle.copyWith(
                fontSize: _fontSize,
              ),
              focusNode: _focusNode,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _toolbarButton(IconData icon, String label, VoidCallback? onPressed) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      tooltip: label,
      constraints: const BoxConstraints.tightFor(width: 36, height: 40),
      padding: EdgeInsets.zero,
    );
  }
}
