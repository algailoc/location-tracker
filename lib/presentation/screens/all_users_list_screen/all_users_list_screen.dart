import 'package:firebase_tracker/core/utils/show_custom_snackbar.dart';
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
  List<User> users = [];

  @override
  void initState() {
    BlocProvider.of<UsersBloc>(context).add(GetAllUsers());
    users =
        filterUsers(context, BlocProvider.of<UsersBloc>(context).state.users);
    super.initState();
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  void usersBlocListener(BuildContext context, UsersState state) {
    if (state.status == UserStatus.friendAdded) {
      Navigator.of(context).pop();
    } else if (state.status == UserStatus.error) {
      showCustomSnackBar(
        context,
        state.message ?? '',
        type: SnackBarType.error,
      );
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

  void onInputChanged(String q) {
    setState(() {
      users =
          filterUsers(context, BlocProvider.of<UsersBloc>(context).state.users);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UsersBloc, UsersState>(
      listener: usersBlocListener,
      builder: (context, state) {
        if (state.status == UserStatus.friendAddPending) {
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

        return Scaffold(
          appBar: const CustomAppBar(
            title: 'Tracker App',
            showBackButton: true,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
                  flexibleSpace: TextField(
                    controller: _queryController,
                    onChanged: onInputChanged,
                    decoration: const InputDecoration(hintText: 'Поиск'),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => UsersListItem(user: users[index]),
                    childCount: users.length,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
