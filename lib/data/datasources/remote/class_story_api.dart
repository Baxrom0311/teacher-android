import '../../models/class_story_model.dart';
import '../../../core/network/api_service.dart';

class ClassStoryApi {
  final ApiService _apiService;

  ClassStoryApi(this._apiService);

  Future<List<ClassStoryModel>> getStories({int? groupId, int page = 1}) async {
    final response = await _apiService.get(
      '/api/stories',
      queryParameters: {
        'page': page,
        if (groupId != null) 'group_id': groupId,
      },
    );
    final data = response.data;
    final list = (data is Map ? data['data'] : data) as List? ?? [];
    return list
        .map((e) => ClassStoryModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<Map<String, dynamic>> getMeta({int? groupId, int page = 1}) async {
    final response = await _apiService.get(
      '/api/stories',
      queryParameters: {
        'page': page,
        if (groupId != null) 'group_id': groupId,
      },
    );
    final data = response.data;
    if (data is Map && data['meta'] != null) {
      return Map<String, dynamic>.from(data['meta']);
    }
    return {};
  }

  Future<Map<String, dynamic>> createStory({
    required String body,
    String? title,
    int? groupId,
    List<Map<String, dynamic>>? media,
    bool isPinned = false,
  }) async {
    final response = await _apiService.post(
      '/api/stories',
      data: {
        'body': body,
        if (title != null && title.isNotEmpty) 'title': title,
        if (groupId != null) 'group_id': groupId,
        if (media != null && media.isNotEmpty) 'media': media,
        'is_pinned': isPinned,
      },
    );
    return Map<String, dynamic>.from(response.data ?? {});
  }

  Future<bool> toggleLike(int storyId) async {
    final response = await _apiService.post('/api/stories/$storyId/like');
    final data = response.data;
    return data is Map && data['liked'] == true;
  }

  Future<StoryComment> addComment(int storyId, String body) async {
    final response = await _apiService.post(
      '/api/stories/$storyId/comments',
      data: {'body': body},
    );
    final data = response.data;
    final commentData = data is Map ? data['comment'] : null;
    return StoryComment.fromJson(
      Map<String, dynamic>.from(commentData ?? {}),
    );
  }

  Future<void> deleteStory(int storyId) async {
    await _apiService.delete('/api/stories/$storyId');
  }
}
