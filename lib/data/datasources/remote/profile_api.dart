import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_service.dart';

class ProfileApi {
  final ApiService _apiService;

  ProfileApi(this._apiService);

  Future<Response> getProfile() async {
    return await _apiService.dio.get(ApiConstants.profile);
  }

  Future<Response> lookupCoauthors(String passportNo) async {
    return await _apiService.dio.get(
      ApiConstants.profileCoauthors,
      queryParameters: {'passport_no': passportNo},
    );
  }

  Future<Response> updateProfile(FormData data) async {
    return await _apiService.dio.post(
      ApiConstants.profile,
      data: data,
      options: Options(headers: {'Content-Type': 'multipart/form-data'}),
    );
  }

  Future<Response> addWork(FormData data) async {
    return await _apiService.dio.post(
      ApiConstants.profileWorks,
      data: data,
      options: Options(headers: {'Content-Type': 'multipart/form-data'}),
    );
  }

  Future<Response> deleteWork(int id) async {
    return await _apiService.dio.delete(ApiConstants.deleteWork(id));
  }
}
