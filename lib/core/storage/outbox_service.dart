import 'dart:convert';
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final outboxServiceProvider = Provider<OutboxService>((ref) {
  final service = OutboxService();
  ref.onDispose(service.dispose);
  return service;
});

enum OutboxActionType {
  markAttendance,
  updateAttendance,
  saveLessonResults,
  saveHomework,
  sendMessage,
}

class OutboxAction {
  final String id;
  final OutboxActionType type;
  final Map<String, dynamic> payload;
  final DateTime queuedAt;

  OutboxAction({
    required this.id,
    required this.type,
    required this.payload,
    required this.queuedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'payload': payload,
    'queuedAt': queuedAt.toIso8601String(),
  };

  factory OutboxAction.fromJson(Map<String, dynamic> json) => OutboxAction(
    id: json['id'] as String,
    type: OutboxActionType.values.byName(json['type'] as String),
    payload: json['payload'] as Map<String, dynamic>,
    queuedAt: DateTime.parse(json['queuedAt'] as String),
  );
}

class OutboxService {
  static const String _boxName = 'teacher_outbox_box';
  final StreamController<int> _queueCountController =
      StreamController<int>.broadcast();
  Box? _box;

  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_boxName);
    _emitQueueCount();
  }

  Future<void> queueAction(OutboxAction action) async {
    if (_box == null) await init();
    try {
      final jsonString = jsonEncode(action.toJson());
      await _box!.put(action.id, jsonString);
      _emitQueueCount();
    } catch (_) {}
  }

  Future<List<OutboxAction>> getQueuedActions() async {
    if (_box == null) await init();
    try {
      final List<OutboxAction> actions = [];
      for (final key in _box!.keys) {
        final jsonString = _box!.get(key) as String?;
        if (jsonString != null) {
          final map = jsonDecode(jsonString) as Map<String, dynamic>;
          actions.add(OutboxAction.fromJson(map));
        }
      }
      return actions..sort((a, b) => a.queuedAt.compareTo(b.queuedAt));
    } catch (_) {
      return [];
    }
  }

  Future<void> removeAction(String id) async {
    if (_box == null) await init();
    await _box!.delete(id);
    _emitQueueCount();
  }

  Future<int> getQueuedActionsCount() async {
    if (_box == null) await init();
    return _box?.length ?? 0;
  }

  Stream<int> watchQueueCount() async* {
    yield await getQueuedActionsCount();
    yield* _queueCountController.stream;
  }

  /// Barcha navbatdagi amallarni serverga jo'natish.
  /// Har bir repository o'zining handleriga ega bo'lishi kerak.
  Future<void> processOutbox(WidgetRef ref) async {
    // Bu metod keyinaroq connectivity_provider tomonidan chaqiriladi
    // va har bir repositorydagi flush logicni trigger qiladi.
  }

  void dispose() {
    _queueCountController.close();
  }

  void _emitQueueCount() {
    if (_queueCountController.isClosed) return;
    _queueCountController.add(_box?.length ?? 0);
  }
}
