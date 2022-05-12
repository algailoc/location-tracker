import 'package:bloc/bloc.dart';
import 'package:firebase_tracker/domain/entites/user.dart';
import 'package:firebase_tracker/domain/usecases/users_usecases.dart';
import 'package:meta/meta.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final UsersUsecases usecases;

  List<User> users = [];
  User? user;

  UsersBloc({required this.usecases}) : super(UsersInitial()) {
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
          success = success.where((element) => element.id != user!.id).toList();
          // success = success.where((element) => !isUserFriend(element)).toList();
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
        final result = await usecases.approveFriend(event.friend);
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
      } else if (event is UpdateCoordinates) {
        final result = await usecases.updateCoordinates(event.lat, event.long);
        result.fold((error) {
          emit(UsersErrorState(
              users: users, user: user, message: error.message));
        }, (success) {
          user = success;
          emit(UsersLoadedState(users: users, user: user));
        });
      } else if (event is ClearState) {
        users = [];
        user = null;
        emit(UsersInitial());
      }
    });
  }
}
