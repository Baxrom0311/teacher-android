import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_service.dart';

class NotificationApi {
  final ApiService _apiService;

  NotificationApi(this._apiService);

  Future<Response> getNotifications({int page = 1}) async {
    return await _apiService.dio.get(
      ApiConstants.notifications,
      queryParameters: {'page': page},
    );
  }

  Future<Response> markAsRead(String id) async {
    return await _apiService.dio.post(
      ApiConstants.markNotificationAsRead(int.tryParse(id) ?? 0),
    );
  }

  Future<Response> saveFcmToken(
    String token, {
    String deviceType = 'android',
  }) async {
    return await _apiService.dio.post(
      ApiConstants.saveFcmToken,
      data: {'fcm_token': token, 'device_type': deviceType},
    );
  }
}
