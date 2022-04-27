part of 'users_bloc.dart';

@immutable
abstract class UsersState {
  final List<User>? users;
  final User? user;

  const UsersState({required this.users, required this.user});
}

class UsersInitial extends UsersState {
  UsersInitial() : super(users: [], user: null);
}

class UsersLoadedState extends UsersState {
  const UsersLoadedState({required List<User>? users, required User? user})
      : super(users: users, user: user);
}

class UsersPendingState extends UsersState {
  const UsersPendingState({List<User>? users = const [], User? user})
      : super(users: users, user: user);
}

class UsersErrorState extends UsersState {
  final String message;
  const UsersErrorState(
      {required List<User>? users, required User? user, required this.message})
      : super(users: users, user: user);
}

class FriendAddedState extends UsersState {
  const FriendAddedState({required List<User>? users, required User? user})
      : super(users: users, user: user);
}
