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

  UsersBloc({required this.usecases}) : super(const UsersState.initial()) {
    on<UsersEvent>((event, emit) async {
      if (event is GetUserData) {
        emit(state.copyWith(status: UserStatus.pending));
        final result = await usecases.getUser();
        result.fold((error) {
          emit(
              state.copyWith(message: error.message, status: UserStatus.error));
        }, (success) {
          user = success;
          emit(state.copyWith(user: user, status: UserStatus.loaded));
        });
      } else if (event is GetAllUsers) {
        emit(state.copyWith(status: UserStatus.pending));

        final result = await usecases.getAllUsers();
        result.fold((error) {
          emit(
              state.copyWith(message: error.message, status: UserStatus.error));
        }, (success) {
          success = success.where((element) => element.id != user!.id).toList();
          users = success;
          emit(state.copyWith(users: users, status: UserStatus.loaded));
        });
      } else if (event is AddFriend) {
        emit(state.copyWith(status: UserStatus.friendAddPending));
        final result = await usecases.addFriend(event.friendId);
        result.fold((error) {
          emit(
              state.copyWith(message: error.message, status: UserStatus.error));
        }, (success) {
          user = success;
          emit(state.copyWith(user: user, status: UserStatus.friendAdded));
        });
      } else if (event is ApproveFriend) {
        emit(state.copyWith(
            friendId: event.friend.id,
            status: UserStatus.friendApprovePending));
        final result = await usecases.approveFriend(event.friend);
        result.fold((error) {
          emit(
              state.copyWith(message: error.message, status: UserStatus.error));
        }, (success) {
          user = success;
          emit(state.copyWith(user: user, status: UserStatus.loaded));
        });
      } else if (event is DeleteFriend) {
        final result = await usecases.deleteFriend(event.friend);
        result.fold((error) {
          emit(
              state.copyWith(message: error.message, status: UserStatus.error));
        }, (success) {
          user = success;
          emit(state.copyWith(user: user, status: UserStatus.loaded));
        });
      } else if (event is UpdateCoordinates) {
        final result = await usecases.updateCoordinates(event.lat, event.long);
        result.fold((error) {
          emit(
              state.copyWith(message: error.message, status: UserStatus.error));
        }, (success) {
          user = success;
          emit(state.copyWith(user: user, status: UserStatus.loaded));
        });
      } else if (event is ClearState) {
        users = [];
        user = null;
        emit(
          state.copyWith(
            user: user,
            users: users,
            message: null,
            status: UserStatus.initial,
          ),
        );
      }
    });
  }
}
