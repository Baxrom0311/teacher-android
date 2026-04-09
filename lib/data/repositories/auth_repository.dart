import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import '../../core/network/api_error_handler.dart';
import '../datasources/remote/auth_api.dart';
import '../models/teacher_model.dart';

class AuthRepository {
  final AuthApi _authApi;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthRepository(this._authApi);

  Future<TeacherModel> login(
    String username,
    String password,
    String deviceName,
  ) async {
    try {
      final response = await _authApi.login(username, password, deviceName);

      final token = response.data['token'];
      final userData = response.data['user'];

      await _storage.write(key: 'auth_token', value: token);

      return TeacherModel.fromJson(userData);
    } catch (error, stackTrace) {
      ApiErrorHandler.throwAsException(error, stackTrace);
    }
  }

  Future<void> logout() async {
    try {
      await _authApi.logout();
    } catch (e) {
      // Ignore API errors on logout to ensure local clear completes
    } finally {
      await clearSession();
    }
  }

  Future<TeacherModel> fetchMe() async {
    try {
      final response = await _authApi.getMe();
      return TeacherModel.fromJson(response.data);
    } catch (error, stackTrace) {
      ApiErrorHandler.throwAsException(
        error,
        stackTrace,
        fallback: AppLocalizationsRegistry.instance.failedFetchProfile,
      );
    }
  }

  Future<bool> hasToken() async {
    final token = await _storage.read(key: 'auth_token');
    return token != null && token.isNotEmpty;
  }

  Future<void> clearSession() async {
    await _storage.delete(key: 'auth_token');
  }

  Future<String?> getToken() async {
    return _storage.read(key: 'auth_token');
  }

  Future<void> saveFcmToken(String fcmToken) async {
    try {
      await _authApi.updateFcmToken(fcmToken);
    } catch (e) {
      // FCM token xatosi loginni bloklamasligi kerak
    }
  }
}
