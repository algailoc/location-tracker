import 'package:firebase_tracker/presentation/bloc/app_settings_bloc/app_settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ApprovedInstructions extends StatelessWidget {
  const ApprovedInstructions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppSettingsBloc, AppSettingsState>(
        builder: (context, state) {
      return AnimatedContainer(
        duration: const Duration(
          milliseconds: 300,
        ),
        height: state.isFirstLaunch ? 110 : 0,
        decoration: BoxDecoration(
          color: Colors.teal,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                width: 10,
                height: 10,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => BlocProvider.of<AppSettingsBloc>(context).add(
                    SetFirstLaunchEvent(false),
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'B приложении действует система одобрения. После того, как вы добавляете пользователя в друзья, он долженд одобрить вас. Только после этого вы получите доступ к его геолокации.',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
    });
  }
}
