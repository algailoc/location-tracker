import 'package:firebase_tracker/presentation/bloc/users_bloc/users_bloc.dart';
import 'package:firebase_tracker/presentation/widgets/main_screen/friends_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FriendsList extends StatelessWidget {
  const FriendsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: BlocBuilder<UsersBloc, UsersState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ваши друзья:',
                  style: TextStyle(fontSize: 20),
                ),
                if (state.users.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.user?.friends.length ?? 0,
                      shrinkWrap: true,
                      itemBuilder: ((context, index) => FriendsListItem(
                            friend: state.user!.friends[index],
                          )),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
