import 'package:get_it/get_it.dart';

import '../../data/datasources/local_database.dart';
import '../../data/datasources/secure_storage_datasource.dart';
import '../../data/datasources/ssh_remote_datasource.dart';
import '../../data/datasources/ssh_connection_factory.dart';
import '../../data/datasources/ssh_host_key_store.dart';
import '../../data/datasources/ssh_tunnel_datasource.dart';
import '../../data/repositories/host_repository_impl.dart';
import '../../data/repositories/shortcut_repository_impl.dart';
import '../../data/repositories/ssh_repository_impl.dart';
import '../../data/repositories/tunnel_repository_impl.dart';
import '../../domain/entities/ssh_host_key.dart';
import '../../domain/repositories/host_repository.dart';
import '../../domain/repositories/tunnel_repository.dart';
import '../../domain/repositories/shortcut_repository.dart';
import '../../domain/repositories/ssh_repository.dart';
import '../../domain/usecases/execute_shortcut_usecase.dart';
import '../../domain/usecases/manage_hosts_usecase.dart';
import '../../domain/usecases/open_ssh_session_usecase.dart';
import '../../presentation/stores/host_store.dart';
import '../../presentation/stores/shortcut_store.dart';
import '../../presentation/stores/terminal_session_store.dart';

import '../../presentation/stores/tunnel_store.dart';
import '../../presentation/widgets/ssh_host_key_dialogs.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // DataSources
  sl.registerLazySingleton<AppDatabase>(() => AppDatabase());
  sl.registerLazySingleton<SecureStorageDatasource>(
    () => SecureStorageDatasource(),
  );
  sl.registerLazySingleton<SSHHostKeyDialogs>(SSHHostKeyDialogs.new);
  sl.registerLazySingleton<SSHHostKeyConfirmation>(
    () => sl<SSHHostKeyDialogs>(),
  );
  sl.registerLazySingleton<SSHHostKeyStore>(
    () => SSHHostKeyStore(sl<AppDatabase>()),
  );
  sl.registerLazySingleton<SSHConnectionFactory>(
    () => SSHConnectionFactory(
      sl<HostRepository>(),
      sl<SSHHostKeyStore>(),
      sl<SSHHostKeyConfirmation>(),
    ),
  );
  sl.registerLazySingleton<SSHRemoteDatasource>(
    () => SSHRemoteDatasource(sl<SSHConnectionFactory>()),
  );
  sl.registerLazySingleton<SSHTunnelDatasource>(
    () => SSHTunnelDatasource(sl<HostRepository>(), sl<SSHConnectionFactory>()),
  );

  // Repositories
  sl.registerLazySingleton<HostRepository>(
    () => HostRepositoryImpl(sl<AppDatabase>(), sl<SecureStorageDatasource>()),
  );
  sl.registerLazySingleton<ShortcutRepository>(
    () => ShortcutRepositoryImpl(sl<AppDatabase>()),
  );
  sl.registerLazySingleton<SSHRepository>(
    () => SSHRepositoryImpl(sl<SSHRemoteDatasource>()),
  );

  sl.registerLazySingleton<TunnelRepository>(
    () => TunnelRepositoryImpl(sl<AppDatabase>(), sl<SSHTunnelDatasource>()),
  );

  // Use Cases
  sl.registerLazySingleton<ManageHostsUseCase>(
    () => ManageHostsUseCase(sl<HostRepository>(), sl<SSHRepository>()),
  );
  sl.registerLazySingleton<ExecuteShortcutUseCase>(
    () => ExecuteShortcutUseCase(sl<ShortcutRepository>(), sl<SSHRepository>()),
  );
  sl.registerLazySingleton<OpenSSHSessionUseCase>(
    () => OpenSSHSessionUseCase(sl<SSHRepository>()),
  );

  // Stores
  sl.registerLazySingleton<TunnelStore>(
    () => TunnelStore(sl<TunnelRepository>()),
  );
  sl.registerLazySingleton<HostStore>(
    () => HostStore(sl<ManageHostsUseCase>())..init(),
  );
  sl.registerLazySingleton<ShortcutStore>(
    () =>
        ShortcutStore(sl<ShortcutRepository>(), sl<ExecuteShortcutUseCase>())
          ..init(),
  );
  sl.registerLazySingleton<TerminalSessionStore>(
    () => TerminalSessionStore(sl<OpenSSHSessionUseCase>()),
  );
}
