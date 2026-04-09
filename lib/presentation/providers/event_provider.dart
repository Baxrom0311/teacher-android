import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/remote/event_api.dart';
import '../../data/models/event_model.dart';
import '../../data/repositories/event_repository.dart';
import 'auth_provider.dart';

final eventApiProvider = Provider<EventApi>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return EventApi(apiService);
});

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  final api = ref.watch(eventApiProvider);
  return EventRepository(api);
});

final eventsProvider = FutureProvider.autoDispose<EventsResponse>((ref) async {
  final repository = ref.watch(eventRepositoryProvider);
  return repository.fetchEvents();
});
