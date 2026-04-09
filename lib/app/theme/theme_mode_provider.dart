import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

final appThemeModeProvider =
    StateNotifierProvider<AppThemeModeNotifier, ThemeMode>(
      (ref) => AppThemeModeNotifier(),
    );

class AppThemeModeNotifier extends StateNotifier<ThemeMode> {
  AppThemeModeNotifier() : super(ThemeMode.light);

  bool get isDarkMode => state == ThemeMode.dark;

  void toggleTheme(bool isDark) {
    state = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void setThemeMode(ThemeMode mode) {
    state = mode;
  }
}
