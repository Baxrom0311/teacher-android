import '../../core/network/api_error_handler.dart';
import '../datasources/remote/dashboard_api.dart';
import '../models/dashboard_model.dart';

class DashboardRepository {
  final DashboardApi _api;

  DashboardRepository(this._api);

  Future<TeacherDashboardResponse> fetchDashboard() async {
    try {
      final response = await _api.getDashboard();
      return TeacherDashboardResponse.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );
    } catch (error, stackTrace) {
      ApiErrorHandler.throwAsException(error, stackTrace);
    }
  }
}
