import 'package:flutter/foundation.dart';

import '../../core/network/api_error_handler.dart';
import '../datasources/remote/notification_api.dart';
import '../models/notification_model.dart';

class NotificationRepository {
  final NotificationApi _api;

  NotificationRepository(this._api);

  Future<NotificationsResponse> fetchNotifications({int page = 1}) async {
    try {
      final response = await _api.getNotifications(page: page);
      return NotificationsResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      ApiErrorHandler.throwAsException(error, stackTrace);
    }
  }

  Future<bool> markAsRead(String id) async {
    try {
      await _api.markAsRead(id);
      return true;
    } catch (e) {
      if (kDebugMode) print('Error marking notification as read: $e');
      return false;
    }
  }

  Future<bool> saveFcmToken(
    String token, {
    String deviceType = 'android',
  }) async {
    try {
      await _api.saveFcmToken(token, deviceType: deviceType);
      return true;
    } catch (e) {
      if (kDebugMode) print('Error saving FCM token: $e');
      return false;
    }
  }
}
