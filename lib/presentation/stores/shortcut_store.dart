import '../../l10n/system_localizations.dart';

import 'dart:async';

import 'package:signals_flutter/signals_flutter.dart';

import '../../domain/entities/command_result.dart';
import '../../domain/entities/shortcut_command.dart';
import '../../domain/entities/ssh_host.dart';
import '../../domain/repositories/shortcut_repository.dart';
import '../../domain/usecases/execute_shortcut_usecase.dart';

class ShortcutStore {
  final ShortcutRepository _shortcutRepository;
  final ExecuteShortcutUseCase _executeShortcutUseCase;

  StreamSubscription<List<ShortcutCommand>>? _shortcutsSubscription;
  StreamSubscription<List<CommandResult>>? _historySubscription;

  ShortcutStore(this._shortcutRepository, this._executeShortcutUseCase);

  final shortcuts = signal<List<ShortcutCommand>>([]);
  final runningShortcutIds = signal<Set<String>>({});
  final executionHistory = signal<List<CommandResult>>([]);
  final lastResult = signal<CommandResult?>(null);
  final isOutputModalVisible = signal<bool>(false);
  final categoryFilter = signal<String?>(null);

  late final categories = computed<List<String>>(() {
    final unique = shortcuts.value.map((s) => s.category).toSet().toList()
      ..sort();
    return unique;
  });

  late final filteredShortcuts = computed<List<ShortcutCommand>>(() {
    final filter = categoryFilter.value;
    if (filter == null) {
      return shortcuts.value;
    }
    return shortcuts.value.where((s) => s.category == filter).toList();
  });

  void init() {
    _shortcutsSubscription?.cancel();
    _shortcutsSubscription = _shortcutRepository.watchShortcuts().listen((
      list,
    ) {
      shortcuts.value = list;
    });

    _historySubscription?.cancel();
    _historySubscription = _shortcutRepository
        .watchExecutionHistory(limit: 50)
        .listen((list) {
          executionHistory.value = list;
        });
  }

  bool isShortcutRunning(String id) => runningShortcutIds.value.contains(id);

  Future<CommandResult?> execute(ShortcutCommand shortcut, SSHHost host) async {
    final updatedSet = Set<String>.from(runningShortcutIds.value)
      ..add(shortcut.id);
    runningShortcutIds.value = updatedSet;

    try {
      final result = await _executeShortcutUseCase.call(
        host: host,
        shortcut: shortcut,
      );
      lastResult.value = result;
      isOutputModalVisible.value = true;
      return result;
    } catch (e) {
      final errorResult = CommandResult(
        id: 'err_${DateTime.now().millisecondsSinceEpoch}',
        hostId: host.id,
        shortcutId: shortcut.id,
        command: shortcut.command,
        exitCode: 1,
        stdout: '',
        stderr: systemLocalizations.commandFailed(e.toString()),
        durationMs: 0,
        executedAt: DateTime.now(),
      );
      lastResult.value = errorResult;
      isOutputModalVisible.value = true;
      return errorResult;
    } finally {
      final finalSet = Set<String>.from(runningShortcutIds.value)
        ..remove(shortcut.id);
      runningShortcutIds.value = finalSet;
    }
  }

  Future<void> saveShortcut(ShortcutCommand shortcut) =>
      _shortcutRepository.saveShortcut(shortcut);

  Future<void> deleteShortcut(String id) =>
      _shortcutRepository.deleteShortcut(id);

  void closeOutputModal() {
    isOutputModalVisible.value = false;
  }

  void showResult(CommandResult result) {
    lastResult.value = result;
    isOutputModalVisible.value = true;
  }

  void dispose() {
    _shortcutsSubscription?.cancel();
    _historySubscription?.cancel();
  }
}
