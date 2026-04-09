import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_service.dart';

class HomeworkApi {
  final ApiService _apiService;

  HomeworkApi(this._apiService);

  // Get list of homeworks assigned by the teacher
  Future<Response> getLessonHomeworks(int quarterId, {String? date}) async {
    return await _apiService.dio.get(
      ApiConstants.homeworksList,
      queryParameters: {
        'quarter_id': quarterId,
        if (date != null) 'date': date,
      },
    );
  }

  // Create a new homework assignment
  Future<Response> createLessonHomework(
    int sessionId,
    Map<String, dynamic> data,
  ) async {
    return await _apiService.dio.post(
      ApiConstants.saveLessonHomework(sessionId),
      data: data,
    );
  }

  // Get submissions for a specific homework assignment
  Future<Response> getHomeworkSubmissions(int lessonHomeworkId) async {
    return await _apiService.dio.get(
      ApiConstants.homeworksList,
      queryParameters: {'lesson_homework_id': lessonHomeworkId},
    );
  }

  // Grade a specific student's submission
  Future<Response> gradeHomework(
    int studentHomeworkId,
    int grade, {
    String? comment,
  }) async {
    return await _apiService.dio.post(
      ApiConstants.gradeHomework(studentHomeworkId),
      data: {'grade': grade, if (comment != null) 'comment': comment},
    );
  }
}
