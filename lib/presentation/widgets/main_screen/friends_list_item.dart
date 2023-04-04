import 'package:firebase_tracker/core/utils/show_custom_snackbar.dart';
import 'package:firebase_tracker/domain/entites/user.dart';
import 'package:firebase_tracker/presentation/screens/map_screen.dart/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import '../../bloc/users_bloc/users_bloc.dart';

class FriendsListItem extends StatelessWidget {
  final Friend friend;
  const FriendsListItem({required this.friend, Key? key}) : super(key: key);

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

  void deleteFriend(BuildContext context) async {
    BlocProvider.of<UsersBloc>(context).add(DeleteFriend(friend));
  }

  void approveFriend(BuildContext context) {
    BlocProvider.of<UsersBloc>(context).add(ApproveFriend(friend));
  }

  User getFriend(BuildContext context) {
    List<User> list = BlocProvider.of<UsersBloc>(context).users;
    list = list.where((element) => element.id == friend.id).toList();
    return list.first;
  }

  void showFriendOnMap(BuildContext context) {
    User friendUser = getFriend(context);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            MapScreen(lat: friendUser.lat, long: friendUser.long)));
  }

  void copyCoordinates(BuildContext context) async {
    User friendUser = getFriend(context);
    await Clipboard.setData(
      ClipboardData(text: '${friendUser.lat}, ${friendUser.long}'),
    );
    showCustomSnackBar(
      context,
      'Координаты скопированы в буфер обмена',
      type: SnackBarType.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: (_) => deleteFriend(context),
      confirmDismiss: (_) => showConfirmationModal(context),
      secondaryBackground: Container(
        color: Colors.red,
      ),
      background: Container(
        color: Colors.transparent,
      ),
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      child: SizedBox(
        height: 60,
        child: Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Text(
                  getFriend(context).email,
                  style: const TextStyle(fontSize: 16),
                ),
                const Spacer(),
                if (friend.approved)
                  IconButton(
                    onPressed: () => copyCoordinates(context),
                    icon: const Icon(
                      Icons.copy,
                      size: 18,
                    ),
                  ),
                BlocBuilder<UsersBloc, UsersState>(builder: (context, state) {
                  if (state.status == UserStatus.friendApprovePending &&
                      state.friendId == friend.id) {
                    return const SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (!friend.approved && !friend.initializer) {
                    return IconButton(
                        tooltip: 'Одобрить',
                        onPressed: () => approveFriend(context),
                        icon: const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ));
                  }
                  if (!friend.approved && friend.initializer) {
                    return const Tooltip(
                      message: 'Ожидает одобрения',
                      child: Icon(Icons.av_timer, color: Colors.orange),
                    );
                  }
                  if (friend.approved) {
                    return IconButton(
                        tooltip: 'Координаты',
                        onPressed: () => showFriendOnMap(context),
                        icon: const Icon(Icons.map));
                  }

                  return const SizedBox();
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
