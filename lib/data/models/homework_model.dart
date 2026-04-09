class LessonHomework {
  final int id;
  final int? timetableEntryId;
  final String? groupName;
  final String? subjectName;
  final String title;
  final String? description;
  final String? dueDate;
  final String date;

  LessonHomework({
    required this.id,
    this.timetableEntryId,
    this.groupName,
    this.subjectName,
    required this.title,
    this.description,
    this.dueDate,
    required this.date,
  });

  factory LessonHomework.fromJson(Map<String, dynamic> json) {
    return LessonHomework(
      id: json['id'] as int,
      timetableEntryId: json['timetable_entry_id'] as int?,
      groupName: json['group_name'] as String?,
      subjectName: json['subject_name'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      dueDate: json['due_date'] as String?,
      date: json['date'] as String,
    );
  }
}

class StudentHomework {
  final int id;
  final int studentId;
  final String studentName;
  final String? fileUrl;
  final String status; // 'pending', 'submitted', 'graded'
  final int? grade;
  final String? comment;
  final String? submittedAt;

  StudentHomework({
    required this.id,
    required this.studentId,
    required this.studentName,
    this.fileUrl,
    required this.status,
    this.grade,
    this.comment,
    this.submittedAt,
  });

  factory StudentHomework.fromJson(Map<String, dynamic> json) {
    return StudentHomework(
      id: json['id'] as int,
      studentId: json['student_id'] as int,
      studentName: json['student_name'] as String,
      fileUrl: json['file_url'] as String?,
      status: json['status'] as String? ?? 'pending',
      grade: json['grade'] as int?,
      comment: json['comment'] as String?,
      submittedAt: json['submitted_at'] as String?,
    );
  }
}
