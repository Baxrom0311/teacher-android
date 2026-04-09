import 'package:dio/dio.dart';
import '../../core/network/api_error_handler.dart';

abstract class BaseRepository {
  /// Safely executes an API call and handles error mapping.
  Future<T> safeCall<T>(
    Future<Response> Function() call,
    T Function(dynamic data) mapper,
  ) async {
    try {
      final response = await call();
      return mapper(response.data);
    } catch (error, stackTrace) {
      ApiErrorHandler.throwAsException(error, stackTrace);
    }
  }

  /// Same as [safeCall] but for list responses with a nested 'data' or 'sessions' key.
  Future<List<T>> safeCallList<T>(
    Future<Response> Function() call,
    T Function(dynamic data) mapper, {
    String? listKey,
  }) async {
    try {
      final response = await call();
      var data = response.data;

      List? list;
      if (listKey != null) {
        list = data[listKey] as List?;
      } else if (data is List) {
        list = data;
      } else if (data is Map) {
        list = (data['data'] ?? data['sessions'] ?? data['items']) as List?;
      }

      return (list ?? []).map((e) => mapper(e)).toList();
    } catch (error, stackTrace) {
      ApiErrorHandler.throwAsException(error, stackTrace);
    }
  }
}
