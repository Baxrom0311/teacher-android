import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_service.dart';

class GradesApi {
  final ApiService _apiService;

  GradesApi(this._apiService);

  Future<Response> getQuarterGrades({
    int page = 1,
    String? search,
    int? groupId,
    int? subjectId,
    int? quarterId,
  }) async {
    return await _apiService.dio.get(
      ApiConstants.gradesQuarter,
      queryParameters: {
        'page': page,
        if (search != null && search.isNotEmpty) 'q': search,
        if (groupId != null) 'group_id': groupId,
        if (subjectId != null) 'subject_id': subjectId,
        if (quarterId != null) 'quarter_id': quarterId,
      },
    );
  }

  Future<Response> getYearGrades({
    int page = 1,
    String? search,
    int? groupId,
    int? subjectId,
  }) async {
    return await _apiService.dio.get(
      ApiConstants.gradesYear,
      queryParameters: {
        'page': page,
        if (search != null && search.isNotEmpty) 'q': search,
        if (groupId != null) 'group_id': groupId,
        if (subjectId != null) 'subject_id': subjectId,
      },
    );
  }
}
