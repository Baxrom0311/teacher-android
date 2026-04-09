import '../localization/app_localizations.dart';

class AppStrings {
  static String get noInternet => AppLocalizations.current.noInternet;
  static String get errorGeneric => AppLocalizations.current.errorGeneric;
  static String get errorServer => AppLocalizations.current.errorServer;
  static String get errorAuth => AppLocalizations.current.errorAuth;
  static String get sessionExpired => AppLocalizations.current.sessionExpired;
  static String get passwordRequired =>
      AppLocalizations.current.passwordRequired;
  static String get passwordTooShort =>
      AppLocalizations.current.passwordTooShort;
}
