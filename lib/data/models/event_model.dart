int _eventInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

String? _eventString(dynamic value) {
  final text = value?.toString();
  if (text == null || text.isEmpty) {
    return null;
  }
  return text;
}

class SchoolEventData {
  final int id;
  final String title;
  final String? description;
  final String type;
  final String? startDate;
  final String? endDate;
  final String? startTime;
  final String? endTime;
  final String? location;
  final String? targetRole;

  const SchoolEventData({
    required this.id,
    required this.title,
    this.description,
    required this.type,
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.location,
    this.targetRole,
  });

  factory SchoolEventData.fromJson(Map<String, dynamic> json) {
    return SchoolEventData(
      id: _eventInt(json['id']),
      title: _eventString(json['title']) ?? '',
      description: _eventString(json['description']),
      type: _eventString(json['type']) ?? 'other',
      startDate: _eventString(json['start_date']),
      endDate: _eventString(json['end_date']),
      startTime: _eventString(json['start_time']),
      endTime: _eventString(json['end_time']),
      location: _eventString(json['location']),
      targetRole: _eventString(json['target_role']),
    );
  }
}

class EventsResponse {
  final List<SchoolEventData> events;
  final int currentPage;
  final int lastPage;
  final int total;

  const EventsResponse({
    required this.events,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  factory EventsResponse.fromJson(Map<String, dynamic> json) {
    final pagination = Map<String, dynamic>.from(
      json['pagination'] as Map? ?? const {},
    );

    return EventsResponse(
      events:
          (json['events'] as List?)
              ?.map(
                (item) => SchoolEventData.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ),
              )
              .toList() ??
          const [],
      currentPage: _eventInt(pagination['current_page']),
      lastPage: _eventInt(pagination['last_page']),
      total: _eventInt(pagination['total']),
    );
  }
}
