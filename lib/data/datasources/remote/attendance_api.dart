import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_service.dart';

class AttendanceApi {
  final ApiService _apiService;

  AttendanceApi(this._apiService);

  Future<Response> getAttendanceSessions(int quarterId, String date) async {
    return await _apiService.dio.get(
      ApiConstants.attendances,
      queryParameters: {'quarter_id': quarterId, 'date': date},
    );
  }

  Future<Response> createAttendance(
    int quarterId,
    int timetableEntryId,
    String date,
    List<Map<String, dynamic>> rows, {
    String? clientActionId,
  }) async {
    return await _apiService.dio.post(
      ApiConstants.attendances,
      data: {
        'quarter_id': quarterId,
        'timetable_entry_id': timetableEntryId,
        'date': date,
        'rows': rows,
      },
      options: clientActionId == null
          ? null
          : Options(headers: {'X-Client-Action-Id': clientActionId}),
    );
  }

  Future<Response> getAttendanceOptions() async {
    return await _apiService.dio.get(ApiConstants.attendanceOptions);
  }

  Future<Response> getAttendanceDetail(int id) async {
    return await _apiService.dio.get(ApiConstants.attendanceDetail(id));
  }

  Future<Response> updateAttendance(
    int id,
    List<Map<String, dynamic>> rows,
  ) async {
    return await _apiService.dio.post(
      ApiConstants.attendanceDetail(id),
      data: {'rows': rows},
    );
  }

  Future<Response> getAbsenceExcuses({String? status}) async {
    return await _apiService.dio.get(
      '/api/excuses',
      queryParameters: {if (status != null) 'status': status},
    );
  }

  Future<Response> reviewExcuse(int id, String status) async {
    return await _apiService.dio.post(
      '/api/teacher/excuses/$id/review',
      data: {'status': status},
    );
  }
}
