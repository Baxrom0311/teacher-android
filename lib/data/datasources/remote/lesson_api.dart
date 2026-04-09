import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_service.dart';

class LessonApi {
  final ApiService _apiService;

  LessonApi(this._apiService);

  Future<Response> getTodayLessons({int? quarterId}) async {
    return await _apiService.dio.get(
      ApiConstants.todayLessons,
      queryParameters: quarterId != null ? {'quarter_id': quarterId} : null,
    );
  }

  Future<Response> startLesson(
    int timetableEntryId,
    int quarterId,
    String date,
  ) async {
    return await _apiService.dio.post(
      ApiConstants.startLesson(timetableEntryId),
      data: {'quarter_id': quarterId, 'date': date},
    );
  }

  Future<Response> getLessonSession(int sessionId) async {
    return await _apiService.dio.get(ApiConstants.lessonSession(sessionId));
  }

  Future<Response> saveLessonSession(
    int sessionId,
    String? topic,
    List<Map<String, dynamic>> rows,
  ) async {
    return await _apiService.dio.post(
      ApiConstants.saveLessonSession(sessionId),
      data: {'topic': topic, 'rows': rows},
    );
  }
}
