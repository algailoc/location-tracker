import 'package:bloc/bloc.dart';
import 'package:firebase_tracker/domain/entites/user.dart';
import 'package:firebase_tracker/domain/usecases/users_usecases.dart';
import 'package:meta/meta.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final UsersUsecases usecases;

  List<User> users = [];
  late User user;

  UsersBloc({required this.usecases}) : super(UsersInitial()) {
    bool isUserFriend(User element) {
      final tempFriends = user.friends.where((el) => el.id == element.id);
      return tempFriends.isNotEmpty;
    }

    on<UsersEvent>((event, emit) async {
      if (event is GetUserData) {
        final result = await usecases.getUser();
        result.fold((error) {
          emit(UsersErrorState(
              users: users, user: user, message: error.message));
        }, (success) {
          user = success;
          emit(UsersLoadedState(users: users, user: user));
        });
      } else if (event is GetAllUsers) {
        final result = await usecases.getAllUsers();
        result.fold((error) {
          emit(UsersErrorState(
              users: users, user: user, message: error.message));
        }, (success) {
          success = success.where((element) => element.id != user.id).toList();
          success = success.where((element) => !isUserFriend(element)).toList();
          users = success;
          emit(UsersLoadedState(users: users, user: user));
        });
      } else if (event is AddFriend) {
        final result = await usecases.addFriend(event.friendId);
        result.fold((error) {
          emit(UsersErrorState(
              users: users, user: user, message: error.message));
        }, (success) {
          user = success;
          emit(FriendAddedState(users: users, user: user));
        });
      } else if (event is ApproveFriend) {
        final result = await usecases.approveFriend(event.friendId);
        result.fold((error) {
          emit(UsersErrorState(
              users: users, user: user, message: error.message));
        }, (success) {
          user = success;
          emit(UsersLoadedState(users: users, user: user));
        });
      } else if (event is DeleteFriend) {
        final result = await usecases.deleteFriend(event.friend);
        result.fold((error) {
          emit(UsersErrorState(
              users: users, user: user, message: error.message));
        }, (success) {
          user = success;
          emit(UsersLoadedState(users: users, user: user));
        });
      }
    });
  }
}
