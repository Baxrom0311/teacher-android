import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_service.dart';

class DashboardApi {
  final ApiService _apiService;

  DashboardApi(this._apiService);

  Future<Response> getDashboard() async {
    return _apiService.dio.get(ApiConstants.dashboard);
  }
}
