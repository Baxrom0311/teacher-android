import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/remote/meal_api.dart';
import '../../data/repositories/meal_repository.dart';
import '../../data/models/meal_model.dart';
import 'auth_provider.dart';
import 'package:image_picker/image_picker.dart';

final mealApiProvider = Provider<MealApi>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return MealApi(apiService);
});

final mealRepositoryProvider = Provider<MealRepository>((ref) {
  final api = ref.watch(mealApiProvider);
  return MealRepository(api);
});

final mealIndexParamsProvider = StateProvider<Map<String, dynamic>>(
  (ref) => {'group_id': null, 'meal_type': null},
);

final mealsIndexProvider = FutureProvider.autoDispose<MealIndexResponse>((
  ref,
) async {
  final repository = ref.watch(mealRepositoryProvider);
  final params = ref.watch(mealIndexParamsProvider);

  return repository.fetchMeals(
    groupId: params['group_id'] as int?,
    mealType: params['meal_type'] as String?,
  );
});

class MealController extends StateNotifier<AsyncValue<void>> {
  final MealRepository _repository;

  MealController(this._repository) : super(const AsyncValue.data(null));

  Future<bool> storeMeal({
    required int groupId,
    required String mealType,
    required String mealName,
    String? recipe,
    List<XFile>? files,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _repository.storeMeal(
        groupId: groupId,
        mealType: mealType,
        mealName: mealName,
        recipe: recipe,
        files: files,
      );
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

final mealControllerProvider =
    StateNotifierProvider.autoDispose<MealController, AsyncValue<void>>((ref) {
      final repository = ref.watch(mealRepositoryProvider);
      return MealController(repository);
    });
