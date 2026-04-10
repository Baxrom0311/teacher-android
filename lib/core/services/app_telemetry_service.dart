import 'dart:async';
import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'firebase_service.dart';

class AppTelemetryService {
  AppTelemetryService._();

  static FirebaseAnalytics? _analytics;
  static FirebaseCrashlytics? _crashlytics;
  static Future<void>? _initializing;
  static bool _errorHandlersInstalled = false;
  static String? _pendingScreenName;
  static String? _lastScreenName;
  static final List<_QueuedError> _pendingErrors = <_QueuedError>[];
  static final NavigatorObserver _routeObserver = _TelemetryRouteObserver();

  static List<NavigatorObserver> get navigatorObservers => <NavigatorObserver>[
    _routeObserver,
  ];

  static void installErrorHandlers() {
    if (_errorHandlersInstalled) {
      return;
    }

    final previousOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      previousOnError?.call(details);
      unawaited(
        recordError(
          details.exception,
          details.stack ?? StackTrace.current,
          fatal: true,
          reason: details.context?.toDescription(),
        ),
      );
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      unawaited(recordError(error, stack, fatal: true));
      return true;
    };

    _errorHandlersInstalled = true;
  }

  static Future<void> init() async {
    final initializing = _initializing;
    if (initializing != null) {
      await initializing;
      return;
    }

    _initializing = _initInternal();
    await _initializing;
    _initializing = null;
  }

  static Future<void> _initInternal() async {
    await FirebaseService.init();

    if (Firebase.apps.isEmpty) {
      _debugLog('Telemetry skipped because Firebase is not configured.');
      return;
    }

    try {
      _analytics ??= FirebaseAnalytics.instance;
      _crashlytics ??= FirebaseCrashlytics.instance;

      const collectionEnabled = !kDebugMode;
      await _analytics!.setAnalyticsCollectionEnabled(collectionEnabled);
      await _crashlytics!.setCrashlyticsCollectionEnabled(collectionEnabled);

      if (_pendingScreenName case final screenName?) {
        await _logScreenViewInternal(screenName);
      }

      if (_pendingErrors.isNotEmpty) {
        final queuedErrors = List<_QueuedError>.from(_pendingErrors);
        _pendingErrors.clear();
        for (final queued in queuedErrors) {
          await _recordErrorInternal(
            queued.error,
            queued.stackTrace,
            fatal: queued.fatal,
            reason: queued.reason,
          );
        }
      }
    } catch (error, stackTrace) {
      _debugLog('Telemetry init error: $error');
      _debugLog('$stackTrace');
    }
  }

  static Future<void> logScreenView(String screenName) async {
    final normalizedScreenName = screenName.trim();
    if (normalizedScreenName.isEmpty ||
        normalizedScreenName == _lastScreenName) {
      return;
    }

    _lastScreenName = normalizedScreenName;
    _pendingScreenName = normalizedScreenName;

    if (_analytics == null) {
      return;
    }

    await _logScreenViewInternal(normalizedScreenName);
  }

  static Future<void> _logScreenViewInternal(String screenName) async {
    final analytics = _analytics;
    if (analytics == null) {
      return;
    }

    await analytics.logScreenView(
      screenName: screenName,
      screenClass: screenName,
    );
  }

  static Future<void> recordError(
    Object error,
    StackTrace stackTrace, {
    required bool fatal,
    String? reason,
  }) async {
    if (_crashlytics == null) {
      if (_pendingErrors.length < 20) {
        _pendingErrors.add(
          _QueuedError(error, stackTrace, fatal: fatal, reason: reason),
        );
      }
      return;
    }

    await _recordErrorInternal(error, stackTrace, fatal: fatal, reason: reason);
  }

  static Future<void> _recordErrorInternal(
    Object error,
    StackTrace stackTrace, {
    required bool fatal,
    String? reason,
  }) async {
    final crashlytics = _crashlytics;
    if (crashlytics == null) {
      return;
    }

    await crashlytics.recordError(
      error,
      stackTrace,
      fatal: fatal,
      reason: reason,
    );
  }

  static void _debugLog(String message) {
    if (kDebugMode) {
      log(message, name: 'AppTelemetryService');
    }
  }
}

class _TelemetryRouteObserver extends NavigatorObserver {
  void _track(Route<dynamic>? route) {
    final screenName = route?.settings.name;
    if (screenName == null || screenName.isEmpty) {
      return;
    }

    unawaited(AppTelemetryService.logScreenView(screenName));
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _track(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _track(previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _track(newRoute);
  }
}

class _QueuedError {
  const _QueuedError(
    this.error,
    this.stackTrace, {
    required this.fatal,
    this.reason,
  });

  final Object error;
  final StackTrace stackTrace;
  final bool fatal;
  final String? reason;
}
