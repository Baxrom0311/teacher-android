import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teacher_school_app/core/storage/shared_prefs_service.dart';
import 'package:teacher_school_app/presentation/providers/app_theme_mode_provider.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await SharedPrefsService.init();
  });

  test('defaults to system theme mode', () {
    final notifier = AppThemeModeNotifier();

    expect(notifier.state, ThemeMode.system);
  });

  test('persists selected theme mode', () async {
    final notifier = AppThemeModeNotifier();

    await notifier.setThemeMode(ThemeMode.dark);

    expect(notifier.state, ThemeMode.dark);

    final restoredNotifier = AppThemeModeNotifier();
    expect(restoredNotifier.state, ThemeMode.dark);
  });
}
