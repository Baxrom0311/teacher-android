import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/remote/quiz_api.dart';
import '../../data/models/quiz_model.dart';
import 'auth_provider.dart';

final quizApiProvider = Provider<QuizApi>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return QuizApi(apiService);
});

// ─── Quiz List State ───

class TeacherQuizState {
  final bool isLoading;
  final String? error;
  final List<TeacherQuizModel> quizzes;

  const TeacherQuizState({
    this.isLoading = false,
    this.error,
    this.quizzes = const [],
  });

  TeacherQuizState copyWith({
    bool? isLoading,
    String? error,
    List<TeacherQuizModel>? quizzes,
  }) {
    return TeacherQuizState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      quizzes: quizzes ?? this.quizzes,
    );
  }
}

class TeacherQuizNotifier extends StateNotifier<TeacherQuizState> {
  final QuizApi _api;

  TeacherQuizNotifier(this._api) : super(const TeacherQuizState());

  Future<void> loadQuizzes() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final quizzes = await _api.getTeacherQuizzes();
      state = TeacherQuizState(quizzes: quizzes);
    } catch (e) {
      state = TeacherQuizState(error: e.toString());
    }
  }

  Future<bool> createQuiz(Map<String, dynamic> payload) async {
    try {
      await _api.createQuiz(payload);
      await loadQuizzes();
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  Future<void> toggleActive(int quizId) async {
    try {
      await _api.toggleActive(quizId);
      final updated = state.quizzes.map((q) {
        if (q.id == quizId) {
          return TeacherQuizModel(
            id: q.id,
            title: q.title,
            description: q.description,
            subjectName: q.subjectName,
            timeLimitMinutes: q.timeLimitMinutes,
            maxScore: q.maxScore,
            isActive: !q.isActive,
            attemptsCount: q.attemptsCount,
            availableFrom: q.availableFrom,
            availableUntil: q.availableUntil,
            createdAt: q.createdAt,
          );
        }
        return q;
      }).toList();
      state = state.copyWith(quizzes: updated);
    } catch (_) {}
  }
}

final teacherQuizProvider =
    StateNotifierProvider.autoDispose<TeacherQuizNotifier, TeacherQuizState>(
  (ref) {
    final api = ref.watch(quizApiProvider);
    return TeacherQuizNotifier(api);
  },
);

// ─── Quiz Results ───

class QuizResultsState {
  final bool isLoading;
  final String? error;
  final QuizResultModel? results;

  const QuizResultsState({this.isLoading = false, this.error, this.results});
}

class QuizResultsNotifier extends StateNotifier<QuizResultsState> {
  final QuizApi _api;

  QuizResultsNotifier(this._api) : super(const QuizResultsState());

  Future<void> loadResults(int quizId) async {
    state = const QuizResultsState(isLoading: true);
    try {
      final results = await _api.getQuizResults(quizId);
      state = QuizResultsState(results: results);
    } catch (e) {
      state = QuizResultsState(error: e.toString());
    }
  }
}

final quizResultsProvider =
    StateNotifierProvider.autoDispose<QuizResultsNotifier, QuizResultsState>(
  (ref) {
    final api = ref.watch(quizApiProvider);
    return QuizResultsNotifier(api);
  },
);
