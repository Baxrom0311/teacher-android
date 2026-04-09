import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/remote/timetable_api.dart';
import '../../data/repositories/timetable_repository.dart';
import 'auth_provider.dart';

final timetableApiProvider = Provider<TimetableApi>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return TimetableApi(apiService);
});

final timetableRepositoryProvider = Provider<TimetableRepository>((ref) {
  final api = ref.watch(timetableApiProvider);
  return TimetableRepository(api);
});

final timetableProvider = FutureProvider.family
    .autoDispose<Map<String, dynamic>, Map<String, dynamic>>((
      ref,
      params,
    ) async {
      final repository = ref.watch(timetableRepositoryProvider);
      return repository.fetchTimetable(
        quarterId: params['quarter_id'],
        date: params['date'],
        days: params['days'] ?? 7,
      );
    });
