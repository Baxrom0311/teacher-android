import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_service.dart';

class SubjectApi {
  final ApiService _apiService;

  SubjectApi(this._apiService);

  Future<Response> getSubjects() async {
    return await _apiService.dio.get(ApiConstants.subjects);
  }

  Future<Response> getSubjectDetail(int id) async {
    return await _apiService.dio.get(ApiConstants.subjectDetail(id));
  }

  Future<Response> createTopic(int subjectId, FormData data) async {
    return await _apiService.dio.post(
      ApiConstants.subjectTopics(subjectId),
      data: data,
      options: Options(headers: {'Content-Type': 'multipart/form-data'}),
    );
  }

  Future<Response> addTopicResources(
    int subjectId,
    int topicId,
    FormData data,
  ) async {
    return await _apiService.dio.post(
      ApiConstants.topicResources(subjectId, topicId),
      data: data,
      options: Options(headers: {'Content-Type': 'multipart/form-data'}),
    );
  }
}
