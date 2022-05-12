import 'package:firebase_tracker/domain/repositories/app_settings_repository.dart';

import '../entites/app_settings.dart';

class AppSettingsUsecases {
  final AppSettingsRepository repository;

  AppSettingsUsecases({required this.repository});

  AppSettings getAppSettings() {
    return repository.getAppSettings();
  }

  void setAppTheme(AppTheme theme) {
    return repository.setAppTheme(theme);
  }

  void clearState() {
    return repository.clearState();
  }
}
