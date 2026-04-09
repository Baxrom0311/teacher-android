import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teacher_school_app/l10n/app_localizations.dart';

import 'package:teacher_school_app/presentation/providers/attendance_provider.dart';
import 'package:teacher_school_app/presentation/screens/attendance/absence_review_screen.dart';

import '../../helpers/test_app.dart';

void main() {
  testWidgets('absence review screen renders localized pending request', (
    tester,
  ) async {
    final l10n = lookupAppLocalizations(const Locale('uz'));
    final excuses = [
      {
        'id': 5,
        'excuse_date': '2026-04-06',
        'reason': 'Shifokor ko\'rigi',
        'student': {'name': 'Ali Valiyev'},
      },
    ];

    await tester.pumpWidget(
      buildTestApp(
        const AbsenceReviewScreen(),
        overrides: [
          absenceExcusesProvider.overrideWith((ref, status) => excuses),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(l10n.absenceReviewTitle), findsOneWidget);
    expect(find.text(l10n.absenceStatusLabel('pending')), findsOneWidget);
    expect(find.text(l10n.absenceStatusLabel('approved')), findsOneWidget);
    expect(find.text(l10n.absenceStatusLabel('rejected')), findsOneWidget);
    expect(find.text('Ali Valiyev'), findsOneWidget);
    expect(find.text(l10n.absenceDateLabel('2026-04-06')), findsOneWidget);

    await tester.tap(find.text('Ali Valiyev'));
    await tester.pumpAndSettle();

    expect(
      find.text(l10n.absenceReasonLabel('Shifokor ko\'rigi')),
      findsOneWidget,
    );
    expect(find.text(l10n.rejectAction), findsOneWidget);
    expect(find.text(l10n.approveAction), findsOneWidget);
  });
}
