import 'package:firebase_tracker/presentation/bloc/users_bloc/users_bloc.dart';
import 'package:firebase_tracker/presentation/widgets/all_users_list_screen/all_users_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entites/user.dart';
import '../../widgets/general/custom_app_bar.dart';

class AllUsersListScreen extends StatelessWidget {
  const AllUsersListScreen({Key? key}) : super(key: key);

  void usersBlocListener(BuildContext context, UsersState state) {
    if (state is FriendAddedState) {
      Navigator.of(context).pop();
    }
  }

  List<User> filterUsers(BuildContext context, List<User> list) {
    bool isUserFriend(User element) {
      User user = BlocProvider.of<UsersBloc>(context).user;
      if (user != null) {
        final tempFriends = user.friends.where((el) => el.id == element.id);
        return tempFriends.isNotEmpty;
      }
      return false;
    }

    list = list.where((element) => !isUserFriend(element)).toList();

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UsersBloc, UsersState>(
      listener: usersBlocListener,
      builder: (context, state) {
        final List<User> list = filterUsers(context, state.users);
        return Scaffold(
          appBar: const CustomAppBar(title: 'Tracker App'),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: ListView.builder(
              itemBuilder: (context, index) {
                return UsersListItem(user: list[index]);
              },
              shrinkWrap: true,
              itemCount: list.length,
            ),
          ),
        );
      },
    );
  }
}
