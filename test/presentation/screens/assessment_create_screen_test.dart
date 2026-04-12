import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:teacher_school_app/core/localization/l10n_extension.dart';

import 'package:teacher_school_app/data/models/assessment_model.dart';
import 'package:teacher_school_app/data/models/school_period_model.dart';
import 'package:teacher_school_app/data/repositories/assessment_repository.dart';
import 'package:teacher_school_app/l10n/app_localizations.dart';
import 'package:teacher_school_app/presentation/providers/assessment_provider.dart';
import 'package:teacher_school_app/presentation/screens/assessments/assessment_create_screen.dart';

import '../../helpers/test_app.dart';

class MockAssessmentRepository extends Mock implements AssessmentRepository {}

void main() {
  testWidgets('assessment create screen renders localized form', (
    tester,
  ) async {
    final l10n = lookupAppLocalizations(const Locale('uz'));
    final options = {
      'groups': [AssessmentOption(id: 1, name: '7-A')],
      'subjects': [AssessmentOption(id: 2, name: 'Matematika')],
      'quarters': [Quarter(id: 1, name: '1-chorak')],
      'currentQuarterId': 1,
      'currentYearId': 1,
    };

    await tester.pumpWidget(
      buildTestApp(
        const AssessmentCreateScreen(),
        overrides: [
          assessmentOptionsProvider.overrideWith((ref, params) => options),
          assessmentControllerProvider.overrideWith(
            (ref) => AssessmentController(MockAssessmentRepository()),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(l10n.assessmentCreateTitle), findsOneWidget);
    expect(
      find.text(l10n.assessmentClassificationTitle.toUpperCase()),
      findsOneWidget,
    );
    expect(
      find.text(l10n.assessmentDetailsTitle.toUpperCase()),
      findsOneWidget,
    );
    expect(find.text(l10n.assessmentMaxScoreLabel), findsOneWidget);
    expect(find.text(l10n.saveAction.toUpperCase()), findsOneWidget);
  });
}
