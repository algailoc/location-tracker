part of 'authorization_bloc.dart';

@immutable
abstract class AuthorizationState {}

class AuthorizationInitial extends AuthorizationState {}

class AuthorizationPending extends AuthorizationState {}

class AuthorizationError extends AuthorizationState {
  final String error;

  AuthorizationError(this.error);
}

class LocalUserChecked extends AuthorizationState {
  final bool localUserFound;

  LocalUserChecked(this.localUserFound);
}

class UserAuthorized extends AuthorizationState {}
