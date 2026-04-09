class Assessment {
  final int id;
  final int quarterId;
  final int groupId;
  final int subjectId;
  final String type;
  final String? title;
  final int maxScore;
  final num weight;
  final String? heldAt;
  final String? groupName;
  final String? subjectName;

  Assessment({
    required this.id,
    required this.quarterId,
    required this.groupId,
    required this.subjectId,
    required this.type,
    this.title,
    required this.maxScore,
    required this.weight,
    this.heldAt,
    this.groupName,
    this.subjectName,
  });

  factory Assessment.fromJson(Map<String, dynamic> json) {
    return Assessment(
      id: json['id'],
      quarterId: json['quarter_id'],
      groupId: json['group_id'],
      subjectId: json['subject_id'],
      type: json['type'] ?? 'exam',
      title: json['title'],
      maxScore: json['max_score'] ?? 100,
      weight: json['weight'] ?? 0,
      heldAt: json['held_at'],
      groupName: json['group']?['name'],
      subjectName: json['subject']?['name'],
    );
  }
}

class AssessmentOption {
  final int id;
  final String name;

  AssessmentOption({required this.id, required this.name});

  factory AssessmentOption.fromJson(Map<String, dynamic> json) {
    return AssessmentOption(id: json['id'], name: json['name']);
  }
}

class AssessmentResultData {
  final int studentId;
  final String studentName;
  final num? score;
  final String? comment;

  AssessmentResultData({
    required this.studentId,
    required this.studentName,
    this.score,
    this.comment,
  });
}
