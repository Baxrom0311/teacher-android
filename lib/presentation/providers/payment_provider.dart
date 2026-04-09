import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/remote/payment_api.dart';
import '../../data/repositories/payment_repository.dart';
import '../../data/models/payment_model.dart';
import 'auth_provider.dart';

final paymentApiProvider = Provider<PaymentApi>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return PaymentApi(apiService);
});

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  final api = ref.watch(paymentApiProvider);
  return PaymentRepository(api);
});

final paymentIndexParamsProvider = StateProvider<Map<String, dynamic>>(
  (ref) => {'group_id': null, 'search': null},
);

final paymentsIndexProvider = FutureProvider.autoDispose<PaymentsIndexResponse>(
  (ref) async {
    final repository = ref.watch(paymentRepositoryProvider);
    final params = ref.watch(paymentIndexParamsProvider);
    return repository.fetchIndex(
      groupId: params['group_id'] as int?,
      search: params['search'] as String?,
    );
  },
);

final studentPaymentDetailProvider = FutureProvider.family
    .autoDispose<StudentPaymentDetailResponse, int>((ref, studentId) async {
      final repository = ref.watch(paymentRepositoryProvider);
      return repository.fetchStudentDetail(studentId);
    });

class PaymentController extends StateNotifier<AsyncValue<void>> {
  final PaymentRepository _repository;

  PaymentController(this._repository) : super(const AsyncValue.data(null));

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
    state = const AsyncValue.loading();
    try {
      await _repository.storePayment(
        studentId,
        payType: payType,
        paymentMethod: paymentMethod,
        amount: amount,
        paidAt: paidAt,
        periodYear: periodYear,
        periodMonth: periodMonth,
        note: note,
      );
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

final paymentControllerProvider =
    StateNotifierProvider.autoDispose<PaymentController, AsyncValue<void>>((
      ref,
    ) {
      final repository = ref.watch(paymentRepositoryProvider);
      return PaymentController(repository);
    });
