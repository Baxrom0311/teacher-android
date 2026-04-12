import 'package:flutter/widgets.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teacher_school_app/l10n/app_localizations.dart';

import 'package:teacher_school_app/data/models/assessment_model.dart';
import 'package:teacher_school_app/data/repositories/assessment_repository.dart';
import 'package:teacher_school_app/presentation/providers/assessment_provider.dart';
import 'package:teacher_school_app/presentation/screens/assessments/assessment_results_screen.dart';

import '../../helpers/test_app.dart';

class MockAssessmentRepository extends Mock implements AssessmentRepository {}

void main() {
  testWidgets('assessment results screen renders localized labels', (
    tester,
  ) async {
    final l10n = lookupAppLocalizations(const Locale('uz'));
    final payload = {
      'assessment': Assessment(
        id: 1,
        quarterId: 1,
        groupId: 1,
        subjectId: 1,
        type: 'exam',
        title: 'Algebra',
        maxScore: 100,
        weight: 1,
      ),
      'results': [
        AssessmentResultData(
          studentId: 1,
          studentName: 'Aziza',
          score: 95,
          comment: 'Ajoyib',
        ),
      ],
    };

    await tester.pumpWidget(
      buildTestApp(
        const AssessmentResultsScreen(assessmentId: 1, title: 'Algebra'),
        overrides: [
          assessmentResultsProvider.overrideWith((ref, id) => payload),
          assessmentControllerProvider.overrideWith(
            (ref) => AssessmentController(MockAssessmentRepository()),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Algebra'), findsOneWidget);
    expect(find.text('Aziza'), findsOneWidget);
    expect(find.text(l10n.assessmentScoreLabel.toUpperCase()), findsOneWidget);
    expect(
      find.text(l10n.assessmentCommentLabel.toUpperCase()),
      findsOneWidget,
    );
    expect(find.text(l10n.saveAction), findsOneWidget);
  });
}
