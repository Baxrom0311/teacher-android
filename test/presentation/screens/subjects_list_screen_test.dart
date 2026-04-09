import 'package:flutter_test/flutter_test.dart';
import 'package:teacher_school_app/data/models/school_period_model.dart';
import 'package:teacher_school_app/data/models/subject_model.dart';
import 'package:teacher_school_app/presentation/providers/subject_provider.dart';
import 'package:teacher_school_app/presentation/screens/subjects/subjects_list_screen.dart';

import '../../helpers/test_app.dart';

void main() {
  testWidgets(
    'subjects list screen renders localized title and academic year',
    (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          const SubjectsListScreen(),
          overrides: [
            subjectsListProvider.overrideWith(
              (ref) => {
                'subjects': [
                  SubjectData(
                    id: 1,
                    name: 'Matematika',
                    groups: const ['7-A', '7-B'],
                    groupSubjectIds: const [11, 12],
                  ),
                ],
                'current_year': AcademicYear(
                  id: 2,
                  name: '2026/2027',
                  isCurrent: true,
                ),
              },
            ),
          ],
        ),
      );
      await tester.pump();

      expect(find.text('Mening fanlarim'), findsOneWidget);
      expect(find.text('O\'quv yili: 2026/2027'), findsOneWidget);
      expect(find.text('Matematika'), findsOneWidget);
      expect(find.text('7-A'), findsOneWidget);
    },
  );
}
