import 'package:bloc/bloc.dart';
import 'package:firebase_tracker/domain/usecases/users_usecases.dart';
import 'package:meta/meta.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final UsersUsecases usecases;

  UsersBloc({required this.usecases}) : super(UsersInitial()) {
    on<UsersEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
