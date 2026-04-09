import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/remote/profile_api.dart';
import '../../data/repositories/profile_repository.dart';
import '../../data/models/profile_model.dart';
import 'auth_provider.dart';

final profileApiProvider = Provider<ProfileApi>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return ProfileApi(apiService);
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final api = ref.watch(profileApiProvider);
  return ProfileRepository(api);
});

final profileProvider = FutureProvider.autoDispose<ProfileResponse>((
  ref,
) async {
  final repository = ref.watch(profileRepositoryProvider);
  return repository.fetchProfile();
});

class ProfileController extends StateNotifier<AsyncValue<void>> {
  final ProfileRepository _repository;

  ProfileController(this._repository) : super(const AsyncValue.data(null));

  Future<bool> updateProfile({
    String? university,
    String? graduationDate,
    String? specialization,
    String? address,
    String? category,
    String? gender,
    String? achievements,
    String? photoPath,
    String? diplomaPath,
    String? passportCopyPath,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateProfile(
        university: university,
        graduationDate: graduationDate,
        specialization: specialization,
        address: address,
        category: category,
        gender: gender,
        achievements: achievements,
        photoPath: photoPath,
        diplomaPath: diplomaPath,
        passportCopyPath: passportCopyPath,
      );
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> addWork({
    required String title,
    String? publishedAt,
    String? publishedPlace,
    String? filePath,
    List<int> coauthorIds = const [],
  }) async {
    state = const AsyncValue.loading();
    try {
      await _repository.addWork(
        title: title,
        publishedAt: publishedAt,
        publishedPlace: publishedPlace,
        filePath: filePath,
        coauthorIds: coauthorIds,
      );
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> deleteWork(int id) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteWork(id);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

final profileControllerProvider =
    StateNotifierProvider.autoDispose<ProfileController, AsyncValue<void>>((
      ref,
    ) {
      final repository = ref.watch(profileRepositoryProvider);
      return ProfileController(repository);
    });
