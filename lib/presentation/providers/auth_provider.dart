import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_strings.dart';
import '../../core/network/api_error_handler.dart';
import '../../core/network/api_service.dart';
import '../../core/services/firebase_service.dart';
import '../../data/datasources/remote/auth_api.dart';
import '../../data/datasources/remote/notification_api.dart';
import '../../data/models/teacher_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/notification_repository.dart';

// Dependency Injection Providers
final sessionExpiredSignalProvider = StateProvider<int>((ref) => 0);

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService(
    onUnauthorized: () {
      ref.read(sessionExpiredSignalProvider.notifier).state++;
    },
  );
});

final authApiProvider = Provider<AuthApi>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return AuthApi(apiService);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authApi = ref.watch(authApiProvider);
  return AuthRepository(authApi);
});

// Auth State Controller
class AuthState {
  static const Object _sentinel = Object();

  final bool isLoading;
  final bool isAuthenticated;
  final TeacherModel? user;
  final String? token;
  final String? error;

  AuthState({
    this.isLoading = true,
    this.isAuthenticated = false,
    this.user,
    this.token,
    this.error,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    Object? user = _sentinel,
    String? token,
    Object? error = _sentinel,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: identical(user, _sentinel) ? this.user : user as TeacherModel?,
      token: token ?? this.token,
      error: identical(error, _sentinel) ? this.error : error as String?,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  final NotificationRepository _notificationRepository;
  StreamSubscription<String>? _tokenRefreshSubscription;

  AuthController(this._repository, this._notificationRepository)
    : super(AuthState()) {
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    state = state.copyWith(isLoading: true);
    final hasToken = await _repository.hasToken();

    if (hasToken) {
      try {
        final token = await _repository.getToken();
        final user = await _repository.fetchMe();
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          user: user,
          token: token,
        );
        _syncFcmToken();
      } catch (e) {
        await _repository.clearSession();
        state = state.copyWith(isLoading: false, isAuthenticated: false);
      }
    } else {
      state = state.copyWith(isLoading: false, isAuthenticated: false);
    }
  }

  Future<bool> login(
    String username,
    String password,
    String deviceName,
  ) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _repository.login(username, password, deviceName);
      final token = await _repository.getToken();
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: user,
        token: token,
      );
      _syncFcmToken();
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: ApiErrorHandler.readableMessage(e),
      );
      return false;
    }
  }

  Future<void> _syncFcmToken() async {
    try {
      final initialized = await FirebaseService.init();
      if (!initialized) {
        return;
      }

      final messaging = FirebaseMessaging.instance;
      final settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        return;
      }

      final token = await FirebaseService.getFcmToken();
      if (token != null && token.isNotEmpty) {
        await _notificationRepository.saveFcmToken(token);
      }

      await _tokenRefreshSubscription?.cancel();
      _tokenRefreshSubscription = FirebaseService.onTokenRefresh.listen((
        newToken,
      ) async {
        await _notificationRepository.saveFcmToken(newToken);
      });
    } catch (e) {
      if (kDebugMode) print('Error syncing FCM token: $e');
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    await _tokenRefreshSubscription?.cancel();
    _tokenRefreshSubscription = null;
    await _repository.logout();
    state = state.copyWith(
      isLoading: false,
      isAuthenticated: false,
      user: null,
      error: null,
    );
  }

  Future<void> handleSessionExpired() async {
    await _tokenRefreshSubscription?.cancel();
    _tokenRefreshSubscription = null;
    await _repository.clearSession();
    state = state.copyWith(
      isLoading: false,
      isAuthenticated: false,
      user: null,
      error: AppStrings.sessionExpired,
    );
  }

  void clearError() {
    if (state.error == null) return;
    state = state.copyWith(error: null);
  }

  @override
  void dispose() {
    _tokenRefreshSubscription?.cancel();
    super.dispose();
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    final repository = ref.watch(authRepositoryProvider);
    final apiService = ref.watch(apiServiceProvider);
    final notificationRepository = NotificationRepository(
      NotificationApi(apiService),
    );
    final controller = AuthController(repository, notificationRepository);
    ref.listen<int>(sessionExpiredSignalProvider, (previous, next) {
      if (previous == next) return;
      controller.handleSessionExpired();
    });
    return controller;
  },
);
