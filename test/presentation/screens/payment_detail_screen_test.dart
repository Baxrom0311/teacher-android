import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teacher_school_app/data/models/payment_model.dart';
import 'package:teacher_school_app/presentation/providers/payment_provider.dart';
import 'package:teacher_school_app/presentation/screens/payments/payment_detail_screen.dart';

import '../../helpers/test_app.dart';

void main() {
  testWidgets('payment detail screen renders student summary and history', (
    tester,
  ) async {
    final response = StudentPaymentDetailResponse(
      student: const {'name': 'Azizbek'},
      group: const {'name': '8-A'},
      payments: [
        StudentPayment(
          id: 1,
          studentId: 1,
          groupId: 2,
          payType: 'monthly',
          paymentMethod: 'cash',
          periodYear: 2026,
          periodMonth: 4,
          amount: 150000,
          paidAt: '2026-04-07',
        ),
      ],
      defaultAmount: 150000,
      monthlyFee: 200000,
      discountAmount: 50000,
      discountReasons: const [],
    );

    await tester.pumpWidget(
      buildTestApp(
        const PaymentDetailScreen(studentId: 1),
        overrides: [
          studentPaymentDetailProvider.overrideWith(
            (ref, studentId) => response,
          ),
        ],
      ),
    );
    await tester.pump();

    expect(find.text('Azizbek'), findsOneWidget);
    expect(find.text('8-A'), findsOneWidget);
    expect(find.byIcon(Icons.add_card), findsOneWidget);
    expect(find.byType(ListTile), findsOneWidget);
  });
}
