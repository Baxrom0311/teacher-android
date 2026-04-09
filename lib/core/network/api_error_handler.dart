import 'package:dio/dio.dart';

import '../constants/app_strings.dart';
import '../localization/app_localizations.dart';

class ApiErrorHandler {
  ApiErrorHandler._();

  static String handleError(Object error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return AppLocalizationsRegistry.instance.requestTimeout;

        case DioExceptionType.connectionError:
          return AppStrings.noInternet;

        case DioExceptionType.badResponse:
          return _handleStatusCode(error.response);

        case DioExceptionType.cancel:
          return AppLocalizationsRegistry.instance.requestCancelled;

        default:
          return AppStrings.errorGeneric;
      }
    }

    return readableMessage(error);
  }

  static Never throwAsException(
    Object error,
    StackTrace stackTrace, {
    String? fallback,
  }) {
    final message = error is DioException
        ? handleError(error)
        : readableMessage(error, fallback: fallback);

    Error.throwWithStackTrace(Exception(message), stackTrace);
  }

  static String readableMessage(Object? error, {String? fallback}) {
    final effectiveFallback = fallback ?? AppStrings.errorGeneric;

    if (error == null) return effectiveFallback;
    if (error is DioException) return handleError(error);

    final rawMessage = error is String ? error : error.toString();
    final normalized = _normalizeMessage(rawMessage);

    if (normalized.isEmpty) {
      return effectiveFallback;
    }

    switch (normalized) {
      case 'An unexpected error occurred':
      case 'An unexpected error occurred.':
        return effectiveFallback;
      case 'Failed to fetch user profile':
        return AppLocalizationsRegistry.instance.failedFetchProfile;
      case 'Failed to load options':
        return AppLocalizationsRegistry.instance.failedLoadOptions;
    }

    if (normalized.startsWith('Offline: ')) {
      return normalized.replaceFirst('Offline: ', '');
    }

    return normalized;
  }

  static bool isOfflineError(Object? error) {
    if (error is DioException) {
      return isNetworkError(error);
    }

    final rawMessage = error is String ? error : error?.toString() ?? '';
    if (rawMessage.startsWith('Offline: ')) {
      return true;
    }

    return readableMessage(error) == AppStrings.noInternet;
  }

  static String _handleStatusCode(Response? response) {
    if (response == null) return AppStrings.errorServer;

    final statusCode = response.statusCode;
    final data = response.data;

    switch (statusCode) {
      case 401:
        return AppStrings.errorAuth;
      case 403:
        return AppLocalizationsRegistry.instance.forbidden;
      case 404:
        return AppLocalizationsRegistry.instance.notFound;
      case 429:
        return AppLocalizationsRegistry.instance.requestTimeout;
    }

    if (statusCode == 422) {
      return _extractValidationErrors(data) ?? AppStrings.errorGeneric;
    }

    if (data is Map<String, dynamic>) {
      final message = data['message'] ?? data['error'];
      if (message != null && message is String && message.isNotEmpty) {
        return readableMessage(message);
      }
    }

    switch (statusCode) {
      case 400:
        return AppLocalizationsRegistry.instance.badRequest;
      case 500:
        return AppStrings.errorServer;
      default:
        return AppStrings.errorGeneric;
    }
  }

  static String? _extractValidationErrors(dynamic data) {
    if (data is! Map<String, dynamic>) return null;

    final errors = data['errors'];
    if (errors is Map<String, dynamic> && errors.isNotEmpty) {
      final messages = <String>[];
      for (final entry in errors.entries) {
        if (entry.value is List) {
          for (final msg in entry.value) {
            if (msg is String && msg.isNotEmpty) {
              messages.add(msg);
            }
          }
        }
      }
      if (messages.isNotEmpty) {
        return messages.join('\n');
      }
    }

    final message = data['message'];
    if (message is String && message.isNotEmpty) {
      return message;
    }

    return null;
  }

  static String _normalizeMessage(String rawMessage) {
    var message = rawMessage.trim();

    if (message.isEmpty || message == 'null') {
      return '';
    }

    message = message.replaceFirst(RegExp(r'^[A-Za-z_ ]*Exception:\s*'), '');
    message = message.replaceFirst(RegExp(r'^[A-Za-z_ ]*Error:\s*'), '');
    message = message.replaceFirst('Bad state: ', '');
    message = message.replaceFirst('Invalid argument(s): ', '');

    return message.trim();
  }

  static bool isNetworkError(DioException error) {
    return error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout;
  }
}
