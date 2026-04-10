import 'dart:async';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../../firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (error) {
    log(
      'Background handler Firebase init error: $error',
      name: 'FirebaseService',
    );
    return;
  }

  if (kDebugMode) {
    log(
      'Background message handled: ${message.messageId}',
      name: 'FirebaseService',
    );
  }
}

class FirebaseService {
  FirebaseService._();

  static FirebaseMessaging? _firebaseMessaging;
  static bool _initialized = false;
  static Future<bool>? _initializing;
  static StreamSubscription<String>? _tokenRefreshSubscription;

  static final StreamController<RemoteMessage> _messageStreamController =
      StreamController<RemoteMessage>.broadcast();
  static final StreamController<String> _tokenRefreshStreamController =
      StreamController<String>.broadcast();

  static Stream<RemoteMessage> get onMessage => _messageStreamController.stream;
  static Stream<String> get onTokenRefresh =>
      _tokenRefreshStreamController.stream;
  static bool get isInitialized => _initialized;

  static Future<bool> init() async {
    if (_initialized) return true;

    final initializing = _initializing;
    if (initializing != null) {
      return initializing;
    }

    _initializing = _initInternal();
    final initialized = await _initializing!;
    _initializing = null;
    return initialized;
  }

  static Future<bool> _initInternal() async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }

      _firebaseMessaging = FirebaseMessaging.instance;
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      await _firebaseMessaging?.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        _debugLog('Foreground FCM message received: ${message.messageId}');
        _messageStreamController.add(message);
      });

      await _tokenRefreshSubscription?.cancel();
      _tokenRefreshSubscription = _firebaseMessaging?.onTokenRefresh.listen(
        _tokenRefreshStreamController.add,
      );

      _initialized = true;
      return true;
    } catch (error) {
      _debugLog(
        'Firebase init error: $error. Firebase config bo\'lmasa push ishlamaydi, lekin app davom etadi.',
      );
      return false;
    }
  }

  static Future<String?> getFcmToken() async {
    final initialized = await init();
    if (!initialized || _firebaseMessaging == null) {
      return null;
    }

    try {
      final token = await _firebaseMessaging!.getToken();
      if (token != null && token.isNotEmpty) {
        _debugLog('FCM token acquired');
      }
      return token;
    } catch (error) {
      _debugLog('Error getting FCM token: $error');
      return null;
    }
  }

  static Future<void> dispose() async {
    await _tokenRefreshSubscription?.cancel();
    await _messageStreamController.close();
    await _tokenRefreshStreamController.close();
  }

  static void _debugLog(String message) {
    if (kDebugMode) {
      log(message, name: 'FirebaseService');
    }
  }
}
