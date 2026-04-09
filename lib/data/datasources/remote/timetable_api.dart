import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_service.dart';

class TimetableApi {
  final ApiService _apiService;

  TimetableApi(this._apiService);

  Future<Response> getTimetable({
    int? quarterId,
    String? date,
    int days = 7,
  }) async {
    return await _apiService.dio.get(
      ApiConstants.timetable,
      queryParameters: {
        if (quarterId != null) 'quarter_id': quarterId,
        if (date != null) 'date': date,
        'days': days,
      },
    );
  }
}
