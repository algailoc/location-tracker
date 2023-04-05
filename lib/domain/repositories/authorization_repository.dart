import 'package:dartz/dartz.dart';
import 'package:firebase_tracker/core/errors/failures.dart';

abstract class AuthorizationRepository {
  /// Проверяет, зарегистрирован ли пользователь
  Future<bool> checkLocalUser();

  /// Регистрирует пользователя
  Future<Either<Failure, String>> registerUser(String email, String password);

  /// Авторизует пользователя по почте и паролю
  Future<Either<Failure, String>> authorizeUser(String email, String password);

  /// Выходит из аккаунта
  Future<Either<Failure, String>> signOut();
}
