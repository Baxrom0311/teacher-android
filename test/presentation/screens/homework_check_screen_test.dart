import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import 'package:teacher_school_app/data/models/homework_model.dart';
import 'package:teacher_school_app/l10n/app_localizations.dart';
import 'package:teacher_school_app/presentation/providers/homework_provider.dart';
import 'package:teacher_school_app/presentation/screens/homework/homework_check_screen.dart';

import '../../helpers/test_app.dart';

void main() {
  testWidgets('homework check screen renders localized statuses and actions', (
    tester,
  ) async {
    final l10n = lookupAppLocalizations(const Locale('uz'));
    await tester.pumpWidget(
      buildTestApp(
        const HomeworkCheckScreen(lessonHomeworkId: 15, title: 'Algebra'),
        overrides: [
          homeworkSubmissionsProvider.overrideWith(
            (ref, lessonHomeworkId) => [
              StudentHomework(
                id: 1,
                studentId: 11,
                studentName: 'Azizbek',
                fileUrl: 'https://example.com/file.pdf',
                status: 'submitted',
              ),
            ],
          ),
        ],
      ),
    );
    await tester.pump();

    expect(find.text('Algebra'), findsOneWidget);
    expect(find.text('Azizbek'), findsOneWidget);
    expect(find.text(l10n.homeworkStatusLabel('submitted')), findsOneWidget);
    expect(find.text(l10n.homeworkViewFileAction), findsOneWidget);
    expect(find.text(l10n.gradeAction), findsOneWidget);
  });
}
