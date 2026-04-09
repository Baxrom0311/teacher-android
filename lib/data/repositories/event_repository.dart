import '../../core/network/api_error_handler.dart';
import '../datasources/remote/event_api.dart';
import '../models/event_model.dart';

class EventRepository {
  final EventApi _api;

  EventRepository(this._api);

  Future<EventsResponse> fetchEvents({int perPage = 20}) async {
    try {
      final response = await _api.getEvents(perPage: perPage);
      return EventsResponse.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );
    } catch (error, stackTrace) {
      ApiErrorHandler.throwAsException(error, stackTrace);
    }
  }
}
