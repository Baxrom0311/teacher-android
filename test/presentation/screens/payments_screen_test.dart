import 'package:flutter_test/flutter_test.dart';
import 'package:teacher_school_app/data/models/payment_model.dart';
import 'package:teacher_school_app/presentation/providers/payment_provider.dart';
import 'package:teacher_school_app/presentation/screens/payments/payments_screen.dart';

import '../../helpers/test_app.dart';

void main() {
  testWidgets('payments screen renders localized filters and student status', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        const PaymentsScreen(),
        overrides: [
          paymentsIndexProvider.overrideWith(
            (ref) => PaymentsIndexResponse(
              students: [
                StudentData(
                  studentId: 7,
                  studentName: 'Aziza Aliyeva',
                  groupId: 3,
                  groupName: '8-B',
                  isPaid: true,
                ),
              ],
              groups: [GroupData(id: 3, name: '8-B')],
              groupId: 0,
              search: '',
              paidStudentIds: const [7],
              month: 4,
              year: 2026,
            ),
          ),
        ],
      ),
    );
    await tester.pump();

    expect(find.text('To\'lovlar (o\'quvchilar)'), findsOneWidget);
    expect(find.text('Barcha guruhlar'), findsAtLeastNWidgets(1));
    expect(find.text('Aziza Aliyeva'), findsOneWidget);
    expect(find.text('To\'lagan'), findsOneWidget);
  });
}
