import 'package:dio/dio.dart';

import '../../core/network/api_error_handler.dart';
import '../datasources/remote/profile_api.dart';
import '../models/profile_model.dart';

class ProfileRepository {
  final ProfileApi _api;

  ProfileRepository(this._api);

  Future<ProfileResponse> fetchProfile() async {
    try {
      final response = await _api.getProfile();
      return ProfileResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      ApiErrorHandler.throwAsException(error, stackTrace);
    }
  }

  Future<TeacherProfileData> updateProfile({
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
    try {
      final formData = FormData.fromMap({
        if (university != null) 'university': university,
        if (graduationDate != null) 'graduation_date': graduationDate,
        if (specialization != null) 'specialization': specialization,
        if (address != null) 'address': address,
        if (category != null) 'category': category,
        if (gender != null) 'gender': gender,
        if (achievements != null) 'achievements': achievements,
      });

      if (photoPath != null && photoPath.isNotEmpty) {
        formData.files.add(
          MapEntry(
            'photo',
            await MultipartFile.fromFile(
              photoPath,
              filename: photoPath.split('/').last,
            ),
          ),
        );
      }

      if (diplomaPath != null && diplomaPath.isNotEmpty) {
        formData.files.add(
          MapEntry(
            'diploma',
            await MultipartFile.fromFile(
              diplomaPath,
              filename: diplomaPath.split('/').last,
            ),
          ),
        );
      }

      if (passportCopyPath != null && passportCopyPath.isNotEmpty) {
        formData.files.add(
          MapEntry(
            'passport_copy',
            await MultipartFile.fromFile(
              passportCopyPath,
              filename: passportCopyPath.split('/').last,
            ),
          ),
        );
      }

      final response = await _api.updateProfile(formData);
      return TeacherProfileData.fromJson(
        Map<String, dynamic>.from(response.data['profile'] as Map? ?? const {}),
      );
    } catch (error, stackTrace) {
      ApiErrorHandler.throwAsException(error, stackTrace);
    }
  }

  Future<ScientificWorkData> addWork({
    required String title,
    String? publishedAt,
    String? publishedPlace,
    String? filePath,
    List<int> coauthorIds = const [],
  }) async {
    try {
      final formData = FormData();
      formData.fields.add(MapEntry('title', title));

      if (publishedAt != null && publishedAt.isNotEmpty) {
        formData.fields.add(MapEntry('published_at', publishedAt));
      }

      if (publishedPlace != null && publishedPlace.isNotEmpty) {
        formData.fields.add(MapEntry('published_place', publishedPlace));
      }

      for (final id in coauthorIds) {
        formData.fields.add(MapEntry('coauthors[]', id.toString()));
      }

      if (filePath != null && filePath.isNotEmpty) {
        formData.files.add(
          MapEntry(
            'work_file',
            await MultipartFile.fromFile(
              filePath,
              filename: filePath.split('/').last,
            ),
          ),
        );
      }

      final response = await _api.addWork(formData);
      return ScientificWorkData.fromJson(
        Map<String, dynamic>.from(response.data['work'] as Map? ?? const {}),
      );
    } catch (error, stackTrace) {
      ApiErrorHandler.throwAsException(error, stackTrace);
    }
  }

  Future<void> deleteWork(int id) async {
    try {
      await _api.deleteWork(id);
    } catch (error, stackTrace) {
      ApiErrorHandler.throwAsException(error, stackTrace);
    }
  }

  Future<List<TeacherCoauthorData>> lookupCoauthors(String passportNo) async {
    try {
      final response = await _api.lookupCoauthors(passportNo);
      return (response.data['teachers'] as List?)
              ?.map(
                (item) => TeacherCoauthorData.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ),
              )
              .toList() ??
          const [];
    } catch (error, stackTrace) {
      ApiErrorHandler.throwAsException(error, stackTrace);
    }
  }
}
