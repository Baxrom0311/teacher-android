import 'package:dio/dio.dart';
import '../../core/network/api_error_handler.dart';
import '../datasources/remote/chat_api.dart';
import '../models/chat_model.dart';
import '../../core/storage/outbox_service.dart';

class ChatRepository {
  final ChatApi _api;
  final OutboxService _outbox;

  ChatRepository(this._api, this._outbox);

  Future<List<ChatContact>> fetchContacts() async {
    try {
      final response = await _api.getContacts();
      var list = response.data['contacts'] as List? ?? [];
      return list.map((e) => ChatContact.fromJson(e)).toList();
    } catch (error, stackTrace) {
      ApiErrorHandler.throwAsException(error, stackTrace);
    }
  }

  Future<List<ChatMessage>> fetchMessages(int userId) async {
    try {
      final response = await _api.getMessages(userId);
      var list = response.data['messages'] as List? ?? [];
      return list.map((e) => ChatMessage.fromJson(e)).toList();
    } catch (error, stackTrace) {
      ApiErrorHandler.throwAsException(error, stackTrace);
    }
  }

  Future<ChatMessage> sendMessage(
    int userId,
    String message, {
    String? attachmentPath,
  }) async {
    try {
      final response = await _api.sendMessage(
        userId,
        message,
        attachmentPath: attachmentPath,
      );
      return ChatMessage.fromJson(response.data['message']);
    } catch (error, stackTrace) {
      if (error is DioException && _isNetworkError(error)) {
        await _outbox.queueAction(
          OutboxAction(
            id: 'chat_send_${userId}_${DateTime.now().millisecondsSinceEpoch}',
            type: OutboxActionType.sendMessage,
            payload: {
              'user_id': userId,
              'message': message,
              'attachment_path': attachmentPath,
            },
            queuedAt: DateTime.now(),
          ),
        );
        ApiErrorHandler.throwAsException(
          'Offline: Xabar saqlandi va internet ulanganda yuboriladi.',
          stackTrace,
        );
      }

      ApiErrorHandler.throwAsException(error, stackTrace);
    }
  }

  bool _isNetworkError(DioException error) {
    return error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout;
  }
}
