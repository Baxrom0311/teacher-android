import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import 'package:teacher_school_app/data/models/grades_model.dart';
import 'package:teacher_school_app/l10n/app_localizations.dart';
import 'package:teacher_school_app/presentation/providers/grades_provider.dart';
import 'package:teacher_school_app/presentation/screens/grades/grades_list_screen.dart';

import '../../helpers/test_app.dart';

void main() {
  testWidgets('grades list screen renders localized tabs and cards', (
    tester,
  ) async {
    final l10n = lookupAppLocalizations(const Locale('uz'));
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
    await tester.pumpAndSettle();

    expect(find.text(l10n.gradesListTitle), findsOneWidget);
    expect(find.text(l10n.gradesQuarterTab), findsOneWidget);
    expect(find.text(l10n.gradesYearTab), findsOneWidget);
    expect(find.text('Aziza Aliyeva'), findsOneWidget);
    expect(find.text('Matematika • 8-B'), findsOneWidget);
    expect(find.text(l10n.gradesQuarterLabel('3-chorak')), findsOneWidget);
  });
}
