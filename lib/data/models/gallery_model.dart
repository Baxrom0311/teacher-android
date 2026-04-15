class GalleryAlbumModel {
  final int id;
  final String title;
  final String? description;
  final int photosCount;
  final String? coverUrl;
  final String? creatorName;
  final String? createdAt;

  GalleryAlbumModel({
    required this.id,
    required this.title,
    this.description,
    this.photosCount = 0,
    this.coverUrl,
    this.creatorName,
    this.createdAt,
  });

  factory GalleryAlbumModel.fromJson(Map<String, dynamic> json) {
    return GalleryAlbumModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      photosCount: json['photos_count'] as int? ?? 0,
      coverUrl: json['cover_url'] as String?,
      creatorName: (json['creator'] is Map)
          ? json['creator']['name'] as String?
          : json['creator_name'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }
}

class GalleryPhotoModel {
  final int id;
  final String filePath;
  final String? caption;
  final String? mimeType;
  final int? size;

  GalleryPhotoModel({
    required this.id,
    required this.filePath,
    this.caption,
    this.mimeType,
    this.size,
  });

  factory GalleryPhotoModel.fromJson(Map<String, dynamic> json) {
    return GalleryPhotoModel(
      id: json['id'] as int,
      filePath: json['file_path'] as String? ?? json['url'] as String? ?? '',
      caption: json['caption'] as String?,
      mimeType: json['mime_type'] as String?,
      size: json['size'] as int?,
    );
  }
}
