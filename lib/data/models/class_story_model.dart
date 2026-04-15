class StoryAuthor {
  final int? id;
  final String? name;
  final String? avatarUrl;

  StoryAuthor({this.id, this.name, this.avatarUrl});

  factory StoryAuthor.fromJson(Map<String, dynamic> json) {
    return StoryAuthor(
      id: json['id'] as int?,
      name: json['name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
    );
  }
}

class StoryComment {
  final int id;
  final String body;
  final String? userName;
  final String? createdAt;

  StoryComment({
    required this.id,
    required this.body,
    this.userName,
    this.createdAt,
  });

  factory StoryComment.fromJson(Map<String, dynamic> json) {
    return StoryComment(
      id: json['id'] as int,
      body: json['body'] as String? ?? '',
      userName: json['user_name'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }
}

class StoryMedia {
  final String type;
  final String url;

  StoryMedia({required this.type, required this.url});

  factory StoryMedia.fromJson(Map<String, dynamic> json) {
    return StoryMedia(
      type: json['type'] as String? ?? 'image',
      url: json['url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'type': type, 'url': url};
}

class ClassStoryModel {
  final int id;
  final String? title;
  final String body;
  final List<StoryMedia> media;
  final bool isPinned;
  final StoryAuthor author;
  final int? groupId;
  final int likesCount;
  final int commentsCount;
  final bool isLiked;
  final List<StoryComment> comments;
  final String? createdAt;
  final String? timeAgo;

  ClassStoryModel({
    required this.id,
    this.title,
    required this.body,
    this.media = const [],
    this.isPinned = false,
    required this.author,
    this.groupId,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.isLiked = false,
    this.comments = const [],
    this.createdAt,
    this.timeAgo,
  });

  factory ClassStoryModel.fromJson(Map<String, dynamic> json) {
    return ClassStoryModel(
      id: json['id'] as int,
      title: json['title'] as String?,
      body: json['body'] as String? ?? '',
      media: (json['media'] as List?)
              ?.map((e) => StoryMedia.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
      isPinned: json['is_pinned'] as bool? ?? false,
      author: StoryAuthor.fromJson(
        Map<String, dynamic>.from(json['author'] ?? {}),
      ),
      groupId: json['group_id'] as int?,
      likesCount: json['likes_count'] as int? ?? 0,
      commentsCount: json['comments_count'] as int? ?? 0,
      isLiked: json['is_liked'] as bool? ?? false,
      comments: (json['comments'] as List?)
              ?.map(
                (e) => StoryComment.fromJson(Map<String, dynamic>.from(e)),
              )
              .toList() ??
          [],
      createdAt: json['created_at'] as String?,
      timeAgo: json['time_ago'] as String?,
    );
  }

  ClassStoryModel copyWith({
    bool? isLiked,
    int? likesCount,
    int? commentsCount,
    List<StoryComment>? comments,
  }) {
    return ClassStoryModel(
      id: id,
      title: title,
      body: body,
      media: media,
      isPinned: isPinned,
      author: author,
      groupId: groupId,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      isLiked: isLiked ?? this.isLiked,
      comments: comments ?? this.comments,
      createdAt: createdAt,
      timeAgo: timeAgo,
    );
  }
}
