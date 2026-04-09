import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_service.dart';

class AssessmentApi {
  final ApiService _apiService;

  AssessmentApi(this._apiService);

  Future<Response> getAssessments({
    int page = 1,
    int? quarterId,
    int? yearId,
  }) async {
    return await _apiService.dio.get(
      ApiConstants.assessments,
      queryParameters: {
        'page': page,
        if (quarterId != null) 'quarter_id': quarterId,
        if (yearId != null) 'year_id': yearId,
      },
    );
  }

  Future<Response> getAssessmentOptions({int? yearId, int? quarterId}) async {
    return await _apiService.dio.get(
      ApiConstants.assessmentOptions,
      queryParameters: {
        if (yearId != null) 'year_id': yearId,
        if (quarterId != null) 'quarter_id': quarterId,
      },
    );
  }

  Future<Response> createAssessment(Map<String, dynamic> data) async {
    return await _apiService.dio.post(ApiConstants.assessments, data: data);
  }

  Future<Response> updateAssessment(int id, Map<String, dynamic> data) async {
    return await _apiService.dio.put(
      ApiConstants.assessmentDetail(id),
      data: data,
    );
  }

  Future<Response> deleteAssessment(int id) async {
    return await _apiService.dio.delete(ApiConstants.assessmentDetail(id));
  }

  Future<Response> getAssessmentResults(int id) async {
    return await _apiService.dio.get(ApiConstants.assessmentResults(id));
  }

  Future<Response> saveAssessmentResults(
    int id,
    Map<String, dynamic> data,
  ) async {
    return await _apiService.dio.post(
      ApiConstants.assessmentResults(id),
      data:
          data, // format: { 'score': { 1: 95, 2: 88 }, 'comment': { 1: 'Good', 2: '' } }
    );
  }
}
