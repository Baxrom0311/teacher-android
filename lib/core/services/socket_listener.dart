import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../presentation/providers/auth_provider.dart';
import '../../presentation/providers/chat_provider.dart';
import 'socket_service.dart';

/// WebSocket eventlarini tinglovchi va tegishli providerlarni yangilovchi servis (Teacher App).
class SocketListener {
  final Ref _ref;

  SocketListener(this._ref) {
    _init();
  }

  void _init() {
    _ref.listen<SocketService?>(socketServiceProvider, (previous, next) {
      if (next != null) {
        _subscribeToChannels(next);
      }
    });

    final socketService = _ref.read(socketServiceProvider);
    if (socketService != null) {
      _subscribeToChannels(socketService);
    }
  }

  void _subscribeToChannels(SocketService socket) {
    final authState = _ref.read(authControllerProvider);
    if (authState.user == null) return;

    final myId = authState.user!.id;
    final tenantId = authState.user!.tenantId;
    if (tenantId == null || tenantId.isEmpty) {
      log(
        'WebSocket (Teacher): tenant_id is missing, chat subscription skipped',
      );
      return;
    }

    // 1. Chat xabarlari uchun kanal (Private)
    final chatChannel = 'tenant.$tenantId.user.$myId';
    log('WebSocket (Teacher): Subscribing to $chatChannel');

    socket.listenPrivate(chatChannel, 'chat.message', (data) {
      log('WebSocket: New chat message received');

      // Xabar yuborgan foydalanuvchi ID si
      final senderIdRaw = data['sender_id'];
      final senderId = senderIdRaw is num
          ? senderIdRaw.toInt()
          : int.tryParse('$senderIdRaw');

      if (senderId != null) {
        // Chat kontaktlarini yangilash
        _ref.invalidate(chatContactsProvider);

        // Agar o'sha foydalanuvchi bilan chat ochiq bo'lsa, xabarlarni qayta yuklash
        _ref.read(chatMessagesProvider(senderId).notifier).loadMessages();
      }
    });

    // 2. Maktab yangiliklari/bildirishnomalari (Optional)
    // socket.listenPrivate('school.1', 'SchoolEventCreated', (data) { ... });
  }
}

/// SocketListener Provider
final socketListenerProvider = Provider<SocketListener>((ref) {
  return SocketListener(ref);
});
