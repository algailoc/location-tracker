enum AppTheme { light, dark }

abstract class AppSettings {
  final AppTheme theme;

  AppSettings({required this.theme});

  AppSettings copyWith({AppTheme? theme});
}
