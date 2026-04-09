import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_error_handler.dart';
import '../../data/datasources/remote/lesson_api.dart';
import '../../data/models/lesson_model.dart';
import '../../data/repositories/lesson_repository.dart';
import '../../core/storage/outbox_service.dart';
import 'auth_provider.dart';

// Providers
final lessonApiProvider = Provider<LessonApi>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return LessonApi(apiService);
});

final lessonRepositoryProvider = Provider<LessonRepository>((ref) {
  final api = ref.watch(lessonApiProvider);
  final outbox = ref.watch(outboxServiceProvider);
  return LessonRepository(api, outbox);
});

// FutureProvider for Today's Lessons
final todayLessonsProvider = FutureProvider.autoDispose<TodayLessonsResponse>((
  ref,
) async {
  final repository = ref.watch(lessonRepositoryProvider);
  return await repository.fetchTodayLessons();
});

// StateNotifier for a specific Lesson Session
class LessonSessionState {
  final bool isLoading;
  final String? error;
  final LessonSessionDetail? detail;

  LessonSessionState({this.isLoading = false, this.error, this.detail});

  LessonSessionState copyWith({
    bool? isLoading,
    String? error,
    LessonSessionDetail? detail,
  }) {
    return LessonSessionState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      detail: detail ?? this.detail,
    );
  }
}

class LessonSessionController extends StateNotifier<LessonSessionState> {
  final LessonRepository _repository;
  final int sessionId;

  LessonSessionController(this._repository, this.sessionId)
    : super(LessonSessionState(isLoading: true)) {
    loadSession();
  }

  Future<void> loadSession() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final detail = await _repository.fetchLessonSession(sessionId);
      state = state.copyWith(isLoading: false, detail: detail);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: ApiErrorHandler.readableMessage(e),
      );
    }
  }

  void updateRowGrade(int studentId, int? grade) {
    if (state.detail == null) return;

    final updatedRows = state.detail!.rows.map((row) {
      if (row.studentId == studentId) {
        return row.copyWith(grade: grade);
      }
      return row;
    }).toList();

    state = state.copyWith(
      detail: LessonSessionDetail(
        gradingMode: state.detail!.gradingMode,
        session: state.detail!.session,
        rows: updatedRows,
        topics: state.detail!.topics,
      ),
    );
  }

  void updateRowCoin(int studentId, int? coin) {
    if (state.detail == null) return;

    final updatedRows = state.detail!.rows.map((row) {
      if (row.studentId == studentId) {
        return row.copyWith(coin: coin);
      }
      return row;
    }).toList();

    state = state.copyWith(
      detail: LessonSessionDetail(
        gradingMode: state.detail!.gradingMode,
        session: state.detail!.session,
        rows: updatedRows,
        topics: state.detail!.topics,
      ),
    );
  }

  Future<bool> saveSession(String? topic) async {
    if (state.detail == null) return false;

    state = state.copyWith(isLoading: true, error: null);
    try {
      final updatedDetail = await _repository.saveLessonSession(
        sessionId,
        topic,
        state.detail!.rows,
      );
      state = state.copyWith(isLoading: false, detail: updatedDetail);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: ApiErrorHandler.readableMessage(e),
      );
      return false;
    }
  }
}

// AutoDispose Family provider to allow multiple sessions or cleanup when leaving
final lessonSessionControllerProvider = StateNotifierProvider.family
    .autoDispose<LessonSessionController, LessonSessionState, int>((
      ref,
      sessionId,
    ) {
      final repository = ref.watch(lessonRepositoryProvider);
      return LessonSessionController(repository, sessionId);
    });
