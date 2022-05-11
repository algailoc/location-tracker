part of 'app_settings_bloc.dart';

@immutable
abstract class AppSettingsState {
  final AppSettings settings;

  const AppSettingsState({required this.settings});
}

class AppSettingsInitial extends AppSettingsState {
  const AppSettingsInitial({required AppSettings settings})
      : super(settings: settings);
}

class AppSettingsLoaded extends AppSettingsState {
  const AppSettingsLoaded({required AppSettings settings})
      : super(settings: settings);
}
