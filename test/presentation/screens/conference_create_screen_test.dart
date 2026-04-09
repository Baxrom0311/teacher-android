import 'package:flutter_test/flutter_test.dart';

import 'package:teacher_school_app/presentation/screens/conference/conference_create_screen.dart';

import '../../helpers/test_app.dart';

void main() {
  testWidgets('conference create screen renders localized empty state', (
    tester,
  ) async {
    await tester.pumpWidget(buildTestApp(const ConferenceCreateScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Majlis yaratish'), findsOneWidget);
    expect(find.text('Sanani tanlang:'), findsOneWidget);
    expect(find.text('Manzil / Xona:'), findsOneWidget);
    expect(find.text('Hali slotlar qo\'shilmadi'), findsOneWidget);
    expect(find.text('Saqlash'), findsOneWidget);
  });
}
