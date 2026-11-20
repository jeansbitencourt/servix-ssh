import 'dart:async';

import 'dart:ui' show AppExitResponse;

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';
import 'domain/entities/shortcut_command.dart';
import 'domain/repositories/shortcut_repository.dart';
import 'l10n/app_localizations.dart';
import 'l10n/system_localizations.dart';
import 'presentation/stores/terminal_session_store.dart';
import 'presentation/stores/tunnel_store.dart';
import 'presentation/views/main_layout.dart';
import 'presentation/widgets/ssh_host_key_dialogs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetIt dependencies
  await initDependencies();

  // Seed default popular shortcuts if database has none
  await _seedDefaultShortcuts();

  runApp(const ServixApp());
}

Future<void> _seedDefaultShortcuts() async {
  final shortcutRepo = sl<ShortcutRepository>();
  final existing = await shortcutRepo.getShortcuts();

  if (existing.isEmpty) {
    final l10n = systemLocalizations;
    const uuid = Uuid();
    final defaultShortcuts = [
      ShortcutCommand(
        id: uuid.v4(),
        name: l10n.seedUptime,
        command: 'uptime && cat /proc/loadavg',
        category: l10n.seedSystemCategory,
        timeoutSeconds: 15,
        createdAt: DateTime.now(),
      ),
      ShortcutCommand(
        id: uuid.v4(),
        name: l10n.seedMemory,
        command: 'free -h',
        category: l10n.seedSystemCategory,
        timeoutSeconds: 15,
        createdAt: DateTime.now(),
      ),
      ShortcutCommand(
        id: uuid.v4(),
        name: l10n.seedDisk,
        command: 'df -h -x tmpfs -x devtmpfs',
        category: l10n.seedSystemCategory,
        timeoutSeconds: 15,
        createdAt: DateTime.now(),
      ),
      ShortcutCommand(
        id: uuid.v4(),
        name: l10n.seedDocker,
        command: 'docker ps --format "table {{.ID}}\\t{{.Image}}\\t{{.Status}}\\t{{.Names}}"',
        category: 'Docker',
        timeoutSeconds: 20,
        createdAt: DateTime.now(),
      ),
      ShortcutCommand(
        id: uuid.v4(),
        name: l10n.seedSyslog,
        command: 'tail -n 50 /var/log/syslog 2>/dev/null || journalctl -n 50 --no-pager',
        category: 'Logs',
        timeoutSeconds: 20,
        createdAt: DateTime.now(),
      ),
    ];

    for (final s in defaultShortcuts) {
      await shortcutRepo.saveShortcut(s);
    }
  }
}

class ServixApp extends StatefulWidget {
  const ServixApp({super.key});

  @override
  State<ServixApp> createState() => _ServixAppState();
}

class _ServixAppState extends State<ServixApp> {
  final _tunnels = sl<TunnelStore>();
  final _terminals = sl<TerminalSessionStore>();
  final _keyDialogs = sl<SSHHostKeyDialogs>();
  late final AppLifecycleListener _lifecycle;
  Future<void>? _shutdown;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(
      onExitRequested: () async {
        await _closeConnections();
        return AppExitResponse.exit;
      },
      onDetach: () => unawaited(_closeConnections()),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _tunnels.init();
    });
  }

  Future<void> _closeConnections() => _shutdown ??= _shutdownConnections();

  Future<void> _shutdownConnections() async {
    await _tunnels.shutdown();
    _terminals.closeAll();
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    unawaited(_closeConnections());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _keyDialogs.navigatorKey,
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      localeListResolutionCallback: resolveAppLocale,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const MainLayout(),
    );
  }
}
