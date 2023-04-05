import 'package:dartz/dartz.dart';
import 'package:firebase_tracker/core/errors/failures.dart';

import '../entites/user.dart';

abstract class UsersRepository {
  /// Получает информацию о пользователе
  Future<Either<Failure, User>> getUser();

  /// Получает список всех зарегистрированных пользователй
  Future<Either<Failure, List<User>>> getAllUsers();

  /// Добавляет другого пользователя в друзья
  Future<Either<Failure, User>> addFriend(String friendId);

  /// Одобряет заявку на добавление в друзья
  Future<Either<Failure, User>> approveFriend(Friend friend);

  /// Удаляет другого пользователя из списка друзей
  Future<Either<Failure, User>> deleteFriend(Friend friend);

  /// Обновляет координаты пользователя
  Future<Either<Failure, User>> updateCoordinates(double lat, double long);
}
