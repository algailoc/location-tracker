import 'package:firebase_tracker/core/network/network_info.dart';
import 'package:firebase_tracker/data/datasources/local_datasource.dart';
import 'package:firebase_tracker/data/datasources/remote_datasource.dart';
import 'package:firebase_tracker/data/repostitories/app_settings_repository_impl.dart';
import 'package:firebase_tracker/data/repostitories/authorization_repository_impl.dart';
import 'package:firebase_tracker/data/repostitories/users_repository_impl.dart';
import 'package:firebase_tracker/domain/repositories/app_settings_repository.dart';
import 'package:firebase_tracker/domain/repositories/authorization_repository.dart';
import 'package:firebase_tracker/domain/repositories/users_repository.dart';
import 'package:firebase_tracker/domain/usecases/app_settings_usecases.dart';
import 'package:firebase_tracker/domain/usecases/authorization_usecases.dart';
import 'package:firebase_tracker/domain/usecases/users_usecases.dart';
import 'package:firebase_tracker/presentation/bloc/app_settings_bloc/app_settings_bloc.dart';
import 'package:firebase_tracker/presentation/bloc/authorization_bloc/authorization_bloc.dart';
import 'package:firebase_tracker/presentation/bloc/users_bloc/users_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Users Bloc
  sl.registerFactory(() => UsersBloc(usecases: sl()));
  sl.registerLazySingleton(() => UsersUsecases(repository: sl()));
  sl.registerLazySingleton<UsersRepository>(() => UsersRepositoryImpl(
        localDatasource: sl(),
        remoteDatasource: sl(),
        networkInfo: sl(),
      ));

  // Auth Bloc
  sl.registerFactory(() => AuthorizationBloc(sl()));
  sl.registerLazySingleton(() => AuthorizationUsecases(sl()));
  sl.registerLazySingleton<AuthorizationRepository>(
      () => AuthorizationRepositoryImpl(
            localDatasource: sl(),
            remoteDatasource: sl(),
            networkInfo: sl(),
          ));

  // App Settings Bloc
  sl.registerFactory(() => AppSettingsBloc(usecases: sl()));
  sl.registerLazySingleton(() => AppSettingsUsecases(repository: sl()));
  sl.registerLazySingleton<AppSettingsRepository>(
      () => AppSettingsRepositoryImpl(localDatasource: sl()));

  // Misc
  SharedPreferences preferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<LocalDatasource>(
      () => LocalDatasourceImpl(preferences));
  sl.registerLazySingleton<RemoteDatasource>(() => RemoteDatacourceImpl());
  sl.registerLazySingleton(() => NetworkInfo());
}
