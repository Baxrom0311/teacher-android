import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/remote/grades_api.dart';
import '../../data/repositories/grades_repository.dart';
import '../../data/models/grades_model.dart';
import 'auth_provider.dart';

final gradesApiProvider = Provider<GradesApi>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return GradesApi(apiService);
});

final gradesRepositoryProvider = Provider<GradesRepository>((ref) {
  final api = ref.watch(gradesApiProvider);
  return GradesRepository(api);
});

// Providers for Quarter Grades
final quarterGradesFilterProvider = StateProvider<Map<String, dynamic>>(
  (ref) => {
    'page': 1,
    'search': null,
    'groupId': null,
    'subjectId': null,
    'quarterId': null,
  },
);

final quarterGradesProvider = FutureProvider.autoDispose<GradesResponse>((
  ref,
) async {
  final repository = ref.watch(gradesRepositoryProvider);
  final filters = ref.watch(quarterGradesFilterProvider);

  return repository.fetchQuarterGrades(
    page: filters['page'] as int,
    search: filters['search'] as String?,
    groupId: filters['groupId'] as int?,
    subjectId: filters['subjectId'] as int?,
    quarterId: filters['quarterId'] as int?,
  );
});

// Providers for Year Grades
final yearGradesFilterProvider = StateProvider<Map<String, dynamic>>(
  (ref) => {'page': 1, 'search': null, 'groupId': null, 'subjectId': null},
);

final yearGradesProvider = FutureProvider.autoDispose<GradesResponse>((
  ref,
) async {
  final repository = ref.watch(gradesRepositoryProvider);
  final filters = ref.watch(yearGradesFilterProvider);

  return repository.fetchYearGrades(
    page: filters['page'] as int,
    search: filters['search'] as String?,
    groupId: filters['groupId'] as int?,
    subjectId: filters['subjectId'] as int?,
  );
});
