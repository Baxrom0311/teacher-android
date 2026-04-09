import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import '../../data/datasources/remote/chat_api.dart';
import '../../data/models/chat_model.dart';
import '../../data/repositories/chat_repository.dart';
import '../../core/storage/outbox_service.dart';
import 'auth_provider.dart';

final chatApiProvider = Provider<ChatApi>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return ChatApi(apiService);
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final api = ref.watch(chatApiProvider);
  final outbox = ref.watch(outboxServiceProvider);
  return ChatRepository(api, outbox);
});

// Provides list of all contacts (parents, students, admins)
final chatContactsProvider = FutureProvider.autoDispose<List<ChatContact>>((
  ref,
) async {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.fetchContacts();
});

// StateNotifier to hold messages for a specific user chat
class ChatMessagesController
    extends StateNotifier<AsyncValue<List<ChatMessage>>> {
  final ChatRepository _repository;
  final int userId;
  final int myId;

  ChatMessagesController(this._repository, this.userId, this.myId)
    : super(const AsyncValue.loading()) {
    loadMessages();
  }

  Future<void> loadMessages() async {
    try {
      final messages = await _repository.fetchMessages(userId);
      state = AsyncValue.data(messages);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> sendMessage(String text, {String? attachmentPath}) async {
    if (text.trim().isEmpty && attachmentPath == null) return;

    // Optimistically add message
    final currentList = state.value ?? [];
    final optimisticMsg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch,
      senderId: myId,
      receiverId: userId,
      message: attachmentPath != null
          ? AppLocalizationsRegistry.instance.chatSendingAttachmentPlaceholder
          : text,
      createdAt: DateTime.now().toIso8601String(),
    );

    state = AsyncValue.data([...currentList, optimisticMsg]);

    try {
      final sentMsg = await _repository.sendMessage(
        userId,
        text,
        attachmentPath: attachmentPath,
      );
      // Replace optimistic message with actual
      final updatedList = state.value!
          .map((m) => m.id == optimisticMsg.id ? sentMsg : m)
          .toList();
      state = AsyncValue.data(updatedList);
    } catch (e) {
      // Revert optimistic add on failure and trigger reload
      loadMessages();
    }
  }
}

final chatMessagesProvider = StateNotifierProvider.family
    .autoDispose<ChatMessagesController, AsyncValue<List<ChatMessage>>, int>((
      ref,
      userId,
    ) {
      final repository = ref.watch(chatRepositoryProvider);
      final myId = ref.watch(authControllerProvider).user?.id ?? 0;
      return ChatMessagesController(repository, userId, myId);
    });
