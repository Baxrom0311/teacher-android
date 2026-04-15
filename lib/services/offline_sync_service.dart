import 'dart:convert';
import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Models an offline action ready to be pushed to the server.
class OfflineSyncAction {
  final String type; // 'attendance' or 'grade'
  final Map<String, dynamic> payload;
  final String offlineTimestamp;

  OfflineSyncAction({
    required this.type,
    required this.payload,
    required this.offlineTimestamp,
  });

  Map<String, dynamic> toJson() => {
        'type': type,
        'payload': payload,
        'offline_timestamp': offlineTimestamp,
      };

  factory OfflineSyncAction.fromJson(Map<String, dynamic> json) {
    return OfflineSyncAction(
      type: json['type'],
      payload: Map<String, dynamic>.from(json['payload']),
      offlineTimestamp: json['offline_timestamp'],
    );
  }
}

class OfflineSyncService {
  final DioClient _dioClient;
  static const String _syncKey = 'offline_pending_actions';

  OfflineSyncService(this._dioClient);

  /// Called locally when the app is offline and a teacher marks attendance or grades.
  Future<void> queueOfflineAction(OfflineSyncAction action) async {
    final prefs = await SharedPreferences.getInstance();
    final actionString = prefs.getString(_syncKey);
    List<dynamic> actionsArray = actionString != null ? jsonDecode(actionString) : [];

    actionsArray.add(action.toJson());

    await prefs.setString(_syncKey, jsonEncode(actionsArray));
  }

  /// Push all queued offline actions to the backend when internet is restored.
  Future<bool> pushPendingActions() async {
    final prefs = await SharedPreferences.getInstance();
    final actionString = prefs.getString(_syncKey);
    
    if (actionString == null) return true;

    List<dynamic> actionsArray = jsonDecode(actionString);
    if (actionsArray.isEmpty) return true;

    try {
      final response = await _dioClient.dio.post(
        '/api/v1/sync/push',
        data: {'actions': actionsArray},
      );

      if (response.statusCode == 200) {
        // Clear the queue on success
        await prefs.remove(_syncKey);
        return true;
      }
    } catch (e) {
      // Keep in queue if backend failed
    }

    return false;
  }

  /// Pull latest changes from the backend to cache locally.
  Future<void> pullLatestData(String lastSyncDate) async {
    try {
      final response = await _dioClient.dio.get(
        '/api/v1/sync/pull',
        queryParameters: {'last_sync': lastSyncDate},
      );

      final data = response.data['data'];
      // TODO: Save 'data' to local SQLite / Hive for offline use.
    } catch (e) {
      // Ignore
    }
  }
}
