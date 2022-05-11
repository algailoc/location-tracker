import 'package:firebase_tracker/data/datasources/local_datasource.dart';
import 'package:firebase_tracker/data/models/app_settings_model.dart';
import 'package:firebase_tracker/domain/entites/app_settings.dart';

import '../../domain/repositories/app_settings_repository.dart';

class AppSettingsRepositoryImpl extends AppSettingsRepository {
  final LocalDatasource localDatasource;

  AppSettingsRepositoryImpl({required this.localDatasource});

  @override
  AppSettings getAppSettings() {
    final theme = localDatasource.getAppTheme();
    return AppSettingsModel(theme: theme);
  }

  @override
  void setAppTheme(AppTheme theme) {
    localDatasource.setAppTheme(theme);
  }
}
