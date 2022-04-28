import 'package:firebase_tracker/domain/entites/user.dart';
import 'package:firebase_tracker/presentation/bloc/users_bloc/users_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FriendsList extends StatelessWidget {
  const FriendsList({Key? key}) : super(key: key);

  Future<bool> showConfirmationModal(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text(
                    'Вы уверены, что хотите удалить этого пользователя?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text(
                          'Удалить',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text(
                          'Отмена',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return result != null && result;
  }

  void deleteFriend(BuildContext context, Friend friend) async {
    BlocProvider.of<UsersBloc>(context).add(DeleteFriend(friend));
  }

  void approveFriend(BuildContext context, Friend friend) {
    BlocProvider.of<UsersBloc>(context).add(ApproveFriend(friend));
  }

  void showFriendOnMap(BuildContext context, User friend) {}

  User getFriend(BuildContext context, String id) {
    List<User> list = BlocProvider.of<UsersBloc>(context).users;
    list = list.where((element) => element.id == id).toList();
    return list.first;
  }

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
                if (state.users != null && state.users!.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.user?.friends.length ?? 0,
                      shrinkWrap: true,
                      itemBuilder: ((context, index) => Dismissible(
                            onDismissed: (_) => deleteFriend(
                                context, state.user!.friends[index]),
                            confirmDismiss: (_) =>
                                showConfirmationModal(context),
                            secondaryBackground: Container(
                              color: Colors.red,
                            ),
                            background: Container(
                              color: Colors.transparent,
                            ),
                            key: UniqueKey(),
                            direction: DismissDirection.endToStart,
                            child: Card(
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      getFriend(context,
                                              state.user!.friends[index].id)
                                          .email,
                                      // state.user!.friends[index].id,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    if (!state.user!.friends[index].approved &&
                                        !state.user!.friends[index].initializer)
                                      IconButton(
                                          tooltip: 'Одобрить',
                                          onPressed: () => approveFriend(
                                              context,
                                              state.user!.friends[index]),
                                          icon: const Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                          )),
                                    if (!state.user!.friends[index]
                                        .approved) //TODO: remove !
                                      IconButton(
                                          tooltip: 'Координаты',
                                          onPressed: () => showFriendOnMap(
                                              context,
                                              getFriend(
                                                  context,
                                                  state.user!.friends[index]
                                                      .id)),
                                          icon: const Icon(Icons.map)),
                                  ],
                                ),
                              ),
                            ),
                          )),
                    ),
                  )
              ],
            );
          },
        ),
      ),
    );
  }
}
