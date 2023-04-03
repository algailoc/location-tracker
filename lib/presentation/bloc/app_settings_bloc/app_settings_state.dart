part of 'app_settings_bloc.dart';

@immutable
abstract class AppSettingsState {
  final AppSettings settings;
  final bool isFirstLaunch;

  const AppSettingsState({
    required this.settings,
    required this.isFirstLaunch,
  });
}

class AppSettingsInitial extends AppSettingsState {
  const AppSettingsInitial(
      {required AppSettings settings, required bool isFirstLaunch})
      : super(
          settings: settings,
          isFirstLaunch: isFirstLaunch,
        );
}

class AppSettingsLoaded extends AppSettingsState {
  const AppSettingsLoaded(
      {required AppSettings settings, required bool isFirstLaunch})
      : super(
          settings: settings,
          isFirstLaunch: isFirstLaunch,
        );
}
