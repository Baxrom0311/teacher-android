import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_service.dart';

class AuthApi {
  final ApiService _apiService;

  AuthApi(this._apiService);

  Future<Response> login(
    String username,
    String password,
    String deviceName,
  ) async {
    return await _apiService.dio.post(
      ApiConstants.login,
      data: {
        'email': username,
        'password': password,
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
