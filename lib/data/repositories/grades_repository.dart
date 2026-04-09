import '../../core/network/api_error_handler.dart';
import '../datasources/remote/grades_api.dart';
import '../models/grades_model.dart';

class GradesRepository {
  final GradesApi _api;

  GradesRepository(this._api);

  Future<GradesResponse> fetchQuarterGrades({
    int page = 1,
    String? search,
    int? groupId,
    int? subjectId,
    int? quarterId,
  }) async {
    try {
      final response = await _api.getQuarterGrades(
        page: page,
        search: search,
        groupId: groupId,
        subjectId: subjectId,
        quarterId: quarterId,
      );
      return GradesResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      ApiErrorHandler.throwAsException(error, stackTrace);
    }
  }

  Future<GradesResponse> fetchYearGrades({
    int page = 1,
    String? search,
    int? groupId,
    int? subjectId,
  }) async {
    try {
      final response = await _api.getYearGrades(
        page: page,
        search: search,
        groupId: groupId,
        subjectId: subjectId,
      );
      return GradesResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      ApiErrorHandler.throwAsException(error, stackTrace);
    }
  }
}
