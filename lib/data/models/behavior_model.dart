class BehaviorIncidentModel {
  final int id;
  final int studentId;
  final String type;
  final String category;
  final String? description;
  final int points;
  final String? incidentDate;
  final String? reporterName;
  final String? studentName;

  BehaviorIncidentModel({
    required this.id,
    required this.studentId,
    required this.type,
    required this.category,
    this.description,
    this.points = 0,
    this.incidentDate,
    this.reporterName,
    this.studentName,
  });

  factory BehaviorIncidentModel.fromJson(Map<String, dynamic> json) {
    return BehaviorIncidentModel(
      id: json['id'] as int,
      studentId: json['student_id'] as int? ?? 0,
      type: json['type'] as String? ?? 'positive',
      category: json['category'] as String? ?? '',
      description: json['description'] as String?,
      points: json['points'] as int? ?? 0,
      incidentDate: json['incident_date'] as String?,
      reporterName: (json['reporter'] is Map)
          ? json['reporter']['name'] as String?
          : json['reporter_name'] as String?,
      studentName: (json['student'] is Map)
          ? json['student']['name'] as String?
          : json['student_name'] as String?,
    );
  }

  bool get isPositive => type == 'positive';
}

class BehaviorReportModel {
  final int totalIncidents;
  final int positiveCount;
  final int negativeCount;
  final int netPoints;
  final List<BehaviorIncidentModel> incidents;

  BehaviorReportModel({
    this.totalIncidents = 0,
    this.positiveCount = 0,
    this.negativeCount = 0,
    this.netPoints = 0,
    this.incidents = const [],
  });

  factory BehaviorReportModel.fromJson(Map<String, dynamic> json) {
    final incidentList = json['data'] ?? json['incidents'] ?? [];
    return BehaviorReportModel(
      totalIncidents: json['total_incidents'] as int? ?? 0,
      positiveCount: json['positive_count'] as int? ?? 0,
      negativeCount: json['negative_count'] as int? ?? 0,
      netPoints: json['net_points'] as int? ?? 0,
      incidents: (incidentList as List)
          .map((e) => BehaviorIncidentModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}
