class TimetableEntry {
  final int id;
  final String date;
  final String? subjectName;
  final String? roomName;
  final String? startsAt;
  final String? endsAt;
  final int? lessonNo;
  final String? groupNames;

  TimetableEntry({
    required this.id,
    required this.date,
    this.subjectName,
    this.roomName,
    this.startsAt,
    this.endsAt,
    this.lessonNo,
    this.groupNames,
  });

  factory TimetableEntry.fromJson(Map<String, dynamic> json, String date) {
    String? subject = json['subject']?['name'];
    String? room = json['room']?['name'];
    String? starts = json['lesson_time']?['starts_at'];
    String? ends = json['lesson_time']?['ends_at'];
    int? lessonNumber = json['lesson_time']?['lesson_no'];

    // Extract related groups if any
    String? groups;
    if (json['groups'] != null && json['groups'] is List) {
      groups = (json['groups'] as List).map((g) => g['name']).join(', ');
    }

    return TimetableEntry(
      id: json['id'],
      date: date,
      subjectName: subject,
      roomName: room,
      startsAt: starts,
      endsAt: ends,
      lessonNo: lessonNumber,
      groupNames: groups,
    );
  }
}
