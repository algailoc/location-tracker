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

  final AppSettingsUsecases usecases;
  AppSettingsBloc({required this.usecases})
      : super(AppSettingsInitial(settings: initSettings)) {
    on<AppSettingsEvent>((event, emit) async {
      if (event is GetAppSettingsEvent) {
        final result = usecases.getAppSettings();
        settings = result;
        emit(AppSettingsLoaded(settings: settings));
      } else if (event is ChangeAppThemeEvent) {
        usecases.setAppTheme(event.theme);
        settings = settings.copyWith(theme: event.theme);
        emit(AppSettingsLoaded(settings: settings));
      }
    });
  }
}
