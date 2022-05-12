part of 'users_bloc.dart';

@immutable
abstract class UsersEvent {}

class GetUserData extends UsersEvent {}

class GetAllUsers extends UsersEvent {}

class AddFriend extends UsersEvent {
  final String friendId;

  AddFriend(this.friendId);
}

class ApproveFriend extends UsersEvent {
  final Friend friend;

  ApproveFriend(this.friend);
}

class DeleteFriend extends UsersEvent {
  final Friend friend;

  DeleteFriend(this.friend);
}

class UpdateCoordinates extends UsersEvent {
  final double lat, long;

  UpdateCoordinates(this.lat, this.long);
}

class ClearState extends UsersEvent {}
