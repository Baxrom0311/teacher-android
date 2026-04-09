import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_error_handler.dart';
import '../../core/storage/outbox_service.dart';
import '../../data/models/attendance_model.dart';
import '../../data/models/lesson_model.dart';
import 'attendance_provider.dart';
import 'chat_provider.dart';
import 'lesson_provider.dart';

enum NetworkStatus { online, offline, unknown }

enum OutboxSyncPhase { idle, syncing, success, error }

class OutboxSyncStatus {
  final OutboxSyncPhase phase;
  final int affectedCount;
  final String? message;

  const OutboxSyncStatus({
    this.phase = OutboxSyncPhase.idle,
    this.affectedCount = 0,
    this.message,
  });

  const OutboxSyncStatus.syncing(int count)
    : phase = OutboxSyncPhase.syncing,
      affectedCount = count,
      message = null;

  const OutboxSyncStatus.success(int count)
    : phase = OutboxSyncPhase.success,
      affectedCount = count,
      message = null;

  const OutboxSyncStatus.error(String errorMessage, {int count = 0})
    : phase = OutboxSyncPhase.error,
      affectedCount = count,
      message = errorMessage;
}

final outboxQueueCountProvider = StreamProvider<int>((ref) {
  final outbox = ref.watch(outboxServiceProvider);
  return outbox.watchQueueCount();
});

final currentOutboxQueueCountProvider = Provider<int>((ref) {
  return ref
      .watch(outboxQueueCountProvider)
      .maybeWhen(data: (count) => count, orElse: () => 0);
});

final outboxSyncStatusProvider = StateProvider<OutboxSyncStatus>(
  (ref) => const OutboxSyncStatus(),
);

final currentOutboxSyncStatusProvider = Provider<OutboxSyncStatus>((ref) {
  return ref.watch(outboxSyncStatusProvider);
});

final currentNetworkStatusProvider = Provider<NetworkStatus>((ref) {
  return ref.watch(connectivityProvider);
});

class ConnectivityNotifier extends StateNotifier<NetworkStatus> {
  final Connectivity _connectivity = Connectivity();
  final Ref _ref;

  ConnectivityNotifier(this._ref) : super(NetworkStatus.unknown) {
    _init();
    _connectivity.onConnectivityChanged.listen(_updateState);
  }

  Future<void> _init() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _updateState(results);
    } catch (e) {
      state = NetworkStatus.unknown;
    }
  }

  void _updateState(List<ConnectivityResult> results) {
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      state = NetworkStatus.offline;
    } else {
      final wasOffline = state == NetworkStatus.offline;
      state = NetworkStatus.online;

      if (wasOffline) {
        _flushOutbox();
      }
    }
  }

  Future<void> _flushOutbox() async {
    try {
      final outbox = _ref.read(outboxServiceProvider);
      final actions = await outbox.getQueuedActions();
      if (actions.isEmpty) return;

      _ref.read(outboxSyncStatusProvider.notifier).state =
          OutboxSyncStatus.syncing(actions.length);

      final attRepo = _ref.read(attendanceRepositoryProvider);
      final lessonRepo = _ref.read(lessonRepositoryProvider);
      final chatRepo = _ref.read(chatRepositoryProvider);
      var syncedCount = 0;
      Object? lastError;

      for (final action in actions) {
        bool success = false;
        final payload = {
          ...action.payload,
          'client_action_id': action.id,
          'client_queued_at': action.queuedAt.toIso8601String(),
        };

        try {
          if (action.type == OutboxActionType.markAttendance) {
            await attRepo.createAttendance(
              payload['quarter_id'],
              payload['timetable_entry_id'],
              payload['date'],
              (payload['rows'] as List)
                  .map((r) => AttendanceRow.fromJson(r))
                  .toList(),
              clientActionId: action
                  .id, // Agar repo parametrlariga qo'shilmagan bo'lsa headers orqali ketadi
            );
            success = true;
          } else if (action.type == OutboxActionType.updateAttendance) {
            await attRepo.updateAttendance(
              payload['attendance_id'],
              (payload['rows'] as List)
                  .map((r) => AttendanceRow.fromJson(r))
                  .toList(),
            );
            success = true;
          } else if (action.type == OutboxActionType.saveLessonResults) {
            await lessonRepo.saveLessonSession(
              payload['session_id'],
              payload['topic'],
              (payload['rows'] as List)
                  .map((r) => LessonSessionRow.fromJson(r))
                  .toList(),
            );
            success = true;
          } else if (action.type == OutboxActionType.sendMessage) {
            await chatRepo.sendMessage(
              payload['user_id'],
              payload['message'],
              attachmentPath: payload['attachment_path'],
            );
            success = true;
          }
        } catch (e) {
          // Network xato bo'lsa keyingi flushni kutamiz, boshqa xatolarda davom etamiz.
          if (ApiErrorHandler.isOfflineError(e)) {
            lastError = e;
            break;
          }
          lastError = e;
        }

        if (success) {
          syncedCount++;
          await outbox.removeAction(action.id);
        }
      }

      final remainingCount = await outbox.getQueuedActionsCount();

      if (syncedCount > 0) {
        _setTemporarySyncStatus(OutboxSyncStatus.success(syncedCount));
        return;
      }

      if (remainingCount > 0 && lastError != null) {
        _setTemporarySyncStatus(
          OutboxSyncStatus.error(
            ApiErrorHandler.readableMessage(lastError),
            count: remainingCount,
          ),
        );
        return;
      }

      _ref.read(outboxSyncStatusProvider.notifier).state =
          const OutboxSyncStatus();
    } catch (_) {}
  }

  void _setTemporarySyncStatus(OutboxSyncStatus status) {
    _ref.read(outboxSyncStatusProvider.notifier).state = status;

    Future<void>.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;

      final current = _ref.read(outboxSyncStatusProvider);
      final matchesCurrent =
          current.phase == status.phase &&
          current.affectedCount == status.affectedCount &&
          current.message == status.message;

      if (matchesCurrent) {
        _ref.read(outboxSyncStatusProvider.notifier).state =
            const OutboxSyncStatus();
      }
    });
  }
}

final connectivityProvider =
    StateNotifierProvider<ConnectivityNotifier, NetworkStatus>((ref) {
      return ConnectivityNotifier(ref);
    });
