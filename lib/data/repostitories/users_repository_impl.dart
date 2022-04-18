import 'package:firebase_tracker/core/network/network_info.dart';
import 'package:firebase_tracker/data/datasources/local_datasource.dart';
import 'package:firebase_tracker/data/datasources/remote_datasource.dart';
import 'package:firebase_tracker/domain/repositories/users_repository.dart';

class UsersRepositoryImpl extends UsersRepository {
  final LocalDatasource localDatasource;
  final RemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;

  UsersRepositoryImpl(
      {required this.localDatasource,
      required this.remoteDatasource,
      required this.networkInfo});
}
