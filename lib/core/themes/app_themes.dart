import 'package:firebase_tracker/domain/entites/app_settings.dart';
import 'package:flutter/material.dart';

final appThemeData = {
  AppTheme.light: ThemeData(
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
        onSurface: Colors.black,
      ),
      textTheme: const TextTheme()),
  AppTheme.dark: ThemeData(
      colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: Colors.teal,
          onPrimary: Colors.black,
          secondary: Colors.black,
          onSecondary: Colors.white,
          error: Colors.red,
          onError: Colors.red,
          background: Colors.black,
          onBackground: Colors.white,
          surface: Colors.black,
          onSurface: Colors.white),
      textTheme: const TextTheme()),
};
