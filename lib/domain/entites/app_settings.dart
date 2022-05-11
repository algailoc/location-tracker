enum AppTheme { Light, Dark }

abstract class AppSettings {
  final AppTheme theme;

  AppSettings({required this.theme});

  AppSettings copyWith({AppTheme? theme});
}
