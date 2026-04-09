class AcademicYear {
  final int id;
  final String name;
  final bool isCurrent;

  AcademicYear({required this.id, required this.name, this.isCurrent = false});

  factory AcademicYear.fromJson(Map<String, dynamic> json) {
    return AcademicYear(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      isCurrent: json['is_current'] == true || json['is_current'] == 1,
    );
  }
}

class Quarter {
  final int id;
  final String name;

  Quarter({required this.id, required this.name});

  factory Quarter.fromJson(Map<String, dynamic> json) {
    return Quarter(id: json['id'] as int, name: json['name'] as String? ?? '');
  }
}
