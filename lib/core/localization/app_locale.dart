import 'package:flutter/material.dart';

enum AppLocale { uz, ru, en }

extension AppLocaleX on AppLocale {
  String get code => name;

  Locale get locale => Locale(code);

  String get nativeLabel {
    switch (this) {
      case AppLocale.uz:
        return 'O\'zbek';
      case AppLocale.ru:
        return 'Русский';
      case AppLocale.en:
        return 'English';
    }
  }
}

AppLocale appLocaleFromCode(String? code) {
  return AppLocale.values.firstWhere(
    (locale) => locale.code == code,
    orElse: () => AppLocale.uz,
  );
}
