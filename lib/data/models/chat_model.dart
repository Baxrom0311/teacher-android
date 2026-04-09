class ChatContact {
  final int id;
  final String name;
  final String role; // 'parent', 'student', 'teacher', etc.
  final String? lastMessage;
  final String? lastMessageAt;
  final int unreadCount;
  final String? profilePhotoUrl;

  ChatContact({
    required this.id,
    required this.name,
    required this.role,
    this.lastMessage,
    this.lastMessageAt,
    this.unreadCount = 0,
    this.profilePhotoUrl,
  });

  factory ChatContact.fromJson(Map<String, dynamic> json) {
    return ChatContact(
      id: json['id'] as int,
      name: json['name'] as String,
      role: json['role'] as String? ?? 'user',
      lastMessage: json['last_message'] as String?,
      lastMessageAt: json['last_message_at'] as String?,
      unreadCount: json['unread_count'] as int? ?? 0,
      profilePhotoUrl: json['profile_photo_url'] as String?,
    );
  }
}

class ChatMessage {
  final int id;
  final int senderId;
  final int receiverId;
  final String message;
  final String? attachmentUrl;
  final String createdAt;
  final bool isRead;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    this.attachmentUrl,
    required this.createdAt,
    this.isRead = false,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as int,
      senderId: json['sender_id'] as int,
      receiverId: json['receiver_id'] as int,
      message: json['message'] as String,
      attachmentUrl: json['attachment_url'] as String?,
      createdAt: json['created_at'] as String,
      isRead: json['is_read'] as bool? ?? false,
    );
  }
}
