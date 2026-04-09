import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_service.dart';

class MealApi {
  final ApiService _apiService;

  MealApi(this._apiService);

  Future<Response> getMeals({int? groupId, String? mealType}) async {
    return await _apiService.dio.get(
      ApiConstants.meals,
      queryParameters: {
        if (groupId != null && groupId > 0) 'group_id': groupId,
        if (mealType != null) 'meal_type': mealType,
      },
    );
  }

  Future<Response> storeMealReport(FormData data) async {
    return await _apiService.dio.post(ApiConstants.meals, data: data);
  }
}
