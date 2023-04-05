import 'package:firebase_tracker/domain/entites/app_settings.dart';

abstract class AppSettingsRepository {
  /// Возвращает настройки приложения (пока только тему :) )
  AppSettings getAppSettings();

  /// Устанавливает тему приложения
  void setAppTheme(AppTheme theme);

  /// Сбрасывает настройки
  void clearState();

  /// Возвращает, первый ли раз пользователь входит в зарегистрированный аккаунт
  Future<bool> getIsFirstLaunch();

  /// Устанавливает, первый это запуск или нет
  Future<void> setIsFirstLaunch(bool value);
}
