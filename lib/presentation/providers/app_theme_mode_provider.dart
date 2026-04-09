import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/storage/shared_prefs_service.dart';

class AppThemeModeNotifier extends StateNotifier<ThemeMode> {
  AppThemeModeNotifier()
    : super(_themeModeFromCode(SharedPrefsService.getString(_themeModeKey)));

  static const String _themeModeKey = 'theme_mode';

  Future<void> setThemeMode(ThemeMode themeMode) async {
    if (state == themeMode) return;
    state = themeMode;
    await SharedPrefsService.setString(_themeModeKey, themeMode.name);
  }

  static ThemeMode _themeModeFromCode(String? code) {
    return switch (code) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }
}

final appThemeModeProvider =
    StateNotifierProvider<AppThemeModeNotifier, ThemeMode>((ref) {
      return AppThemeModeNotifier();
    });
