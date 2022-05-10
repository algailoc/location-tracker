import 'package:firebase_tracker/presentation/bloc/users_bloc/users_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entites/user.dart';

class UsersListItem extends StatelessWidget {
  final User user;

  const UsersListItem({required this.user, Key? key}) : super(key: key);

  void onUserPressed(BuildContext context) {
    BlocProvider.of<UsersBloc>(context).add(AddFriend(user.id));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onUserPressed(context),
      child: Card(
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            child: Text(
              user.email,
              style: const TextStyle(fontSize: 18),
            )),
      ),
    );
  }
}
