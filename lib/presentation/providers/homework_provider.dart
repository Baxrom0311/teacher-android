import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/remote/homework_api.dart';
import '../../data/models/homework_model.dart';
import '../../data/repositories/homework_repository.dart';
import 'auth_provider.dart';
import 'lesson_provider.dart';

final homeworkApiProvider = Provider<HomeworkApi>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return HomeworkApi(apiService);
});

final homeworkRepositoryProvider = Provider<HomeworkRepository>((ref) {
  final api = ref.watch(homeworkApiProvider);
  return HomeworkRepository(api);
});

final currentHomeworkQuarterIdProvider = Provider.autoDispose<int?>((ref) {
  final lessons = ref.watch(todayLessonsProvider);
  return lessons.valueOrNull?.quarterId;
});

// Provides list of assigned homeworks (e.g. for today or current quarter)
final lessonHomeworksProvider = FutureProvider.family
    .autoDispose<List<LessonHomework>, Map<String, dynamic>>((
      ref,
      params,
    ) async {
      final repository = ref.watch(homeworkRepositoryProvider);
      final quarterId = params['quarter_id'] as int;
      final date = params['date'] as String?;
      return repository.fetchLessonHomeworks(quarterId, date: date);
    });

// Provides submissions for a specific Assignment
final homeworkSubmissionsProvider = FutureProvider.family
    .autoDispose<List<StudentHomework>, int>((ref, lessonHomeworkId) async {
      final repository = ref.watch(homeworkRepositoryProvider);
      return repository.fetchHomeworkSubmissions(lessonHomeworkId);
    });

// Controller to handle Creation and Grading Mutations
class HomeworkController extends StateNotifier<AsyncValue<void>> {
  final HomeworkRepository _repository;

  HomeworkController(this._repository) : super(const AsyncValue.data(null));

  Future<bool> createHomework({
    required int sessionId,
    required String title,
    String? description,
    String? dueDate,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _repository.createLessonHomework(
        sessionId,
        title,
        description,
        dueDate,
      );
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> gradeSubmission(
    int studentHomeworkId,
    int grade,
    String? comment,
  ) async {
    state = const AsyncValue.loading();
    try {
      await _repository.gradeHomework(
        studentHomeworkId,
        grade,
        comment: comment,
      );
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

final homeworkControllerProvider =
    StateNotifierProvider.autoDispose<HomeworkController, AsyncValue<void>>((
      ref,
    ) {
      final repository = ref.watch(homeworkRepositoryProvider);
      return HomeworkController(repository);
    });
