import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tracker/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_tracker/core/network/network_info.dart';
import 'package:firebase_tracker/core/utils/auth_error_handler.dart';
import 'package:firebase_tracker/data/datasources/local_datasource.dart';
import 'package:firebase_tracker/data/datasources/remote_datasource.dart';
import 'package:firebase_tracker/domain/repositories/authorization_repository.dart';
import 'package:flutter/material.dart';

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
    final result = localDatasource.getUserToken();
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
          final creationResult = await remoteDatasource.getUserUserToken(email);
          await localDatasource.setUserToken(creationResult);
          return const Right('success');
        } else {
          return Left(ServerFailure('Ошибка при авторизации'));
        }
      } catch (e) {
        debugPrint('Authorize User $e');
        String message =
            e is FirebaseAuthException ? mapErrorToMessage(e.code) : '';
        return Left(ServerFailure('Ошибка при авторизации: $message'));
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
          await localDatasource.setUserToken(creationResult);

          return const Right('success');
        } else {
          return Left(ServerFailure('Ошибка при авторизации'));
        }
      } catch (e) {
        debugPrint('Register User $e');
        String message =
            e is FirebaseAuthException ? mapErrorToMessage(e.code) : '';
        return Left(ServerFailure('Ошибка при авторизации: $message'));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, String>> signOut() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDatasource.signOut();
        await localDatasource.setUserToken('');
        return Right(result);
      } catch (e) {
        String message =
            e is FirebaseAuthException ? mapErrorToMessage(e.code) : '';
        return Left(ServerFailure('Ошибка при выходе: $message'));
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
