import '../../core/network/api_service.dart';

class ConferenceRepository {
  final ApiService _api;

  ConferenceRepository(this._api);

  Future<void> createSlots({
    required List<Map<String, dynamic>> slots,
    String? location,
  }) async {
    await _api.dio.post(
      '/api/teacher/conferences',
      data: {'slots': slots, 'location': location},
    );
  }

  Future<List<dynamic>> getMySlots() async {
    final response = await _api.dio.get('/api/teacher/conferences');
    return response.data['slots'] ?? [];
  }
}
