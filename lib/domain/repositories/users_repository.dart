import 'package:dartz/dartz.dart';
import 'package:firebase_tracker/core/errors/failures.dart';

import '../entites/user.dart';

abstract class UsersRepository {
  Future<Either<Failure, User>> getUser();
  Future<Either<Failure, List<User>>> getAllUsers();
  Future<Either<Failure, User>> addFriend(String friendId);
}
