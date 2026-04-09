import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_service.dart';

class ChatApi {
  final ApiService _apiService;

  ChatApi(this._apiService);

  Future<Response> getContacts() async {
    return await _apiService.dio.get(ApiConstants.chatContacts);
  }

  Future<Response> getMessages(int userId) async {
    return await _apiService.dio.get(ApiConstants.chatMessages(userId));
  }

  Future<Response> sendMessage(
    int userId,
    String message, {
    String? attachmentPath,
  }) async {
    if (attachmentPath != null) {
      final formData = FormData.fromMap({
        'receiver_id': userId,
        if (message.isNotEmpty) 'body': message,
        'file': await MultipartFile.fromFile(attachmentPath),
      });
      return await _apiService.dio.post(
        ApiConstants.sendChatFile,
        data: formData,
      );
    } else {
      final data = {'receiver_id': userId, 'body': message};
      return await _apiService.dio.post(
        ApiConstants.sendChatMessage,
        data: data,
      );
    }
  }
}
