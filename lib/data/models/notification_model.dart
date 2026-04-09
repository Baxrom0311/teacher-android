class Notification {
  final String id;
  final String type;
  final String title;
  final String body;
  final bool isRead;
  final String createdAt;
  final Map<String, dynamic> data;

  Notification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt,
    required this.data,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      isRead: json['is_read'] as bool,
      createdAt: json['created_at'] as String,
      data: json['data'] as Map<String, dynamic>? ?? {},
    );
  }
}

class NotificationsResponse {
  final List<Notification> notifications;
  final int currentPage;
  final int lastPage;

  NotificationsResponse({
    required this.notifications,
    required this.currentPage,
    required this.lastPage,
  });

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) {
    final meta = json['meta'] ?? {};
    return NotificationsResponse(
      notifications:
          (json['notifications'] as List?)
              ?.map((e) => Notification.fromJson(e))
              .toList() ??
          [],
      currentPage: meta['current_page'] ?? 1,
      lastPage: meta['last_page'] ?? 1,
    );
  }
}
