class GradeItem {
  final int id;
  final int studentId;
  final String studentName;
  final String? studentPhone;
  final int score;
  final String groupName;
  final String subjectName;
  final String? quarterName;

  GradeItem({
    required this.id,
    required this.studentId,
    required this.studentName,
    this.studentPhone,
    required this.score,
    required this.groupName,
    required this.subjectName,
    this.quarterName,
  });

  factory GradeItem.fromJson(Map<String, dynamic> json) {
    return GradeItem(
      id: json['id'],
      studentId: json['student_id'],
      studentName: json['student']?['name'] ?? '',
      studentPhone: json['student']?['phone'],
      score: json['score'] ?? 0,
      groupName: json['group']?['name'] ?? '',
      subjectName: json['subject']?['name'] ?? '',
      quarterName: json['quarter']?['name'],
    );
  }
}

class GradesFilterData {
  final List<FilterOption> groups;
  final List<FilterOption> subjects;
  final List<FilterOption>? quarters;

  GradesFilterData({
    required this.groups,
    required this.subjects,
    this.quarters,
  });

  factory GradesFilterData.fromJson(Map<String, dynamic> json) {
    return GradesFilterData(
      groups:
          (json['groups'] as List?)
              ?.map((e) => FilterOption.fromJson(e))
              .toList() ??
          [],
      subjects:
          (json['subjects'] as List?)
              ?.map((e) => FilterOption.fromJson(e))
              .toList() ??
          [],
      quarters: json['quarters'] != null
          ? (json['quarters'] as List)
                .map((e) => FilterOption.fromJson(e))
                .toList()
          : null,
    );
  }
}

class FilterOption {
  final int id;
  final String name;

  FilterOption({required this.id, required this.name});

  factory FilterOption.fromJson(Map<String, dynamic> json) {
    return FilterOption(id: json['id'], name: json['name']);
  }
}

class GradesResponse {
  final List<GradeItem> items;
  final GradesFilterData filters;
  final int currentPage;
  final int lastPage;

  GradesResponse({
    required this.items,
    required this.filters,
    required this.currentPage,
    required this.lastPage,
  });

  factory GradesResponse.fromJson(Map<String, dynamic> json) {
    return GradesResponse(
      items: (json['items'] as List).map((e) => GradeItem.fromJson(e)).toList(),
      filters: GradesFilterData.fromJson(json),
      currentPage: json['pagination']?['current_page'] ?? 1,
      lastPage: json['pagination']?['last_page'] ?? 1,
    );
  }
}
