import '../../models/quiz_model.dart';
import '../../../core/network/api_service.dart';

class QuizApi {
  final ApiService _apiService;

  QuizApi(this._apiService);

  Future<List<TeacherQuizModel>> getTeacherQuizzes({int page = 1}) async {
    final response = await _apiService.get(
      '/api/teacher/quizzes',
      queryParameters: {'page': page},
    );
    final data = response.data;
    final list = (data is Map ? data['data'] : data) as List? ?? [];
    return list
        .map((e) => TeacherQuizModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<Map<String, dynamic>> createQuiz(Map<String, dynamic> payload) async {
    final response = await _apiService.post('/api/teacher/quizzes', data: payload);
    return Map<String, dynamic>.from(response.data ?? {});
  }

  Future<QuizResultModel> getQuizResults(int quizId) async {
    final response = await _apiService.get('/api/teacher/quizzes/$quizId/results');
    return QuizResultModel.fromJson(Map<String, dynamic>.from(response.data ?? {}));
  }

  Future<void> toggleActive(int quizId) async {
    await _apiService.post('/api/teacher/quizzes/$quizId/toggle');
  }
}
