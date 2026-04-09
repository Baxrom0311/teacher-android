import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_service.dart';

class EventApi {
  final ApiService _apiService;

  EventApi(this._apiService);

  Future<Response> getEvents({int perPage = 20}) async {
    return _apiService.dio.get(
      ApiConstants.events,
      queryParameters: {'per_page': perPage},
    );
  }
}
