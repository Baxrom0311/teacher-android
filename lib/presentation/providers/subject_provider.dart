import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/remote/subject_api.dart';
import '../../data/repositories/subject_repository.dart';
import 'auth_provider.dart';

final subjectApiProvider = Provider<SubjectApi>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return SubjectApi(apiService);
});

final subjectRepositoryProvider = Provider<SubjectRepository>((ref) {
  final api = ref.watch(subjectApiProvider);
  return SubjectRepository(api);
});

final subjectsListProvider = FutureProvider.autoDispose<Map<String, dynamic>>((
  ref,
) async {
  final repository = ref.watch(subjectRepositoryProvider);
  return repository.fetchSubjects();
});

final subjectDetailProvider = FutureProvider.family
    .autoDispose<Map<String, dynamic>, int>((ref, subjectId) async {
      final repository = ref.watch(subjectRepositoryProvider);
      return repository.fetchSubjectDetail(subjectId);
    });

class SubjectController extends StateNotifier<AsyncValue<void>> {
  final SubjectRepository _repository;

  SubjectController(this._repository) : super(const AsyncValue.data(null));

  Future<bool> createTopic(
    int subjectId,
    int groupSubjectId,
    String title,
    String? description,
    List<String> filePaths,
  ) async {
    state = const AsyncValue.loading();
    try {
      await _repository.createTopic(
        subjectId,
        groupSubjectId,
        title,
        description,
        filePaths,
      );
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

final subjectControllerProvider =
    StateNotifierProvider.autoDispose<SubjectController, AsyncValue<void>>((
      ref,
    ) {
      final repository = ref.watch(subjectRepositoryProvider);
      return SubjectController(repository);
    });
