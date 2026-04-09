import '../datasources/remote/assessment_api.dart';
import '../models/assessment_model.dart';
import '../models/school_period_model.dart';
import './base_repository.dart';

class AssessmentRepository extends BaseRepository {
  final AssessmentApi _api;

  AssessmentRepository(this._api);

  Future<Map<String, dynamic>> fetchAssessments({
    int page = 1,
    int? quarterId,
    int? yearId,
  }) async {
    return safeCall(
      () =>
          _api.getAssessments(page: page, quarterId: quarterId, yearId: yearId),
      (data) {
        final items = (data['items'] as List)
            .map((e) => Assessment.fromJson(e))
            .toList();
        return {
          'items': items,
          'quarters':
              (data['quarters'] as List?)
                  ?.map((e) => Quarter.fromJson(e))
                  .toList() ??
              [],
          'currentQuarterId': data['quarter_id'],
          'currentYearId': data['year_id'],
          'pagination': data['pagination'],
        };
      },
    );
  }

  Future<Map<String, dynamic>> fetchAssessmentOptions({
    int? yearId,
    int? quarterId,
  }) async {
    return safeCall(
      () => _api.getAssessmentOptions(yearId: yearId, quarterId: quarterId),
      (data) => {
        'groups': (data['groups'] as List)
            .map((e) => AssessmentOption.fromJson(e))
            .toList(),
        'subjects': (data['subjects'] as List)
            .map((e) => AssessmentOption.fromJson(e))
            .toList(),
        'quarters': (data['quarters'] as List)
            .map((e) => Quarter.fromJson(e))
            .toList(),
        'currentQuarterId': data['quarter_id'],
        'currentYearId': data['year_id'],
      },
    );
  }

  Future<Assessment> createAssessment(Map<String, dynamic> data) async {
    return safeCall(
      () => _api.createAssessment(data),
      (json) => Assessment.fromJson(json['assessment']),
    );
  }

  Future<Assessment> updateAssessment(int id, Map<String, dynamic> data) async {
    return safeCall(
      () => _api.updateAssessment(id, data),
      (json) => Assessment.fromJson(json['assessment']),
    );
  }

  Future<void> deleteAssessment(int id) async {
    await safeCall(() => _api.deleteAssessment(id), (data) => data);
  }

  Future<Map<String, dynamic>> fetchAssessmentResults(int assessmentId) async {
    return safeCall(() => _api.getAssessmentResults(assessmentId), (data) {
      final assessment = Assessment.fromJson(data['assessment']);
      final studentsList = data['students'] as List;
      final existingMap = data['existing'] as Map<String, dynamic>;

      final results = studentsList.map((student) {
        final stId = student['id'].toString();
        final existing = existingMap[stId];
        return AssessmentResultData(
          studentId: student['id'],
          studentName: student['name'],
          score: existing?['score'],
          comment: existing?['comment'],
        );
      }).toList();

      return {'assessment': assessment, 'results': results};
    });
  }

  Future<void> saveAssessmentResults(
    int assessmentId,
    Map<String, num?> scores,
    Map<String, String?> comments,
  ) async {
    await safeCall(
      () => _api.saveAssessmentResults(assessmentId, {
        'score': scores,
        'comment': comments,
      }),
      (data) => data,
    );
  }
}
