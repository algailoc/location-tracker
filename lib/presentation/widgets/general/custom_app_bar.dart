import 'package:firebase_tracker/presentation/bloc/app_settings_bloc/app_settings_bloc.dart';
import 'package:firebase_tracker/presentation/bloc/users_bloc/users_bloc.dart';
import 'package:firebase_tracker/presentation/widgets/main_screen/app_settings_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/authorization_bloc/authorization_bloc.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final bool hasSettings;
  final bool showBackButton;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.hasSettings = false,
    this.showBackButton = false,
  }) : super(key: key);

  onSettingsPressed(BuildContext context) {
    if (settingsSheetKey.currentState != null) {
      Navigator.of(context).pop();
    } else {
      showBottomSheet(
          context: context, builder: (_) => const AppSettingsMenu());
    }
  }

  void logOut(BuildContext context) {
    BlocProvider.of<AuthorizationBloc>(context).add(SignOutUser());
    BlocProvider.of<UsersBloc>(context).add(ClearState());
    BlocProvider.of<AppSettingsBloc>(context).add(ClearStateEvent());
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(title),
      leading: showBackButton
          ? IconButton(
              onPressed: Navigator.of(context).pop,
              icon: const Icon(
                Icons.arrow_back,
              ),
            )
          : null,
      actions: [
        if (hasSettings)
          IconButton(
              onPressed: () => onSettingsPressed(context),
              icon: const Icon(Icons.miscellaneous_services_outlined,
                  color: Colors.white)),
        IconButton(
            onPressed: () async {
              final result = await _showLogOutConfirmation(context);
              if (result) {
                logOut(context);
              }
            },
            icon: const Icon(Icons.logout, color: Colors.white))
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

Future<bool> _showLogOutConfirmation(BuildContext context) async {
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
                  'Вы уверены, что хотите выйти из аккаунта?',
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
                        'Выйти',
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
