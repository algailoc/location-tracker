import 'package:bloc/bloc.dart';
import 'package:firebase_tracker/domain/usecases/authorization_usecases.dart';
import 'package:meta/meta.dart';

part 'authorization_event.dart';
part 'authorization_state.dart';

class AuthorizationBloc extends Bloc<AuthorizationEvent, AuthorizationState> {
  final AuthorizationUsecases usecases;

  AuthorizationBloc(this.usecases) : super(AuthorizationInitial()) {
    on<AuthorizationEvent>((event, emit) async {
      if (event is CheckLocalUser) {
        final result = await usecases.checkLocalUser();
        emit(LocalUserChecked(result));
      } else if (event is SignUpUser) {
        emit(AuthorizationPending());
        final result = await usecases.registerUser(event.email, event.password);
        result.fold((failure) async {
          emit(AuthorizationError(failure.message));
        }, (success) async {
          emit(UserAuthorized());
        });
      } else if (event is SignInUser) {
        emit(AuthorizationPending());
        final result =
            await usecases.authorizeUser(event.email, event.password);
        result.fold((failure) async {
          emit(AuthorizationError(failure.message));
        }, (success) async {
          emit(UserAuthorized(showTip: false));
        });
      } else if (event is SignOutUser) {
        emit(AuthorizationPending());
        final result = await usecases.signOut();
        result.fold((failure) async {
          emit(AuthorizationError(failure.message));
        }, (success) async {
          emit(AuthorizationInitial());
        });
      }
    });
  }
}
