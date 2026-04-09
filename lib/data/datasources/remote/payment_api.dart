import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_service.dart';

class PaymentApi {
  final ApiService _apiService;

  PaymentApi(this._apiService);

  Future<Response> getIndex({int? groupId, String? search}) async {
    return await _apiService.dio.get(
      ApiConstants.payments,
      queryParameters: {
        if (groupId != null && groupId > 0) 'group_id': groupId,
        if (search != null && search.isNotEmpty) 'q': search,
      },
    );
  }

  Future<Response> getStudentDetail(int studentId) async {
    return await _apiService.dio.get(ApiConstants.paymentDetail(studentId));
  }

  Future<Response> storePayment(
    int studentId,
    Map<String, dynamic> data,
  ) async {
    return await _apiService.dio.post(
      ApiConstants.paymentDetail(studentId),
      data: data,
    );
  }
}
