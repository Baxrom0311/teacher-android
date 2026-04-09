import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teacher_school_app/core/constants/app_strings.dart';
import 'package:teacher_school_app/core/network/api_error_handler.dart';

void main() {
  group('ApiErrorHandler', () {
    test('localizes unauthenticated bad response', () {
      final requestOptions = RequestOptions(path: '/api/me');
      final error = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: requestOptions,
          statusCode: 401,
          data: {'message': 'Unauthenticated.'},
        ),
      );

      expect(ApiErrorHandler.handleError(error), AppStrings.errorAuth);
    });

    test('returns validation errors for 422 response', () {
      final requestOptions = RequestOptions(path: '/api/profile');
      final error = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: requestOptions,
          statusCode: 422,
          data: {
            'errors': {
              'title': ['Sarlavha majburiy'],
              'file': ['Fayl formati noto\'g\'ri'],
            },
          },
        ),
      );

      expect(
        ApiErrorHandler.handleError(error),
        'Sarlavha majburiy\nFayl formati noto\'g\'ri',
      );
    });

    test('normalizes generic exception text', () {
      expect(
        ApiErrorHandler.readableMessage(Exception('Server bilan aloqa uzildi')),
        'Server bilan aloqa uzildi',
      );
    });

    test('maps legacy english fallback to generic localized message', () {
      expect(
        ApiErrorHandler.readableMessage('An unexpected error occurred'),
        AppStrings.errorGeneric,
      );
    });

    test('detects offline errors from dio and queued action text', () {
      final requestOptions = RequestOptions(path: '/api/attendance');
      final dioError = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.connectionError,
      );

      expect(ApiErrorHandler.isOfflineError(dioError), isTrue);
      expect(
        ApiErrorHandler.readableMessage(
          'Offline: Natijalar saqlandi va internet ulanganda yuboriladi.',
        ),
        'Natijalar saqlandi va internet ulanganda yuboriladi.',
      );
      expect(
        ApiErrorHandler.isOfflineError(
          'Offline: Natijalar saqlandi va internet ulanganda yuboriladi.',
        ),
        isTrue,
      );
    });
  });
}
