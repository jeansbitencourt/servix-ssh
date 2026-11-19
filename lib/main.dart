import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sqlite3/open.dart';
import 'package:uuid/uuid.dart';
import 'core/di/injection.dart';
import 'core/theme/app_brand.dart';
import 'core/theme/app_theme.dart';
import 'domain/entities/shortcut_command.dart';
import 'domain/repositories/shortcut_repository.dart';
import 'presentation/views/main_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Linux SQLite dynamic library resolution fallback
  if (Platform.isLinux) {
    open.overrideFor(OperatingSystem.linux, () {
      try {
        return DynamicLibrary.open('libsqlite3.so');
      } catch (_) {
        return DynamicLibrary.open('libsqlite3.so.0');
      }
    });
  }

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
    const uuid = Uuid();
    final defaultShortcuts = [
      ShortcutCommand(
        id: uuid.v4(),
        name: 'Uptime & Carga do Sistema',
        command: 'uptime && cat /proc/loadavg',
        category: 'Sistema',
        timeoutSeconds: 15,
        createdAt: DateTime.now(),
      ),
      ShortcutCommand(
        id: uuid.v4(),
        name: 'Uso de Memória RAM',
        command: 'free -h',
        category: 'Sistema',
        timeoutSeconds: 15,
        createdAt: DateTime.now(),
      ),
      ShortcutCommand(
        id: uuid.v4(),
        name: 'Espaço em Disco',
        command: 'df -h -x tmpfs -x devtmpfs',
        category: 'Sistema',
        timeoutSeconds: 15,
        createdAt: DateTime.now(),
      ),
      ShortcutCommand(
        id: uuid.v4(),
        name: 'Docker Containers Ativos',
        command: 'docker ps --format "table {{.ID}}\\t{{.Image}}\\t{{.Status}}\\t{{.Names}}"',
        category: 'Docker',
        timeoutSeconds: 20,
        createdAt: DateTime.now(),
      ),
      ShortcutCommand(
        id: uuid.v4(),
        name: 'Últimas 50 Linhas do Syslog',
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

class ServixApp extends StatelessWidget {
  const ServixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppBrand.title,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const MainLayout(),
    );
  }
}
