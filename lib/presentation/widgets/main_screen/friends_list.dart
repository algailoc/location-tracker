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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Ваши друзья:',
                      style: TextStyle(fontSize: 20),
                    ),
                    IconButton(
                      onPressed: () => BlocProvider.of<UsersBloc>(context)
                          .add(GetUserData()),
                      icon: state.status == UserStatus.pending
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(),
                            )
                          : const Icon(Icons.refresh),
                    )
                  ],
                ),
                if (state.users.isNotEmpty)
                  Expanded(
                    child: ListView.separated(
                      itemCount: state.user?.friends.length ?? 0,
                      shrinkWrap: true,
                      itemBuilder: ((context, index) => FriendsListItem(
                            friend: state.user!.friends[index],
                          )),
                      separatorBuilder: (context, index) => const Divider(),
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
