import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../datasources/remote/auth_api.dart';
import '../models/login_response.dart';
import '../models/teacher_model.dart';
import '../../core/network/api_error_handler.dart';
import '../../core/localization/l10n_extension.dart';

class AuthRepository {
  final AuthApi _authApi;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthRepository(this._authApi);

  Future<LoginResponse> centralLogin(
    String username,
    String password,
    String deviceName,
  ) async {
    try {
      final response = await _authApi.centralLogin(username, password, deviceName);
      final loginResponse = LoginResponse.fromJson(response.data);

      // Save central token
      await _storage.write(key: 'central_token', value: loginResponse.centralToken);

      // If auto_tenant is provided (only 1 school), save it immediately
      if (loginResponse.autoTenant != null) {
        await saveTenantSession(
          host: loginResponse.autoTenant!.host,
          token: loginResponse.autoTenant!.token,
        );
      }

      return loginResponse;
    } catch (error, stackTrace) {
      ApiErrorHandler.throwAsException(error, stackTrace);
    }
  }

  Future<TeacherModel> tenantLogin({
    required String username,
    required String password,
    required String deviceName,
  }) async {
    try {
      // API call to tenant-specific login (/api/login)
      // ApiService handles the Host/BaseUrl based on what's in storage
      final response = await _authApi.tenantLogin(username, password, deviceName);
      final token = response.data['token'];
      final user = TeacherModel.fromJson(response.data['user'] ?? {});

      // Save tenant token (auth_token is used for tenant-level requests)
      await _storage.write(key: 'auth_token', value: token);

      return user;
    } catch (error, stackTrace) {
      ApiErrorHandler.throwAsException(error, stackTrace);
    }
  }

  Future<List<SchoolModel>> getPublicSchools() async {
    try {
      final response = await _authApi.getPublicSchools();
      return (response.data['schools'] as List? ?? [])
          .map((s) => SchoolModel.fromJson(s))
          .toList();
    } catch (error, stackTrace) {
      ApiErrorHandler.throwAsException(error, stackTrace);
    }
  }

  Future<void> issueTenantToken({
    required int membershipId,
    required String host,
    String deviceName = 'android_app',
  }) async {
    try {
      final response = await _authApi.issueTenantToken(membershipId, deviceName);
      final token = response.data['token'];
      
      await saveTenantSession(host: host, token: token);
    } catch (error, stackTrace) {
      ApiErrorHandler.throwAsException(error, stackTrace);
    }
  }

  Future<void> saveTenantSession({
    required String host,
    required String token,
  }) async {
    await _storage.write(key: 'tenant_host', value: host);
    await _storage.write(key: 'auth_token', value: token);
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

  Future<void> saveSelectedSchool(SchoolModel school) async {
    await _storage.write(key: 'tenant_host', value: school.host);
    await _storage.write(key: 'selected_school_name', value: school.schoolName);
  }

  Future<String?> getSelectedSchoolName() async {
    return await _storage.read(key: 'selected_school_name');
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
