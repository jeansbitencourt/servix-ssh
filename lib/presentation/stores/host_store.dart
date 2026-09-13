import 'dart:async';
import 'package:signals_flutter/signals_flutter.dart';
import '../../domain/entities/ssh_host.dart';
import '../../domain/usecases/manage_hosts_usecase.dart';

class HostStore {
  final ManageHostsUseCase _manageHostsUseCase;
  StreamSubscription<List<SSHHost>>? _hostsSubscription;

  HostStore(this._manageHostsUseCase);

  final hosts = signal<List<SSHHost>>([]);
  final selectedHost = signal<SSHHost?>(null);
  final isLoading = signal<bool>(false);
  final isTestingConnection = signal<bool>(false);
  final connectionTestResult = signal<String?>(null);
  final isConnectionSuccess = signal<bool?>(null);

  final searchQuery = signal<String>('');
  final selectedGroup = signal<String>('Todos');

  late final groups = computed<List<String>>(() {
    final uniqueGroups = hosts.value.map((h) => h.groupName).toSet().toList()..sort();
    return ['Todos', ...uniqueGroups];
  });

  late final filteredHosts = computed<List<SSHHost>>(() {
    final query = searchQuery.value.trim().toLowerCase();
    final group = selectedGroup.value;

    return hosts.value.where((h) {
      final matchesQuery = query.isEmpty ||
          h.name.toLowerCase().contains(query) ||
          h.host.toLowerCase().contains(query) ||
          h.username.toLowerCase().contains(query);
      final matchesGroup = group == 'Todos' || h.groupName == group;

      return matchesQuery && matchesGroup;
    }).toList();
  });

  void init() {
    isLoading.value = true;
    _hostsSubscription?.cancel();
    _hostsSubscription = _manageHostsUseCase.watchAllHosts().listen((list) {
      hosts.value = list;
      isLoading.value = false;

      if (selectedHost.value != null) {
        // Keep selection updated
        final updated = list.where((h) => h.id == selectedHost.value!.id).firstOrNull;
        selectedHost.value = updated;
      } else if (list.isNotEmpty) {
        selectedHost.value = list.first;
      }
    });
  }

  void selectHost(SSHHost? host) {
    selectedHost.value = host;
    connectionTestResult.value = null;
    isConnectionSuccess.value = null;
  }

  Future<void> saveHost(SSHHost host, {String? password, String? passphrase}) async {
    isLoading.value = true;
    try {
      await _manageHostsUseCase.saveHost(host, password: password, passphrase: passphrase);
      selectedHost.value = host;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteHost(String id) async {
    isLoading.value = true;
    try {
      await _manageHostsUseCase.deleteHost(id);
      if (selectedHost.value?.id == id) {
        selectedHost.value = hosts.value.where((h) => h.id != id).firstOrNull;
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> testConnection(SSHHost host, {String? password, String? passphrase}) async {
    isTestingConnection.value = true;
    connectionTestResult.value = null;
    isConnectionSuccess.value = null;

    try {
      final ok = await _manageHostsUseCase.testConnection(
        host,
        password: password,
        passphrase: passphrase,
      );
      isConnectionSuccess.value = ok;
      connectionTestResult.value = ok ? 'Conexão estabelecida com sucesso!' : 'Falha na conexão SSH';
      return ok;
    } catch (e) {
      isConnectionSuccess.value = false;
      connectionTestResult.value = 'Erro: $e';
      return false;
    } finally {
      isTestingConnection.value = false;
    }
  }

  void dispose() {
    _hostsSubscription?.cancel();
  }
}
