import 'package:firebase_tracker/presentation/bloc/users_bloc/users_bloc.dart';
import 'package:firebase_tracker/presentation/widgets/all_users_list_screen/all_users_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entites/user.dart';
import '../../widgets/general/custom_app_bar.dart';

class AllUsersListScreen extends StatefulWidget {
  const AllUsersListScreen({Key? key}) : super(key: key);

  @override
  State<AllUsersListScreen> createState() => _AllUsersListScreenState();
}

class _AllUsersListScreenState extends State<AllUsersListScreen> {
  final _queryController = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<UsersBloc>(context).add(GetAllUsers());
    super.initState();
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  void usersBlocListener(BuildContext context, UsersState state) {
    if (state is FriendAddedState) {
      Navigator.of(context).pop();
    }
  }

  List<User> filterUsers(BuildContext context, List<User> list) {
    bool isUserFriend(User element) {
      User? user = BlocProvider.of<UsersBloc>(context).user;
      if (user != null) {
        final tempFriends = user.friends.where((el) => el.id == element.id);
        return tempFriends.isNotEmpty;
      }
      return false;
    }

    final query = _queryController.text.trim();

    if (query.isEmpty) {
      list = list.where((element) => !isUserFriend(element)).toList();
    } else {
      list = list
          .where((element) =>
              !isUserFriend(element) && element.email.contains(query))
          .toList();
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UsersBloc, UsersState>(
      listener: usersBlocListener,
      builder: (context, state) {
        if (state is FriendAddPending) {
          return const Scaffold(
            appBar: CustomAppBar(
              title: 'Tracker App',
              showBackButton: false,
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final List<User> list = filterUsers(context, state.users);
        return Scaffold(
          appBar: const CustomAppBar(
            title: 'Tracker App',
            showBackButton: true,
          ),
          body: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return UsersListItem(user: list[index]);
                  },
                  shrinkWrap: true,
                  itemCount: list.length,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
