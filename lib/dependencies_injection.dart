import 'package:firebase_tracker/core/network/network_info.dart';
import 'package:firebase_tracker/data/datasources/local_datasource.dart';
import 'package:firebase_tracker/data/datasources/remote_datasource.dart';
import 'package:firebase_tracker/data/repostitories/users_repository_impl.dart';
import 'package:firebase_tracker/domain/repositories/users_repository.dart';
import 'package:firebase_tracker/domain/usecases/users_usecases.dart';
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

  // Misc
  SharedPreferences preferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<LocalDatasource>(
      () => LocalDatasourceImpl(preferences));
  sl.registerLazySingleton<RemoteDatasource>(() => RemoteDatacourceImpl());
  sl.registerLazySingleton(() => NetworkInfo());
}
