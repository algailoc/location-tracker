import 'package:firebase_tracker/presentation/widgets/main_screen/app_settings_menu.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        if (hasSettings)
          IconButton(
              onPressed: () => onSettingsPressed(context),
              icon: const Icon(Icons.miscellaneous_services_outlined,
                  color: Colors.white))
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
