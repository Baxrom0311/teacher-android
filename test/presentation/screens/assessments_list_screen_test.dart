import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:teacher_school_app/data/models/assessment_model.dart';
import 'package:teacher_school_app/l10n/app_localizations.dart';
import 'package:teacher_school_app/presentation/providers/assessment_provider.dart';
import 'package:teacher_school_app/presentation/screens/assessments/assessments_list_screen.dart';

import '../../helpers/test_app.dart';

void main() {
  testWidgets('assessments list screen renders localized cards', (
    tester,
  ) async {
    final l10n = lookupAppLocalizations(const Locale('uz'));
    final payload = {
      'items': [
        Assessment(
          id: 1,
          quarterId: 1,
          groupId: 1,
          subjectId: 1,
          type: 'exam',
          title: 'Algebra nazorati',
          maxScore: 100,
          weight: 20,
          heldAt: '2026-04-15',
          groupName: '8-A',
          subjectName: 'Algebra',
        ),
      ],
    };

    await tester.pumpWidget(
      buildTestApp(
        const AssessmentsListScreen(),
        overrides: [
          assessmentsListProvider.overrideWith((ref, params) => payload),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(l10n.assessmentsListTitle), findsOneWidget);
    expect(find.text('Algebra nazorati'), findsOneWidget);
    expect(find.text(l10n.assessmentTypeLabelText('exam')), findsOneWidget);
    expect(find.text(l10n.assessmentMaxScoreText(100)), findsOneWidget);
    expect(find.text(l10n.assessmentWeightText(20)), findsOneWidget);
  });

  testWidgets(
    'assessments list screen falls back for missing title and subject',
    (tester) async {
      final l10n = lookupAppLocalizations(const Locale('uz'));
      final payload = {
        'items': [
          Assessment(
            id: 2,
            quarterId: 1,
            groupId: 1,
            subjectId: 1,
            type: 'exam',
            title: '',
            maxScore: 50,
            weight: 10,
            heldAt: '2026-04-16',
            groupName: '7-B',
            subjectName: null,
          ),
        ],
      };

      await tester.pumpWidget(
        buildTestApp(
          const AssessmentsListScreen(),
          overrides: [
            assessmentsListProvider.overrideWith((ref, params) => payload),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text(l10n.assessmentTypeLabelText('exam')),
        findsAtLeastNWidgets(2),
      );
      expect(find.text(l10n.unknownSubjectFallback), findsOneWidget);
    },
  );
}
