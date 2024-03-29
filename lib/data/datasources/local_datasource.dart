import 'package:firebase_tracker/domain/entites/app_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalDatasource {
  /// Возвращает токен пользователя
  String getUserToken();

  /// Сохраняет токен пользователя
  Future<String> setUserToken(String userToken);

  /// Получает инфо о выбранной теме приложения
  AppTheme getAppTheme();

  /// Меняет тему приложения
  void setAppTheme(AppTheme theme);

  /// Возвращает, было ли запущено приложение впервые(с активным аккаунтом)
  Future<bool> getIsFirstLaunch();

  /// Устанавливает параметр первого запуска для пользователя
  Future<void> setIsFirstLaunch(bool value);
}

class LocalDatasourceImpl extends LocalDatasource {
  final SharedPreferences preferences;

  LocalDatasourceImpl(this.preferences);

  @override
  String getUserToken() {
    final result = preferences.getString('userToken');
    if (result == null || result.isEmpty) {
      return '';
    } else {
      return result;
    }
  }

  @override
  Future<String> setUserToken(String userToken) async {
    final result = await preferences.setString('userToken', userToken);
    if (result) {
      return userToken;
    } else {
      return userToken;
    }
  }

  @override
  AppTheme getAppTheme() {
    final result = preferences.getString('APP_THEME');
    return result == 'dark' ? AppTheme.dark : AppTheme.light;
  }

  @override
  void setAppTheme(AppTheme theme) {
    preferences.setString(
        'APP_THEME', theme == AppTheme.light ? 'light' : 'dark');
  }

  @override
  Future<bool> getIsFirstLaunch() async {
    final result = preferences.getBool('FIRST_LAUNCH');
    return result ?? true;
  }

  @override
  Future<void> setIsFirstLaunch(bool value) {
    return preferences.setBool('FIRST_LAUNCH', value);
  }
}
