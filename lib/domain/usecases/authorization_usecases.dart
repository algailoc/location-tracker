import 'package:dartz/dartz.dart';
import 'package:firebase_tracker/domain/repositories/authorization_repository.dart';

import '../../core/errors/failures.dart';

class AuthorizationUsecases {
  final AuthorizationRepository repository;

  AuthorizationUsecases(this.repository);

  Future<Either<Failure, String>> registerUser(
      String email, String password) async {
    return await repository.registerUser(email, password);
  }

  Future<Either<Failure, String>> authorizeUser(
      String email, String password) async {
    return await repository.authorizeUser(email, password);
  }

  Future<bool> checkLocalUser() async {
    return await repository.checkLocalUser();
  }
}
