import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_service.dart';

class ClassJournalApi {
  final ApiService _apiService;

  ClassJournalApi(this._apiService);

  Future<Response> getClassJournal(int groupId, {String? date}) async {
    return await _apiService.dio.get(
      ApiConstants.classJournal,
      queryParameters: {
        'group_id': groupId,
        if (date != null) 'date': date,
      },
    );
  }
}
