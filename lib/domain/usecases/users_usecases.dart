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
}
