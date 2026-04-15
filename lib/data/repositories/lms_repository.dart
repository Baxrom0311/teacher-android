import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import '../models/lms_model.dart';
import 'base_repository.dart';

class LmsRepository extends BaseRepository {
  final DioClient _dioClient;

  LmsRepository(this._dioClient);

  /// Get teacher's courses
  Future<List<CourseModel>> getMyCourses() async {
    return safeCallList<CourseModel>(
      () => _dioClient.dio.get('/api/v1/lms/courses'),
      (data) => CourseModel.fromJson(data),
    );
  }

  /// Create a new course
  Future<CourseModel> createCourse(Map<String, dynamic> payload) async {
    return safeCall<CourseModel>(
      () => _dioClient.dio.post('/api/v1/lms/courses', data: payload),
      (data) => CourseModel.fromJson(data),
    );
  }
}
