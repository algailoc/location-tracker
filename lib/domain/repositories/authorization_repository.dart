import 'package:dartz/dartz.dart';
import 'package:firebase_tracker/core/errors/failures.dart';

abstract class AuthorizationRepository {
  Future<bool> checkLocalUser();
  Future<Either<Failure, String>> registerUser(String email, String password);
  Future<Either<Failure, String>> authorizeUser(String email, String password);
  Future<Either<Failure, String>> signOut();
}
