/// Class Journal model — teacher's diary view for a class on a specific date.
///
/// Backend: GET /api/diary/class-journal?group_id=X&date=YYYY-MM-DD
class ClassJournalStudent {
  final int studentId;
  final String studentName;
  final List<ClassJournalLesson> lessons;

  ClassJournalStudent({
    required this.studentId,
    required this.studentName,
    required this.lessons,
  });

  factory ClassJournalStudent.fromJson(Map<String, dynamic> json) {
    final lessonsRaw = json['lessons'];
    final lessons = (lessonsRaw is List)
        ? lessonsRaw
            .whereType<Map>()
            .map((e) =>
                ClassJournalLesson.fromJson(Map<String, dynamic>.from(e)))
            .toList()
        : <ClassJournalLesson>[];

    return ClassJournalStudent(
      studentId: (json['student_id'] as num).toInt(),
      studentName: json['student_name'] as String? ?? '',
      lessons: lessons,
    );
  }
}

class ClassJournalLesson {
  final String? subject;
  final double? grade;
  final String? attStatus;
  final String? homeworkNote;

  ClassJournalLesson({
    this.subject,
    this.grade,
    this.attStatus,
    this.homeworkNote,
  });

  factory ClassJournalLesson.fromJson(Map<String, dynamic> json) {
    return ClassJournalLesson(
      subject: json['subject'] as String?,
      grade: (json['grade'] as num?)?.toDouble(),
      attStatus: json['att_status'] as String?,
      homeworkNote: json['homework_note'] as String?,
    );
  }
}

class ClassJournalResponse {
  final int groupId;
  final String date;
  final List<ClassJournalStudent> students;

  ClassJournalResponse({
    required this.groupId,
    required this.date,
    required this.students,
  });

  factory ClassJournalResponse.fromJson(Map<String, dynamic> json) {
    final studentsRaw = json['students'];
    final students = (studentsRaw is List)
        ? studentsRaw
            .whereType<Map>()
            .map((e) =>
                ClassJournalStudent.fromJson(Map<String, dynamic>.from(e)))
            .toList()
        : <ClassJournalStudent>[];

    return ClassJournalResponse(
      groupId: (json['group_id'] as num).toInt(),
      date: json['date'] as String? ?? '',
      students: students,
    );
  }
}
