import 'package:dartz/dartz.dart';
import 'package:firebase_tracker/core/errors/failures.dart';

import '../entites/user.dart';

abstract class UsersRepository {
  Future<Either<Failure, User>> getUser();
  Future<Either<Failure, List<User>>> getAllUsers();
  Future<Either<Failure, User>> addFriend(String friendId);
  Future<Either<Failure, User>> approveFriend(String friendId);
  Future<Either<Failure, User>> deleteFriend(String friendId);
  Future<Either<Failure, User>> updateCoordinates(double lat, double long);
}
