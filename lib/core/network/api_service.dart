import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/api_constants.dart';

class ApiService {
  late final Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  bool _isClearingSession = false;
  final List<Completer<void>> _pendingRequests = [];
  final VoidCallback? onUnauthorized;

  ApiService({this.onUnauthorized}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: ApiConstants.defaultHeaders,
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final skipAuth = options.extra['skipAuth'] == true;
          if (skipAuth) {
            options.headers.remove('Authorization');
            return handler.next(options);
          }

          final token = await _storage.read(key: 'auth_token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401) {
            final requestOptions = error.requestOptions;
            final isRefreshReq = requestOptions.path == '/api/refresh';

            if (!isRefreshReq) {
              if (!_isClearingSession) {
                _isClearingSession = true;

                try {
                  // Attempt silent refresh
                  final oldToken = await _storage.read(key: 'auth_token');
                  final dioRefresh = Dio(
                    BaseOptions(
                      baseUrl: ApiConstants.baseUrl,
                      headers: ApiConstants.defaultHeaders,
                    ),
                  );

                  final refreshRes = await dioRefresh.post(
                    '/api/refresh',
                    options: Options(
                      headers: {
                        'Authorization': 'Bearer $oldToken',
                        'Accept': 'application/json',
                      },
                    ),
                  );

                  if (refreshRes.statusCode == 200 &&
                      refreshRes.data['token'] != null) {
                    final newToken = refreshRes.data['token'];
                    await _storage.write(key: 'auth_token', value: newToken);
                    _isClearingSession = false;

                    // Replay queued requests
                    for (var completer in _pendingRequests) {
                      completer.complete();
                    }
                    _pendingRequests.clear();

                    // Replay failed request
                    requestOptions.headers['Authorization'] =
                        'Bearer $newToken';
                    final response = await _dio.fetch(requestOptions);
                    return handler.resolve(response);
                  }
                } catch (e) {
                  // Refresh failed, proceed to local logout
                  for (var completer in _pendingRequests) {
                    completer.completeError(e);
                  }
                  _pendingRequests.clear();
                  await _storage.deleteAll();
                  onUnauthorized?.call();
                  return handler.next(error);
                } finally {
                  _isClearingSession = false;
                }
              } else {
                // Token is currently being refreshed, queue this request
                final completer = Completer<void>();
                _pendingRequests.add(completer);

                try {
                  await completer.future;
                  // Once refreshed, get the new token and retry
                  final newToken = await _storage.read(key: 'auth_token');
                  if (newToken != null && newToken.isNotEmpty) {
                    requestOptions.headers['Authorization'] =
                        'Bearer $newToken';
                  }
                  final response = await _dio.fetch(requestOptions);
                  return handler.resolve(response);
                } catch (e) {
                  // If refresh failed, let the error pass through
                  return handler.next(error);
                }
              }
            }
          }

          return handler.next(error);
        },
      ),
    );
  }

  Dio get dio => _dio;
}
