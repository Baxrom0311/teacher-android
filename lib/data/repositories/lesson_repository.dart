import 'package:dio/dio.dart';
import '../../core/network/api_error_handler.dart';
import '../datasources/remote/lesson_api.dart';
import '../models/lesson_model.dart';
import '../../core/storage/outbox_service.dart';
import './base_repository.dart';

class LessonRepository extends BaseRepository {
  final LessonApi _api;
  final OutboxService _outbox;

  LessonRepository(this._api, this._outbox);

  Future<TodayLessonsResponse> fetchTodayLessons({int? quarterId}) async {
    return safeCall(
      () => _api.getTodayLessons(quarterId: quarterId),
      (data) => TodayLessonsResponse.fromJson(data),
    );
  }

  Future<int> startLesson(
    int timetableEntryId,
    int quarterId,
    String date,
  ) async {
    return safeCall(
      () => _api.startLesson(timetableEntryId, quarterId, date),
      (data) => data['session_id'] as int,
    );
  }

  Future<LessonSessionDetail> fetchLessonSession(int sessionId) async {
    return safeCall(
      () => _api.getLessonSession(sessionId),
      (data) => LessonSessionDetail.fromJson(data),
    );
  }

  Future<LessonSessionDetail> saveLessonSession(
    int sessionId,
    String? topic,
    List<LessonSessionRow> rows,
  ) async {
    final mappedRows = rows
        .map(
          (row) => {
            'student_id': row.studentId,
            'grade': row.grade,
            'coin': row.coin,
          },
        )
        .toList();

    try {
      final response = await _api.saveLessonSession(
        sessionId,
        topic,
        mappedRows,
      );
      return LessonSessionDetail.fromJson(response.data);
    } catch (error, stackTrace) {
      if (error is DioException && ApiErrorHandler.isNetworkError(error)) {
        await _outbox.queueAction(
          OutboxAction(
            id: 'lesson_save_${sessionId}_${DateTime.now().millisecondsSinceEpoch}',
            type: OutboxActionType.saveLessonResults,
            payload: {
              'session_id': sessionId,
              'topic': topic,
              'rows': mappedRows,
            },
            queuedAt: DateTime.now(),
          ),
        );
        ApiErrorHandler.throwAsException(
          'Offline: Natijalar saqlandi va internet ulanganda yuboriladi.',
          stackTrace,
        );
      }

      ApiErrorHandler.throwAsException(error, stackTrace);
    }
  }
}
