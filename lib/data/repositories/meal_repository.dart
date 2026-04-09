import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/network/api_error_handler.dart';
import '../datasources/remote/meal_api.dart';
import '../models/meal_model.dart';

class MealRepository {
  final MealApi _api;

  MealRepository(this._api);

  Future<MealIndexResponse> fetchMeals({int? groupId, String? mealType}) async {
    try {
      final response = await _api.getMeals(
        groupId: groupId,
        mealType: mealType,
      );
      return MealIndexResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      ApiErrorHandler.throwAsException(error, stackTrace);
    }
  }

  Future<bool> storeMeal({
    required int groupId,
    required String mealType,
    required String mealName,
    String? recipe,
    List<XFile>? files,
  }) async {
    try {
      final formData = FormData.fromMap({
        'group_id': groupId,
        'meal_type': mealType,
        'meal_name': mealName,
        if (recipe != null) 'recipe': recipe,
      });

      if (files != null && files.isNotEmpty) {
        for (int i = 0; i < files.length; i++) {
          formData.files.add(
            MapEntry(
              'files[$i]',
              await MultipartFile.fromFile(
                files[i].path,
                filename: files[i].name,
              ),
            ),
          );
        }
      }

      await _api.storeMealReport(formData);
      return true;
    } catch (error, stackTrace) {
      ApiErrorHandler.throwAsException(error, stackTrace);
    }
  }
}
