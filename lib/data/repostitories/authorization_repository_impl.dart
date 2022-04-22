import 'package:firebase_tracker/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_tracker/core/network/network_info.dart';
import 'package:firebase_tracker/data/datasources/local_datasource.dart';
import 'package:firebase_tracker/data/datasources/remote_datasource.dart';
import 'package:firebase_tracker/domain/repositories/authorization_repository.dart';

class AuthorizationRepositoryImpl extends AuthorizationRepository {
  final LocalDatasource localDatasource;
  final RemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;

  AuthorizationRepositoryImpl(
      {required this.localDatasource,
      required this.remoteDatasource,
      required this.networkInfo});

  @override
  Future<bool> checkLocalUser() async {
    final result = localDatasource.getJwt();
    return result.isNotEmpty;
  }

  @override
  Future<Either<Failure, String>> authorizeUser(
      String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        final authResult =
            await remoteDatasource.authorizeUser(email, password);
        if (authResult == 'success') {
          final creationResult = await remoteDatasource.getUserJwt(email);
          await localDatasource.setJwt(creationResult);
          return const Right('success');
        } else {
          return Left(ServerFailure('Ошибка при авторизации'));
        }
      } catch (e) {
        print('Authorize User $e');
        return Left(ServerFailure('Ошибка при авторизации'));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, String>> registerUser(
      String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        final regResult = await remoteDatasource.registerUser(email, password);
        if (regResult == 'success') {
          final creationResult = await remoteDatasource.createUser(email);
          await localDatasource.setJwt(creationResult);
          return const Right('success');
        } else {
          return Left(ServerFailure('Ошибка при авторизации'));
        }
      } catch (e) {
        print('Register User $e');
        return Left(ServerFailure('Ошибка при авторизации'));
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
