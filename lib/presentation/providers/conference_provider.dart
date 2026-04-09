import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/conference_repository.dart';
import 'auth_provider.dart';

final conferenceRepositoryProvider = Provider<ConferenceRepository>((ref) {
  final api = ref.watch(apiServiceProvider);
  return ConferenceRepository(api);
});

final teacherConferenceSlotsProvider = FutureProvider<List<dynamic>>((ref) {
  return ref.watch(conferenceRepositoryProvider).getMySlots();
});

class ConferenceCreateNotifier extends StateNotifier<AsyncValue<void>> {
  final ConferenceRepository _repository;
  final Ref _ref;

  ConferenceCreateNotifier(this._repository, this._ref)
    : super(const AsyncValue.data(null));

  Future<bool> createSlots({
    required List<Map<String, dynamic>> slots,
    String? location,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _repository.createSlots(slots: slots, location: location);
      state = const AsyncValue.data(null);
      _ref.invalidate(teacherConferenceSlotsProvider);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

final conferenceCreateControllerProvider =
    StateNotifierProvider<ConferenceCreateNotifier, AsyncValue<void>>((ref) {
      return ConferenceCreateNotifier(
        ref.watch(conferenceRepositoryProvider),
        ref,
      );
    });
