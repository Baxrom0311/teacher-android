import 'package:flutter_test/flutter_test.dart';
import 'package:teacher_school_app/data/models/grades_model.dart';
import 'package:teacher_school_app/presentation/providers/grades_provider.dart';
import 'package:teacher_school_app/presentation/screens/grades/grades_list_screen.dart';

import '../../helpers/test_app.dart';

void main() {
  testWidgets('grades list screen renders localized tabs and cards', (
    tester,
  ) async {
    final response = GradesResponse(
      items: [
        GradeItem(
          id: 1,
          studentId: 7,
          studentName: 'Aziza Aliyeva',
          studentPhone: '+998901234567',
          score: 96,
          groupName: '8-B',
          subjectName: 'Matematika',
          quarterName: '3-chorak',
        ),
      ],
      filters: GradesFilterData(groups: [], subjects: [], quarters: []),
      currentPage: 1,
      lastPage: 1,
    );

    await tester.pumpWidget(
      buildTestApp(
        const GradesListScreen(),
        overrides: [
          quarterGradesProvider.overrideWith((ref) => response),
          yearGradesProvider.overrideWith((ref) => response),
        ],
      ),
    );
    await tester.pump();

    expect(find.text('O\'quvchilar baholari'), findsOneWidget);
    expect(find.text('Choraklik'), findsOneWidget);
    expect(find.text('Yillik'), findsOneWidget);
    expect(find.text('Aziza Aliyeva'), findsOneWidget);
    expect(find.text('Matematika | 8-B'), findsOneWidget);
    expect(find.text('Chorak: 3-chorak'), findsOneWidget);
  });
}
