import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:firebase_tracker/data/models/app_settings_model.dart';
import 'package:firebase_tracker/domain/entites/app_settings.dart';
import 'package:firebase_tracker/domain/usecases/app_settings_usecases.dart';
import 'package:meta/meta.dart';

part 'app_settings_event.dart';
part 'app_settings_state.dart';

final AppSettings initSettings = AppSettingsModel(theme: AppTheme.Light);

class AppSettingsBloc extends Bloc<AppSettingsEvent, AppSettingsState> {
  AppSettings settings = initSettings;
  bool isFirstLaunch = false;

  final AppSettingsUsecases usecases;
  AppSettingsBloc({required this.usecases})
      : super(AppSettingsInitial(
          settings: initSettings,
          isFirstLaunch: false,
        )) {
    on<AppSettingsEvent>((event, emit) async {
      if (event is GetAppSettingsEvent) {
        final result = usecases.getAppSettings();
        isFirstLaunch = await usecases.getIsFirstLaunch();
        settings = result;
        emit(AppSettingsLoaded(
          settings: settings,
          isFirstLaunch: isFirstLaunch,
        ));
      } else if (event is ChangeAppThemeEvent) {
        usecases.setAppTheme(event.theme);
        settings = settings.copyWith(theme: event.theme);
        emit(AppSettingsLoaded(
          settings: settings,
          isFirstLaunch: isFirstLaunch,
        ));
      } else if (event is ClearStateEvent) {
        usecases.clearState();
        await usecases.setIsFirstLaunch(true);
        emit(AppSettingsLoaded(
          settings: AppSettingsModel(theme: AppTheme.Light),
          isFirstLaunch: isFirstLaunch,
        ));
      } else if (event is SetFirstLaunchEvent) {
        isFirstLaunch = event.value;
        await usecases.setIsFirstLaunch(event.value);
        emit(AppSettingsLoaded(
          settings: settings,
          isFirstLaunch: isFirstLaunch,
        ));
      }
    });
  }
}
