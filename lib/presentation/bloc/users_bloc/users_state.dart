part of 'users_bloc.dart';

// @immutable
// abstract class UsersState {
//   final List<User> users;
//   final User? user;

//   const UsersState({required this.users, required this.user});
// }

// class UsersInitial extends UsersState {
//   UsersInitial() : super(users: [], user: null);
// }

// class UsersLoadedState extends UsersState {
//   const UsersLoadedState({required List<User> users, required User? user})
//       : super(users: users, user: user);
// }

// class UsersPendingState extends UsersState {
//   const UsersPendingState({List<User> users = const [], User? user})
//       : super(users: users, user: user);
// }

// class UsersErrorState extends UsersState {
//   final String message;
//   const UsersErrorState(
//       {required List<User> users, required User? user, required this.message})
//       : super(users: users, user: user);
// }

// class FriendAddedState extends UsersState {
//   const FriendAddedState({required List<User> users, required User? user})
//       : super(users: users, user: user);
// }

// class FriendAddPending extends UsersState {
//   const FriendAddPending({required List<User> users, required User? user})
//       : super(users: users, user: user);
// }

// class ApprovePendingState extends UsersState {
//   final String friendId;

//   const ApprovePendingState(
//       {required this.friendId, required List<User> users, required User? user})
//       : super(users: users, user: user);
// }

@immutable
class UsersState {
  final List<User> users;
  final User? user;
  final String? message;
  final UserStatus status;
  final String? friendId;

  const UsersState({
    required this.status,
    required this.users,
    this.user,
    this.message,
    this.friendId,
  });

  const UsersState.initial()
      : status = UserStatus.initial,
        users = const [],
        user = null,
        message = null,
        friendId = null;

  UsersState copyWith({
    List<User>? users,
    User? user,
    String? message,
    UserStatus? status,
    String? friendId,
  }) {
    return UsersState(
      status: status ?? this.status,
      users: users ?? this.users,
      message: message ?? this.message,
      user: user ?? this.user,
      friendId: friendId ?? this.friendId,
    );
  }
}

enum UserStatus {
  initial,
  loaded,
  pending,
  error,
  friendAdded,
  friendAddPending,
  friendApprovePending
}
