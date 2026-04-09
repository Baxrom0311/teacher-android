import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teacher_school_app/data/models/homework_model.dart';
import 'package:teacher_school_app/data/models/lesson_model.dart';
import 'package:teacher_school_app/l10n/app_localizations.dart';
import 'package:teacher_school_app/presentation/providers/homework_provider.dart';
import 'package:teacher_school_app/presentation/providers/lesson_provider.dart';
import 'package:teacher_school_app/presentation/screens/homework/homework_list_screen.dart';

import '../../helpers/test_app.dart';

void main() {
  testWidgets('homework list screen renders localized content', (tester) async {
    final l10n = lookupAppLocalizations(const Locale('uz'));
    await tester.pumpWidget(
      buildTestApp(
        const HomeworkListScreen(),
        overrides: [
          todayLessonsProvider.overrideWith(
            (ref) => TodayLessonsResponse(quarterId: 3, entries: const []),
          ),
          lessonHomeworksProvider.overrideWith(
            (ref, params) => [
              LessonHomework(
                id: 9,
                groupName: '7-A',
                title: 'Matematika masalalari',
                description: '2 ta masalani ishlang',
                dueDate: '2026-04-10',
                date: '2026-04-06',
              ),
            ],
          ),
        ],
      ),
    );
    await tester.pump();

    expect(find.text(l10n.homeworkListTitle), findsOneWidget);
    expect(find.text('7-A'), findsOneWidget);
    expect(find.text('Matematika masalalari'), findsOneWidget);
    expect(find.text(l10n.homeworkDueDateText('2026-04-10')), findsOneWidget);
  });
}
