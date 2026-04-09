import 'package:dio/dio.dart';

import '../datasources/remote/subject_api.dart';
import '../models/school_period_model.dart';
import '../models/subject_model.dart';
import './base_repository.dart';

class SubjectRepository extends BaseRepository {
  final SubjectApi _api;

  SubjectRepository(this._api);

  Future<Map<String, dynamic>> fetchSubjects() async {
    return safeCall(() => _api.getSubjects(), (data) {
      final subjects = (data['subjects'] as List)
          .map((e) => SubjectData.fromJson(e))
          .toList();
      return {
        'subjects': subjects,
        'current_year': data['current_year'] != null
            ? AcademicYear.fromJson(data['current_year'])
            : null,
      };
    });
  }

  Future<Map<String, dynamic>> fetchSubjectDetail(int subjectId) async {
    return safeCall(() => _api.getSubjectDetail(subjectId), (data) {
      final subject = data['subject'];
      final groups = (data['groups'] as List)
          .map((e) => SubjectDetail.fromJson(e))
          .toList();

      return {
        'subject_id': subject['id'],
        'subject_name': subject['name'],
        'groups': groups,
        'current_year': data['current_year'] != null
            ? AcademicYear.fromJson(data['current_year'])
            : null,
      };
    });
  }

  Future<int?> createTopic(
    int subjectId,
    int groupSubjectId,
    String title,
    String? description,
    List<String> filePaths,
  ) async {
    return safeCall(() async {
      final formData = FormData.fromMap({
        'group_subject_id': groupSubjectId,
        'title': title,
        if (description != null && description.isNotEmpty)
          'description': description,
      });

      for (final path in filePaths) {
        formData.files.add(
          MapEntry(
            'resources[]',
            await MultipartFile.fromFile(path, filename: path.split('/').last),
          ),
        );
      }
      return await _api.createTopic(subjectId, formData);
    }, (data) => data['topic_id'] as int?);
  }
}
