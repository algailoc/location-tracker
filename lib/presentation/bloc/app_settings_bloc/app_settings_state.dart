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
  AppSettingsInitial()
      : super(
          settings: AppSettingsModel(theme: AppTheme.Light),
          isFirstLaunch: false,
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
