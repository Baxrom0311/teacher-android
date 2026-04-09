int _dashboardInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

String? _dashboardString(dynamic value) {
  final text = value?.toString();
  if (text == null || text.isEmpty) {
    return null;
  }
  return text;
}

class DashboardPeriodData {
  final int id;
  final String? name;
  final String? startsAt;
  final String? endsAt;

  const DashboardPeriodData({
    required this.id,
    this.name,
    this.startsAt,
    this.endsAt,
  });

  factory DashboardPeriodData.fromJson(Map<String, dynamic> json) {
    return DashboardPeriodData(
      id: _dashboardInt(json['id']),
      name: _dashboardString(json['name']),
      startsAt: _dashboardString(json['starts_at']),
      endsAt: _dashboardString(json['ends_at']),
    );
  }
}

class DashboardTodayData {
  final String? date;
  final int lessonsTotal;
  final int sessionsOpen;
  final int sessionsClosed;
  final int absentCount;
  final int pendingExcusesCount;
  final int activeConferencesCount;

  const DashboardTodayData({
    this.date,
    required this.lessonsTotal,
    required this.sessionsOpen,
    required this.sessionsClosed,
    required this.absentCount,
    this.pendingExcusesCount = 0,
    this.activeConferencesCount = 0,
  });

  factory DashboardTodayData.fromJson(Map<String, dynamic> json) {
    return DashboardTodayData(
      date: _dashboardString(json['date']),
      lessonsTotal: _dashboardInt(json['lessons_total']),
      sessionsOpen: _dashboardInt(json['sessions_open']),
      sessionsClosed: _dashboardInt(json['sessions_closed']),
      absentCount: _dashboardInt(json['absent_count']),
      pendingExcusesCount: _dashboardInt(json['pending_excuses_count']),
      activeConferencesCount: _dashboardInt(json['active_conferences_count']),
    );
  }
}

class DashboardOverviewData {
  final int groupsCount;
  final int subjectsCount;
  final int studentsCount;

  const DashboardOverviewData({
    required this.groupsCount,
    required this.subjectsCount,
    required this.studentsCount,
  });

  factory DashboardOverviewData.fromJson(Map<String, dynamic> json) {
    return DashboardOverviewData(
      groupsCount: _dashboardInt(json['groups_count']),
      subjectsCount: _dashboardInt(json['subjects_count']),
      studentsCount: _dashboardInt(json['students_count']),
    );
  }
}

class RecentAssessmentData {
  final int id;
  final String title;
  final String? date;
  final int maxScore;
  final String? subjectName;
  final String? groupName;

  const RecentAssessmentData({
    required this.id,
    required this.title,
    this.date,
    required this.maxScore,
    this.subjectName,
    this.groupName,
  });

  factory RecentAssessmentData.fromJson(Map<String, dynamic> json) {
    return RecentAssessmentData(
      id: _dashboardInt(json['id']),
      title: _dashboardString(json['title']) ?? '',
      date: _dashboardString(json['date']),
      maxScore: _dashboardInt(json['max_score']),
      subjectName: _dashboardString(json['subject_name']),
      groupName: _dashboardString(json['group_name']),
    );
  }
}

class TeacherDashboardResponse {
  final DashboardPeriodData? currentYear;
  final DashboardPeriodData? currentQuarter;
  final DashboardTodayData today;
  final DashboardOverviewData overview;
  final List<RecentAssessmentData> recentAssessments;

  const TeacherDashboardResponse({
    required this.currentYear,
    required this.currentQuarter,
    required this.today,
    required this.overview,
    required this.recentAssessments,
  });

  factory TeacherDashboardResponse.fromJson(Map<String, dynamic> json) {
    return TeacherDashboardResponse(
      currentYear: json['current_year'] is Map<String, dynamic>
          ? DashboardPeriodData.fromJson(
              json['current_year'] as Map<String, dynamic>,
            )
          : json['current_year'] is Map
          ? DashboardPeriodData.fromJson(
              Map<String, dynamic>.from(json['current_year'] as Map),
            )
          : null,
      currentQuarter: json['current_quarter'] is Map<String, dynamic>
          ? DashboardPeriodData.fromJson(
              json['current_quarter'] as Map<String, dynamic>,
            )
          : json['current_quarter'] is Map
          ? DashboardPeriodData.fromJson(
              Map<String, dynamic>.from(json['current_quarter'] as Map),
            )
          : null,
      today: DashboardTodayData.fromJson(
        Map<String, dynamic>.from(json['today'] as Map? ?? const {}),
      ),
      overview: DashboardOverviewData.fromJson(
        Map<String, dynamic>.from(json['overview'] as Map? ?? const {}),
      ),
      recentAssessments:
          (json['recent_assessments'] as List?)
              ?.map(
                (item) => RecentAssessmentData.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ),
              )
              .toList() ??
          const [],
    );
  }
}
