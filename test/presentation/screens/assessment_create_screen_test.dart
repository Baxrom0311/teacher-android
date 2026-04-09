import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:teacher_school_app/data/models/assessment_model.dart';
import 'package:teacher_school_app/data/models/school_period_model.dart';
import 'package:teacher_school_app/data/repositories/assessment_repository.dart';
import 'package:teacher_school_app/presentation/providers/assessment_provider.dart';
import 'package:teacher_school_app/presentation/screens/assessments/assessment_create_screen.dart';

import '../../helpers/test_app.dart';

class MockAssessmentRepository extends Mock implements AssessmentRepository {}

void main() {
  testWidgets('assessment create screen renders localized form', (
    tester,
  ) async {
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

    expect(find.text('Yangi imtihon'), findsOneWidget);
    expect(find.text('Chorak'), findsOneWidget);
    expect(find.text('Imtihon turi'), findsOneWidget);
    expect(find.text('Maksimal ball'), findsOneWidget);
    expect(find.text('Saqlash'), findsOneWidget);
  });
}
