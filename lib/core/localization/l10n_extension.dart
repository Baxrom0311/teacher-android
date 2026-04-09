import 'package:flutter/widgets.dart';
import 'package:teacher_school_app/l10n/app_localizations.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n =>
      AppLocalizations.of(this) ?? AppLocalizationsRegistry.instance;
}

extension AppLocalizationsHelpers on AppLocalizations {
  bool get _isUz => localeName.startsWith('uz');
  bool get _isRu => localeName.startsWith('ru');

  String _pick({required String uz, required String ru, required String en}) {
    if (_isUz) return uz;
    if (_isRu) return ru;
    return en;
  }

  String lessonOrderLabel(int order) =>
      _pick(uz: '$order-dars', ru: '$order-й урок', en: 'Lesson $order');

  String syncingActions(int count) => _pick(
    uz: '$count ta amal serverga yuborilmoqda',
    ru: '$count действий отправляется на сервер',
    en: '$count actions are being synced',
  );

  String syncSuccess(int count) => _pick(
    uz: '$count ta amal muvaffaqiyatli sinxronlandi',
    ru: '$count действий успешно синхронизировано',
    en: '$count actions synced successfully',
  );

  String offlineQueued(int count) => _pick(
    uz: '$count ta amal navbatga saqlandi',
    ru: '$count действий сохранено в очереди',
    en: '$count actions were queued offline',
  );

  String pendingQueue(int count) => _pick(
    uz: '$count ta amal sinxronlashni kutmoqda',
    ru: '$count действий ожидают синхронизации',
    en: '$count actions are waiting to sync',
  );

  String get syncErrorFallback => _pick(
    uz: 'Sinxronlashda xatolik yuz berdi',
    ru: 'Произошла ошибка синхронизации',
    en: 'Sync failed',
  );

  String get offlineSavedChanges => _pick(
    uz: 'O\'zgarishlar internet tiklangach yuboriladi',
    ru: 'Изменения будут отправлены после восстановления сети',
    en: 'Changes will sync when the connection returns',
  );
}

/// A static localization holder to bridger the gap for Notifiers and tests
/// where BuildContext is not available.
class AppLocalizationsRegistry {
  static AppLocalizations _instance = lookupAppLocalizations(
    const Locale('uz'),
  );

  static AppLocalizations get instance => _instance;

  static void update(dynamic instance) {
    if (instance is AppLocalizations) {
      _instance = instance;
    }
  }
}
