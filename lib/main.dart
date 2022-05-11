import 'package:firebase_tracker/core/themes/app_themes.dart';
import 'package:firebase_tracker/firebase.dart';
import 'package:firebase_tracker/presentation/bloc/app_settings_bloc/app_settings_bloc.dart';
import 'package:firebase_tracker/presentation/bloc/authorization_bloc/authorization_bloc.dart';
import 'package:firebase_tracker/presentation/bloc/users_bloc/users_bloc.dart';
import 'package:firebase_tracker/presentation/screens/loading_screen/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dependencies_injection.dart' as di;
import 'domain/entites/app_settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  di.init();
  await LocalFirebase.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UsersBloc>(
          create: (_) => di.sl<UsersBloc>(),
        ),
        BlocProvider(
          create: (_) => di.sl<AuthorizationBloc>(),
        ),
        BlocProvider(
          create: (_) => di.sl<AppSettingsBloc>(),
        ),
      ],
      child: BlocBuilder<AppSettingsBloc, AppSettingsState>(
        builder: (context, state) {
          return MaterialApp(
            theme: appThemeData[state.settings.theme],
            home: const LoadingScreen(),
          );
        },
      ),
    );
  }
}
