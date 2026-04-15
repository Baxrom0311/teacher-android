import '../../models/behavior_model.dart';
import '../../../core/network/api_service.dart';

class BehaviorApi {
  final ApiService _apiService;

  BehaviorApi(this._apiService);

  Future<List<BehaviorIncidentModel>> getIncidents({String? type, int? studentId}) async {
    final response = await _apiService.dio.get(
      '/api/behavior',
      queryParameters: {
        if (type != null) 'type': type,
        if (studentId != null) 'student_id': studentId,
      },
    );
    final data = response.data;
    final list = data is Map
        ? (data['data'] ?? data['incidents'] ?? []) as List
        : (data is List ? data : []);
    return list
        .map((e) => BehaviorIncidentModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<BehaviorIncidentModel> createIncident({
    required int studentId,
    required String type,
    required String category,
    String? description,
    required int points,
    required String incidentDate,
  }) async {
    final response = await _apiService.dio.post(
      '/api/behavior',
      data: {
        'student_id': studentId,
        'type': type,
        'category': category,
        if (description != null && description.isNotEmpty) 'description': description,
        'points': points,
        'incident_date': incidentDate,
      },
    );
    final data = response.data;
    final incidentData = data is Map ? (data['incident'] ?? data) : data;
    return BehaviorIncidentModel.fromJson(Map<String, dynamic>.from(incidentData));
  }
}
