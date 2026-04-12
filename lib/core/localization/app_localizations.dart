import 'package:flutter/widgets.dart';
import 'package:teacher_school_app/l10n/app_localizations.dart' as generated;

import 'app_locale.dart';
import 'l10n_extension.dart';

export 'l10n_extension.dart' show AppLocalizationsRegistry;

class AppLocalizations {
  final generated.AppLocalizations _delegate;

  AppLocalizations(AppLocale locale)
    : _delegate = generated.lookupAppLocalizations(locale.locale);

  static generated.AppLocalizations get current =>
      AppLocalizationsRegistry.instance;

  static generated.AppLocalizations of(BuildContext context) =>
      generated.AppLocalizations.of(context) ??
      AppLocalizationsRegistry.instance;

  static const List<Locale> supportedLocales =
      generated.AppLocalizations.supportedLocales;

  static const LocalizationsDelegate<generated.AppLocalizations> delegate =
      generated.AppLocalizations.delegate;

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      generated.AppLocalizations.localizationsDelegates;

  static void updateCurrent(dynamic instance) {
    if (instance is AppLocalizations) {
      AppLocalizationsRegistry.update(instance._delegate);
      return;
    }

    AppLocalizationsRegistry.update(instance);
  }
}
