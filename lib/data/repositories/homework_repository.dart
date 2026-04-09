import '../datasources/remote/homework_api.dart';
import '../models/homework_model.dart';
import './base_repository.dart';

class HomeworkRepository extends BaseRepository {
  final HomeworkApi _api;

  HomeworkRepository(this._api);

  Future<List<LessonHomework>> fetchLessonHomeworks(
    int quarterId, {
    String? date,
  }) async {
    return safeCallList(
      () => _api.getLessonHomeworks(quarterId, date: date),
      (json) => LessonHomework.fromJson(json),
      listKey: 'homeworks',
    );
  }

  Future<LessonHomework> createLessonHomework(
    int sessionId,
    String title,
    String? description,
    String? dueDate,
  ) async {
    return safeCall(
      () => _api.createLessonHomework(sessionId, {
        'title': title,
        'description': description,
        'due_date': dueDate,
      }),
      (json) => LessonHomework.fromJson(json['homework']),
    );
  }

  Future<List<StudentHomework>> fetchHomeworkSubmissions(
    int lessonHomeworkId,
  ) async {
    return safeCallList(
      () => _api.getHomeworkSubmissions(lessonHomeworkId),
      (json) => StudentHomework.fromJson(json),
      listKey: 'submissions',
    );
  }

  Future<StudentHomework> gradeHomework(
    int studentHomeworkId,
    int grade, {
    String? comment,
  }) async {
    return safeCall(
      () => _api.gradeHomework(studentHomeworkId, grade, comment: comment),
      (json) => StudentHomework.fromJson(json),
    );
  }
}
