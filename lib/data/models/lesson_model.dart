class TimetableEntry {
  final int id;
  final int subjectId;
  final String subjectName;
  final int groupId;
  final String groupName;
  final String startTime;
  final String endTime;
  final String room;
  final int dayOfWeek;
  final int orderNumber;

  TimetableEntry({
    required this.id,
    required this.subjectId,
    required this.subjectName,
    required this.groupId,
    required this.groupName,
    required this.startTime,
    required this.endTime,
    required this.room,
    required this.dayOfWeek,
    required this.orderNumber,
  });

  factory TimetableEntry.fromJson(Map<String, dynamic> json) {
    return TimetableEntry(
      id: json['id'] as int,
      subjectId: json['subject_id'] as int,
      subjectName: json['subject_name'] as String,
      groupId: json['group_id'] as int,
      groupName: json['group_name'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      room: json['room'] as String,
      dayOfWeek: json['day_of_week'] as int,
      orderNumber: json['order_number'] as int,
    );
  }
}

class TodayLessonsResponse {
  final int quarterId;
  final int? currentEntryId;
  final List<TimetableEntry> entries;

  TodayLessonsResponse({
    required this.quarterId,
    this.currentEntryId,
    required this.entries,
  });

  factory TodayLessonsResponse.fromJson(Map<String, dynamic> json) {
    var list = json['entries'] as List? ?? [];
    List<TimetableEntry> entriesList = list
        .map((i) => TimetableEntry.fromJson(i))
        .toList();

    return TodayLessonsResponse(
      quarterId: json['quarter_id'] as int,
      currentEntryId: json['current_entry_id'] as int?,
      entries: entriesList,
    );
  }
}

class LessonSession {
  final int id;
  final int timetableEntryId;
  final int quarterId;
  final String date;
  final String? topic;
  final String startedAt;
  final String? completedAt;

  LessonSession({
    required this.id,
    required this.timetableEntryId,
    required this.quarterId,
    required this.date,
    this.topic,
    required this.startedAt,
    this.completedAt,
  });

  factory LessonSession.fromJson(Map<String, dynamic> json) {
    return LessonSession(
      id: json['id'] as int,
      timetableEntryId: json['timetable_entry_id'] as int,
      quarterId: json['quarter_id'] as int,
      date: json['date'] as String,
      topic: json['topic'] as String?,
      startedAt: json['started_at'] as String,
      completedAt: json['completed_at'] as String?,
    );
  }
}

class LessonSessionRow {
  final int id;
  final int studentId;
  final String studentName;
  final int? grade;
  final int? coin;
  final bool isPresent;

  LessonSessionRow({
    required this.id,
    required this.studentId,
    required this.studentName,
    this.grade,
    this.coin,
    required this.isPresent,
  });

  factory LessonSessionRow.fromJson(Map<String, dynamic> json) {
    return LessonSessionRow(
      id: json['id'] as int,
      studentId: json['student_id'] as int,
      studentName: json['student_name'] as String,
      grade: json['grade'] as int?,
      coin: json['coin'] as int?,
      isPresent: json['is_present'] as bool? ?? false,
    );
  }

  LessonSessionRow copyWith({int? grade, int? coin, bool? isPresent}) {
    return LessonSessionRow(
      id: id,
      studentId: studentId,
      studentName: studentName,
      grade: grade ?? this.grade,
      coin: coin ?? this.coin,
      isPresent: isPresent ?? this.isPresent,
    );
  }
}

class LessonSessionDetail {
  final String gradingMode;
  final LessonSession session;
  final List<LessonSessionRow> rows;
  final List<Map<String, dynamic>> topics;

  LessonSessionDetail({
    required this.gradingMode,
    required this.session,
    required this.rows,
    required this.topics,
  });

  factory LessonSessionDetail.fromJson(Map<String, dynamic> json) {
    var rowsList = json['rows'] as List? ?? [];
    List<LessonSessionRow> rows = rowsList
        .map((i) => LessonSessionRow.fromJson(i))
        .toList();

    var topicsList = json['topics'] as List? ?? [];
    List<Map<String, dynamic>> topics = List<Map<String, dynamic>>.from(
      topicsList,
    );

    return LessonSessionDetail(
      gradingMode: json['grading_mode'] as String? ?? 'grade',
      session: LessonSession.fromJson(json['session']),
      rows: rows,
      topics: topics,
    );
  }
}
