class AttendanceSession {
  final int id;
  final int timetableEntryId;
  final String subjectName;
  final String groupName;
  final String date;
  final String createdAt;

  AttendanceSession({
    required this.id,
    required this.timetableEntryId,
    required this.subjectName,
    required this.groupName,
    required this.date,
    required this.createdAt,
  });

  factory AttendanceSession.fromJson(Map<String, dynamic> json) {
    return AttendanceSession(
      id: json['id'] as int,
      timetableEntryId: json['timetable_entry_id'] as int,
      subjectName: json['subject_name'] as String,
      groupName: json['group_name'] as String,
      date: json['date'] as String,
      createdAt: json['created_at'] as String,
    );
  }
}

class AttendanceRow {
  final int id;
  final int studentId;
  final String studentName;
  final String status;
  final String? note;

  AttendanceRow({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.status,
    this.note,
  });

  factory AttendanceRow.fromJson(Map<String, dynamic> json) {
    return AttendanceRow(
      id: json['id'] as int,
      studentId: json['student_id'] as int,
      studentName: json['student_name'] as String,
      status: json['status'] as String,
      note: json['note'] as String?,
    );
  }

  AttendanceRow copyWith({String? status, String? note}) {
    return AttendanceRow(
      id: id,
      studentId: studentId,
      studentName: studentName,
      status: status ?? this.status,
      note: note ?? this.note,
    );
  }
}

class AttendanceDetail {
  final AttendanceSession session;
  final List<AttendanceRow> rows;

  AttendanceDetail({required this.session, required this.rows});

  factory AttendanceDetail.fromJson(Map<String, dynamic> json) {
    var list = json['rows'] as List? ?? [];
    List<AttendanceRow> rows = list
        .map((i) => AttendanceRow.fromJson(i))
        .toList();

    return AttendanceDetail(
      session: AttendanceSession.fromJson(json['session']),
      rows: rows,
    );
  }
}

class AttendanceOption {
  final String value;
  final String label;

  AttendanceOption({required this.value, required this.label});

  factory AttendanceOption.fromJson(Map<String, dynamic> json) {
    return AttendanceOption(
      value: json['value'] as String,
      label: json['label'] as String,
    );
  }
}
