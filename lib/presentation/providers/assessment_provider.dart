import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/remote/assessment_api.dart';
import '../../data/repositories/assessment_repository.dart';
import 'auth_provider.dart';

final assessmentApiProvider = Provider<AssessmentApi>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return AssessmentApi(apiService);
});

final assessmentRepositoryProvider = Provider<AssessmentRepository>((ref) {
  final api = ref.watch(assessmentApiProvider);
  return AssessmentRepository(api);
});

final assessmentsListProvider = FutureProvider.family
    .autoDispose<Map<String, dynamic>, Map<String, dynamic>>((
      ref,
      params,
    ) async {
      final repository = ref.watch(assessmentRepositoryProvider);
      final page = params['page'] ?? 1;
      final quarterId = params['quarter_id'];
      return repository.fetchAssessments(page: page, quarterId: quarterId);
    });

final assessmentOptionsProvider = FutureProvider.family
    .autoDispose<Map<String, dynamic>, Map<String, dynamic>>((
      ref,
      params,
    ) async {
      final repository = ref.watch(assessmentRepositoryProvider);
      final yearId = params['year_id'];
      final quarterId = params['quarter_id'];
      return repository.fetchAssessmentOptions(
        yearId: yearId,
        quarterId: quarterId,
      );
    });

final assessmentResultsProvider = FutureProvider.family
    .autoDispose<Map<String, dynamic>, int>((ref, id) async {
      final repository = ref.watch(assessmentRepositoryProvider);
      return repository.fetchAssessmentResults(id);
    });

class AssessmentController extends StateNotifier<AsyncValue<void>> {
  final AssessmentRepository _repository;

  AssessmentController(this._repository) : super(const AsyncValue.data(null));

  Future<bool> saveAssessment(Map<String, dynamic> data, {int? id}) async {
    state = const AsyncValue.loading();
    try {
      if (id != null) {
        await _repository.updateAssessment(id, data);
      } else {
        await _repository.createAssessment(data);
      }
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> deleteAssessment(int id) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteAssessment(id);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> saveResults(
    int assessmentId,
    Map<String, num?> scores,
    Map<String, String?> comments,
  ) async {
    state = const AsyncValue.loading();
    try {
      await _repository.saveAssessmentResults(assessmentId, scores, comments);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

final assessmentControllerProvider =
    StateNotifierProvider.autoDispose<AssessmentController, AsyncValue<void>>((
      ref,
    ) {
      final repository = ref.watch(assessmentRepositoryProvider);
      return AssessmentController(repository);
    });
