import 'package:firebase_tracker/domain/entites/app_settings.dart';
import 'package:flutter/material.dart';

final appThemeData = {
  AppTheme.Light: ThemeData(
      colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Colors.teal,
          onPrimary: Colors.white,
          secondary: Colors.white,
          onSecondary: Colors.black,
          error: Colors.red,
          onError: Colors.red,
          background: Colors.white,
          onBackground: Colors.black,
          surface: Colors.white,
          onSurface: Colors.black),
      textTheme: const TextTheme()),
  AppTheme.Dark: ThemeData(),
};
