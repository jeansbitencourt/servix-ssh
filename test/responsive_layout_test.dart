import 'package:servix/core/di/injection.dart';
import 'package:servix/core/theme/app_brand.dart';
import 'package:servix/core/theme/app_theme.dart';
import 'package:servix/core/theme/terminal_theme.dart';
import 'package:servix/data/datasources/local_database.dart';
import 'package:servix/data/datasources/secure_storage_datasource.dart';
import 'package:servix/data/datasources/ssh_remote_datasource.dart';
import 'package:servix/data/repositories/host_repository_impl.dart';
import 'package:servix/data/repositories/shortcut_repository_impl.dart';
import 'package:servix/data/repositories/ssh_repository_impl.dart';
import 'package:servix/domain/entities/command_result.dart';
import 'package:servix/domain/entities/shortcut_command.dart';
import 'package:servix/domain/entities/ssh_host.dart';
import 'package:servix/domain/entities/terminal_session.dart';
import 'package:servix/domain/usecases/execute_shortcut_usecase.dart';
import 'package:servix/domain/usecases/manage_hosts_usecase.dart';
import 'package:servix/domain/usecases/open_ssh_session_usecase.dart';
import 'package:servix/presentation/stores/host_store.dart';
import 'package:servix/presentation/stores/shortcut_store.dart';
import 'package:servix/presentation/stores/terminal_session_store.dart';
import 'package:servix/main.dart';
import 'package:servix/l10n/app_localizations.dart';
import 'package:servix/presentation/widgets/terminal_tab_view.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xterm/xterm.dart';

void main() {
  testWidgets('Main views and dialogs fit narrow windows with populated data', (
    tester,
  ) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    addTearDown(sl.reset);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    final hostRepository = HostRepositoryImpl(db, SecureStorageDatasource());
    final shortcutRepository = ShortcutRepositoryImpl(db);
    final sshRepository = SSHRepositoryImpl(SSHRemoteDatasource());
    final hosts = HostStore(ManageHostsUseCase(hostRepository, sshRepository));
    final shortcuts = ShortcutStore(
      shortcutRepository,
      ExecuteShortcutUseCase(hostRepository, shortcutRepository, sshRepository),
    );
    final terminals = TerminalSessionStore(
      OpenSSHSessionUseCase(hostRepository, sshRepository),
    );
    sl.registerSingleton(hosts);
    sl.registerSingleton(shortcuts);
    sl.registerSingleton(terminals);

    final date = DateTime(2026);
    final host = SSHHost(
      id: 'server',
      name: 'Servidor com um nome extenso para teste de layout',
      host: 'server-with-a-very-long-hostname.example.com',
      port: 22,
      username: 'operador',
      authType: SSHAuthType.password,
      groupName: 'Grupo com nome extenso para testar espaços estreitos',
      createdAt: date,
      updatedAt: date,
    );
    final shortcut = ShortcutCommand(
      id: 'shortcut',
      name: 'Verificar disponibilidade',
      command: 'printf "Servidor disponível"',
      category: 'Categoria com nome extenso para teste de layout',
      workingDirectory: '/home/operador/diretorio-de-trabalho',
      timeoutSeconds: 30,
      createdAt: date,
    );
    final result = CommandResult(
      id: 'result',
      hostId: host.id,
      shortcutId: shortcut.id,
      command: shortcut.command,
      stdout: 'Servidor disponível',
      stderr: '',
      exitCode: 0,
      durationMs: 50,
      executedAt: date,
    );
    hosts.hosts.value = [host];
    hosts.selectHost(host);
    shortcuts.shortcuts.value = [shortcut];
    shortcuts.executionHistory.value = [result];

    final dispatcher = tester.binding.platformDispatcher;
    dispatcher.localesTestValue = const [Locale('pt', 'BR')];
    addTearDown(dispatcher.clearLocalesTestValue);

    tester.view.physicalSize = const Size(950, 540);
    await tester.pumpWidget(const ServixApp());
    await tester.pumpAndSettle();
    expect(find.text('Novo Servidor'), findsOneWidget);
    expect(find.byTooltip('Servix — Central de Operações SSH'), findsOneWidget);

    tester.view.physicalSize = const Size(360, 480);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Novo Servidor'));
    await tester.pumpAndSettle();
    expect(find.text('Cadastrar Servidor'), findsWidgets);
    Navigator.of(tester.element(find.byType(Dialog))).pop();
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Servidores (1)'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(host.name).hitTestable());
    await tester.pumpAndSettle();
    expect(find.text('Voltar à lista'), findsOneWidget);
    await tester.tap(find.text('Voltar à lista'));
    await tester.pumpAndSettle();
    expect(find.text('Cadastrar Novo Servidor'), findsOneWidget);

    await tester.tap(find.byTooltip('Atalhos'));
    await tester.pumpAndSettle();
    expect(find.text(shortcut.name), findsOneWidget);

    await tester.tap(find.text('Novo Atalho'));
    await tester.pumpAndSettle();
    expect(find.byType(Dialog), findsOneWidget);
    Navigator.of(tester.element(find.byType(Dialog))).pop();
    await tester.pumpAndSettle();

    shortcuts.showResult(result);
    await tester.pumpAndSettle();
    expect(find.text('Executar Novamente'), findsOneWidget);

    tester.view.physicalSize = const Size(1280, 720);
    await tester.pumpAndSettle();
    expect(find.text(AppBrand.name), findsOneWidget);
    expect(find.text('Central de Operações SSH'), findsOneWidget);
    expect(find.text('Executar Novamente'), findsOneWidget);

    dispatcher.localesTestValue = const [Locale('en', 'GB')];
    await tester.pumpAndSettle();
    expect(find.text('SSH Operations Center'), findsOneWidget);
    expect(find.text('Run Again'), findsOneWidget);

    dispatcher.localesTestValue = const [Locale('pt', 'BR')];
    await tester.pumpAndSettle();
    expect(find.text('Executar Novamente'), findsOneWidget);

    dispatcher.localesTestValue = const [Locale('fr', 'BR')];
    await tester.pumpAndSettle();
    expect(find.text('SSH Operations Center'), findsOneWidget);
    expect(find.text('Run Again'), findsOneWidget);
  });

  testWidgets(
    'Terminal uses fixed-width cells and adjusts to window resizing',
    (tester) async {
      final font = FontLoader(AppTerminalTheme.fontFamily)
        ..addFont(rootBundle.load('assets/fonts/LiberationMono-Regular.ttf'));
      await font.load();
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);

      final date = DateTime(2026);
      final host = SSHHost(
        id: 'host',
        name: 'Servidor',
        host: 'server-with-a-very-long-hostname.example.com',
        port: 22,
        username: 'operador',
        authType: SSHAuthType.password,
        groupName: 'Teste',
        createdAt: date,
        updatedAt: date,
      );
      final terminal = Terminal();
      terminal.write('iiii mmmm\r\n0123456789\r\n');

      tester.view.physicalSize = const Size(894, 540);
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('pt', 'BR'),
          home: Scaffold(
            body: TerminalTabView(
              session: TerminalSession(
                id: 'ssh',
                host: host,
                terminal: terminal,
                title: host.name,
                createdAt: date,
                status: TerminalSessionStatus.connected,
              ),
              isActive: true,
              onReconnect: () {},
              onClose: () {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final terminalView = find.byType(TerminalView);
      final view = tester.widget<TerminalView>(terminalView);
      final originalColumns = terminal.viewWidth;
      expect(view.textStyle.fontFamily, AppTerminalTheme.fontFamily);
      expect(originalColumns, greaterThanOrEqualTo(80));
      expect(view.focusNode!.hasFocus, isTrue);

      tester.view.physicalSize = const Size(304, 420);
      await tester.pumpAndSettle();
      expect(terminal.viewWidth, lessThan(originalColumns));
      expect(find.byTooltip('Ações do terminal'), findsOneWidget);

      final narrowColumns = terminal.viewWidth;
      await tester.tap(find.byTooltip('Aumentar Fonte'));
      await tester.pumpAndSettle();
      expect(tester.widget<TerminalView>(terminalView).textStyle.fontSize, 15);
      expect(terminal.viewWidth, lessThan(narrowColumns));
      expect(view.focusNode!.hasFocus, isTrue);
    },
  );
}
