part of 'users_bloc.dart';

@immutable
abstract class UsersEvent {}

class GetUserData extends UsersEvent {}

class GetAllUsers extends UsersEvent {}

class AddFriend extends UsersEvent {
  final String friendId;

  AddFriend(this.friendId);
}
