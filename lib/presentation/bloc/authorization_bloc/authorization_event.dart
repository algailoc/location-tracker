part of 'authorization_bloc.dart';

@immutable
abstract class AuthorizationEvent {}

/// Checks if there is jwt in local storage.
/// If yes, then go to main screen and there in initState launch getUser.
/// If no, then go to authorization screen.
class CheckLocalUser extends AuthorizationEvent {}

/// Sign up user and create them, then get their data
class SignUpUser extends AuthorizationEvent {
  final String email, password;

  SignUpUser(this.email, this.password);
}

//Log in user and get their data
class LogInUser extends AuthorizationEvent {
  final String email, password;

  LogInUser(this.email, this.password);
}
