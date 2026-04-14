import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_service.dart';

class AuthApi {
  final ApiService _apiService;

  AuthApi(this._apiService);
  
  Future<Response> getPublicSchools() async {
    return await _apiService.dio.get(
      ApiConstants.publicSchools,
      options: Options(extra: {
        'skipAuth': true,
        'skipTenant': true,
      }),
    );
  }

  Future<Response> centralLogin(
    String username,
    String password,
    String deviceName,
  ) async {
    return await _apiService.dio.post(
      ApiConstants.centralTeacherLogin,
      data: {
        'login': username,
        'password': password,
        'device_name': deviceName,
      },
    );
  }

  Future<Response> tenantLogin(
    String username,
    String password,
    String deviceName,
  ) async {
    return await _apiService.dio.post(
      ApiConstants.login,
      data: {
        'login': username,
        'password': password,
        'device_name': deviceName,
      },
    );
  }

  Future<Response> issueTenantToken(int membershipId, String deviceName) async {
    return await _apiService.dio.post(
      ApiConstants.teacherSchoolToken,
      data: {
        'membership_id': membershipId,
        'device_name': deviceName,
      },
    );
  }

  Future<Response> logout() async {
    return await _apiService.dio.post(ApiConstants.logout);
  }

  Future<Response> getMe() async {
    return await _apiService.dio.get(ApiConstants.me);
  }

  Future<Response> updateFcmToken(String token) async {
    return await _apiService.dio.post(
      ApiConstants.saveFcmToken,
      data: {'token': token, 'device_type': 'android'},
    );
  }
}
