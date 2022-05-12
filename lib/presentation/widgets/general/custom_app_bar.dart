import 'package:firebase_tracker/presentation/bloc/app_settings_bloc/app_settings_bloc.dart';
import 'package:firebase_tracker/presentation/bloc/users_bloc/users_bloc.dart';
import 'package:firebase_tracker/presentation/widgets/main_screen/app_settings_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/authorization_bloc/authorization_bloc.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final bool hasSettings;

  const CustomAppBar({Key? key, required this.title, this.hasSettings = false})
      : super(key: key);

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
      title: Text(title),
      actions: [
        if (hasSettings)
          IconButton(
              onPressed: () => onSettingsPressed(context),
              icon: const Icon(Icons.miscellaneous_services_outlined,
                  color: Colors.white)),
        IconButton(
            onPressed: () => logOut(context),
            icon: const Icon(Icons.logout, color: Colors.white))
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
