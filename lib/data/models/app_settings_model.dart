import 'package:firebase_tracker/domain/entites/app_settings.dart';

class AppSettingsModel extends AppSettings {
  AppSettingsModel({required AppTheme theme}) : super(theme: theme);

  @override
  AppSettingsModel copyWith({AppTheme? theme}) {
    return AppSettingsModel(theme: theme ?? this.theme);
  }
}
