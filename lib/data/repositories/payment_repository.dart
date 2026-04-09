import '../../core/network/api_error_handler.dart';
import '../datasources/remote/payment_api.dart';
import '../models/payment_model.dart';

class PaymentRepository {
  final PaymentApi _api;

  PaymentRepository(this._api);

  Future<PaymentsIndexResponse> fetchIndex({
    int? groupId,
    String? search,
  }) async {
    try {
      final response = await _api.getIndex(groupId: groupId, search: search);
      return PaymentsIndexResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      ApiErrorHandler.throwAsException(error, stackTrace);
    }
  }

  Future<StudentPaymentDetailResponse> fetchStudentDetail(int studentId) async {
    try {
      final response = await _api.getStudentDetail(studentId);
      return StudentPaymentDetailResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      ApiErrorHandler.throwAsException(error, stackTrace);
    }
  }

  Future<bool> storePayment(
    int studentId, {
    required String payType,
    required String paymentMethod,
    required num amount,
    required String paidAt,
    int? periodYear,
    int? periodMonth,
    String? note,
  }) async {
    try {
      await _api.storePayment(studentId, {
        'pay_type': payType,
        'payment_method': paymentMethod,
        'amount': amount,
        'paid_at': paidAt,
        if (periodYear != null) 'period_year': periodYear,
        if (periodMonth != null) 'period_month': periodMonth,
        if (note != null && note.isNotEmpty) 'note': note,
      });
      return true;
    } catch (error, stackTrace) {
      ApiErrorHandler.throwAsException(error, stackTrace);
    }
  }
}
