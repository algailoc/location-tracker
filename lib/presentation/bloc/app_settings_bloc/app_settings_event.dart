part of 'app_settings_bloc.dart';

@immutable
abstract class AppSettingsEvent {}

class GetAppSettingsEvent extends AppSettingsEvent {}

class ChangeAppThemeEvent extends AppSettingsEvent {
  final AppTheme theme;

  ChangeAppThemeEvent(this.theme);
}

class ClearStateEvent extends AppSettingsEvent {}

class SetFirstLaunchEvent extends AppSettingsEvent {
  final bool value;

  SetFirstLaunchEvent(this.value);
}
