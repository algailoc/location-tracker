import 'package:dartz/dartz.dart';
import 'package:firebase_tracker/domain/repositories/users_repository.dart';

import '../../core/errors/failures.dart';
import '../entites/user.dart';

class UsersUsecases {
  final UsersRepository repository;

  UsersUsecases({required this.repository});

  Future<Either<Failure, User>> getUser() async {
    return await repository.getUser();
  }

  Future<Either<Failure, List<User>>> getAllUsers() async {
    return await repository.getAllUsers();
  }

  Future<Either<Failure, User>> addFriend(String friendId) async {
    return await repository.addFriend(friendId);
  }

  Future<Either<Failure, User>> approveFriend(String friendId) async {
    return await repository.approveFriend(friendId);
  }

  Future<Either<Failure, User>> deleteFriend(Friend friend) async {
    return await repository.deleteFriend(friend);
  }

  Future<Either<Failure, User>> updateCoordinates(
      double lat, double long) async {
    return await repository.updateCoordinates(lat, long);
  }
}
