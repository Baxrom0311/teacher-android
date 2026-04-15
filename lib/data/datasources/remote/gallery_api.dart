import 'package:dio/dio.dart';
import '../../models/gallery_model.dart';
import '../../../core/network/api_service.dart';

class GalleryApi {
  final ApiService _apiService;

  GalleryApi(this._apiService);

  Future<List<GalleryAlbumModel>> getAlbums({int? groupId}) async {
    final response = await _apiService.dio.get(
      '/api/gallery/albums',
      queryParameters: {
        if (groupId != null) 'group_id': groupId,
      },
    );
    final data = response.data;
    final list = data is Map
        ? (data['albums'] ?? data['data'] ?? []) as List
        : (data is List ? data : []);
    return list
        .map((e) => GalleryAlbumModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<List<GalleryPhotoModel>> getPhotos(int albumId) async {
    final response = await _apiService.dio.get('/api/gallery/albums/$albumId/photos');
    final data = response.data;
    final list = data is Map
        ? (data['photos'] ?? data['data'] ?? []) as List
        : (data is List ? data : []);
    return list
        .map((e) => GalleryPhotoModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<GalleryAlbumModel> createAlbum({
    required String title,
    String? description,
    int? groupId,
  }) async {
    final response = await _apiService.dio.post(
      '/api/gallery/albums',
      data: {
        'title': title,
        if (description != null && description.isNotEmpty) 'description': description,
        if (groupId != null) 'group_id': groupId,
      },
    );
    final data = response.data;
    final albumData = data is Map ? (data['album'] ?? data) : data;
    return GalleryAlbumModel.fromJson(Map<String, dynamic>.from(albumData));
  }

  Future<List<GalleryPhotoModel>> uploadPhotos(int albumId, List<String> filePaths) async {
    final formData = FormData.fromMap({
      'photos': await Future.wait(
        filePaths.map((path) => MultipartFile.fromFile(path)),
      ),
    });
    final response = await _apiService.dio.post(
      '/api/gallery/albums/$albumId/photos',
      data: formData,
    );
    final data = response.data;
    final list = data is Map
        ? (data['photos'] ?? data['data'] ?? []) as List
        : (data is List ? data : []);
    return list
        .map((e) => GalleryPhotoModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> deleteAlbum(int albumId) async {
    await _apiService.dio.delete('/api/gallery/albums/$albumId');
  }
}
