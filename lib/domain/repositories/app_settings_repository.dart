import 'package:firebase_tracker/domain/entites/app_settings.dart';

abstract class AppSettingsRepository {
  AppSettings getAppSettings();
  void setAppTheme(AppTheme theme);

  void clearState();
}
