import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teacher_school_app/l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/constants/app_colors.dart';
import 'core/localization/app_locale.dart';
import 'core/localization/l10n_extension.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/services/firebase_service.dart';
import 'presentation/providers/app_locale_provider.dart';
import 'presentation/providers/app_theme_mode_provider.dart';
import 'presentation/providers/connectivity_provider.dart';
import 'core/storage/shared_prefs_service.dart';
import 'core/services/socket_listener.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefsService.init();
  await Hive.initFlutter();
  await initializeDateFormatting();
  unawaited(FirebaseService.init());

  runApp(const ProviderScope(child: TeacherApp()));
}

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class TeacherApp extends ConsumerStatefulWidget {
  const TeacherApp({super.key});

  @override
  ConsumerState<TeacherApp> createState() => _TeacherAppState();
}

class _TeacherAppState extends ConsumerState<TeacherApp> {
  StreamSubscription<RemoteMessage>? _fcmSubscription;

  @override
  void initState() {
    super.initState();
    _fcmSubscription = FirebaseService.onMessage.listen((message) {
      final l10n = AppLocalizationsRegistry.instance;
      final title =
          message.notification?.title ?? l10n.notificationFallbackTitle;
      final body = message.notification?.body ?? '';

      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              if (body.isNotEmpty) ...[const SizedBox(height: 4), Text(body)],
            ],
          ),
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          backgroundColor: TeacherAppColors.primaryPurple,
          action: SnackBarAction(
            label: l10n.close,
            textColor: Colors.white,
            onPressed: () {
              scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            },
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _fcmSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch connectivity to ensure outbox flushing is active
    ref.watch(connectivityProvider);

    final locale = ref.watch(appLocaleProvider);
    final themeMode = ref.watch(appThemeModeProvider);
    final router = ref.watch(routerProvider);
    // WebSocket tinglovchisini faollashtirish
    ref.watch(socketListenerProvider);

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appName,
      builder: (context, child) {
        // BuildContext mavjud bo'lganda l10n nusxasini registryga saqlash
        // Bu Notifierlar va boshqa static joylarda ishlatish imkonini beradi
        final l10n = AppLocalizations.of(context);
        if (l10n != null) {
          AppLocalizationsRegistry.update(l10n);
        }
        return child!;
      },
      debugShowCheckedModeBanner: false,
      theme: TeacherAppTheme.lightTheme,
      darkTheme: TeacherAppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      locale: locale.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      scaffoldMessengerKey: scaffoldMessengerKey,
    );
  }
}
