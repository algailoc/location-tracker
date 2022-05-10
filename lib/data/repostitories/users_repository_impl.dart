import 'package:firebase_tracker/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_tracker/core/network/network_info.dart';
import 'package:firebase_tracker/data/datasources/local_datasource.dart';
import 'package:firebase_tracker/data/datasources/remote_datasource.dart';
import 'package:firebase_tracker/domain/entites/user.dart';
import 'package:firebase_tracker/domain/repositories/users_repository.dart';

class UsersRepositoryImpl extends UsersRepository {
  final LocalDatasource localDatasource;
  final RemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;

  UsersRepositoryImpl(
      {required this.localDatasource,
      required this.remoteDatasource,
      required this.networkInfo});

  @override
  Future<Either<Failure, User>> addFriend(String friendId) async {
    if (await networkInfo.isConnected) {
      try {
        final String userToken = localDatasource.getUserToken();
        final response = await remoteDatasource.addFriend(userToken, friendId);
        return Right(response);
      } catch (e) {
        print('Add Friend $e');
        return Left(ServerFailure('Ошибка при добавлении пользователя'));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<User>>> getAllUsers() async {
    if (await networkInfo.isConnected) {
      try {
        final String userToken = localDatasource.getUserToken();
        final response = await remoteDatasource.getAllUsers(userToken);
        return Right(response);
      } catch (e) {
        print('Get All Users $e');
        return Left(ServerFailure('Ошибка при получении данных'));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, User>> getUser() async {
    if (await networkInfo.isConnected) {
      try {
        final String userToken = localDatasource.getUserToken();
        final response = await remoteDatasource.getUser(userToken);
        return Right(response);
      } catch (e) {
        print('Get User $e');
        return Left(ServerFailure('Ошибка при получении данных'));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, User>> approveFriend(Friend friend) async {
    if (await networkInfo.isConnected) {
      try {
        final String userToken = localDatasource.getUserToken();
        final response =
            await remoteDatasource.approveFriend(userToken, friend);
        return Right(response);
      } catch (e) {
        print('Approve Friend $e');
        return Left(ServerFailure('Ошибка при получении данных'));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, User>> deleteFriend(Friend friend) async {
    if (await networkInfo.isConnected) {
      try {
        final String userToken = localDatasource.getUserToken();
        final response = await remoteDatasource.deleteFriend(userToken, friend);
        return Right(response);
      } catch (e) {
        print('Delete Friend $e');
        return Left(ServerFailure('Ошибка при удалении пользователя'));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, User>> updateCoordinates(
      double lat, double long) async {
    if (await networkInfo.isConnected) {
      try {
        final String userToken = localDatasource.getUserToken();
        final response =
            await remoteDatasource.updateCoordinates(userToken, lat, long);
        return Right(response);
      } catch (e) {
        print('Update coordinates $e');
        return Left(ServerFailure('Ошибка при обновлении данных'));
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
