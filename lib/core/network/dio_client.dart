import 'package:dio/dio.dart';
import 'api_service.dart';

/// Adapter class to maintain compatibility with repositories expecting [DioClient].
/// It wraps the existing [ApiService] and exposes its [Dio] instance.
class DioClient {
  final ApiService _apiService;

  DioClient(this._apiService);

  /// Returns the underlying [Dio] instance from [ApiService].
  Dio get dio => _apiService.dio;
}
