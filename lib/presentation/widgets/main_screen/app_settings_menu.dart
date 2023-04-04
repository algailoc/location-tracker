import 'package:firebase_tracker/domain/entites/app_settings.dart';
import 'package:firebase_tracker/presentation/bloc/app_settings_bloc/app_settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

GlobalKey settingsSheetKey = GlobalKey();

class AppSettingsMenu extends StatelessWidget {
  const AppSettingsMenu({Key? key}) : super(key: key);

  void changeThemeHandler(AppTheme theme, BuildContext context) {
    BlocProvider.of<AppSettingsBloc>(context).add(ChangeAppThemeEvent(theme));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
        key: settingsSheetKey,
        onClosing: () {},
        elevation: 10,
        builder: (_) {
          return Container(
            width: double.infinity,
            height: 120,
            decoration: const BoxDecoration(),
            child: Column(
              children: [
                buildMenuOption(context, 'Светлая',
                    () => changeThemeHandler(AppTheme.light, context)),
                buildMenuOption(context, 'Тёмная',
                    () => changeThemeHandler(AppTheme.dark, context)),
              ],
            ),
          );
        });
  }
}

Widget buildMenuOption(
        BuildContext context, String text, void Function() onPressed) =>
    GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 0),
                blurRadius: 8,
                color: Colors.black.withOpacity(0.3))
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
