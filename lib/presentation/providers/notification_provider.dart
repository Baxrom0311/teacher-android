import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/remote/notification_api.dart';
import '../../data/repositories/notification_repository.dart';
import '../../data/models/notification_model.dart';
import 'auth_provider.dart';

final notificationApiProvider = Provider<NotificationApi>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return NotificationApi(apiService);
});

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final api = ref.watch(notificationApiProvider);
  return NotificationRepository(api);
});

final notificationsProvider = FutureProvider.autoDispose<NotificationsResponse>(
  (ref) async {
    final repository = ref.watch(notificationRepositoryProvider);
    return repository.fetchNotifications();
  },
);

class NotificationController extends StateNotifier<AsyncValue<void>> {
  final NotificationRepository _repository;

  NotificationController(this._repository) : super(const AsyncValue.data(null));

  Future<bool> markAsRead(String id) async {
    return await _repository.markAsRead(id);
  }

  Future<bool> saveFcmToken(String token) async {
    return await _repository.saveFcmToken(token);
  }
}

final notificationControllerProvider =
    StateNotifierProvider.autoDispose<NotificationController, AsyncValue<void>>(
      (ref) {
        final repository = ref.watch(notificationRepositoryProvider);
        return NotificationController(repository);
      },
    );
