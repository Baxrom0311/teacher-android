import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:teacher_school_app/data/models/lesson_model.dart';
import 'package:teacher_school_app/data/repositories/lesson_repository.dart';
import 'package:teacher_school_app/l10n/app_localizations.dart';
import 'package:teacher_school_app/presentation/providers/lesson_provider.dart';
import 'package:teacher_school_app/presentation/screens/lessons/lesson_session_screen.dart';

import '../../helpers/test_app.dart';

class MockLessonRepository extends Mock implements LessonRepository {}

void main() {
  testWidgets('lesson session screen renders localized content', (
    tester,
  ) async {
    final l10n = lookupAppLocalizations(const Locale('uz'));
    final repository = MockLessonRepository();

    when(() => repository.fetchLessonSession(1)).thenAnswer((_) async {
      return LessonSessionDetail(
        gradingMode: 'coin',
        session: LessonSession(
          id: 1,
          timetableEntryId: 10,
          quarterId: 2,
          date: '2026-04-06',
          topic: 'Kasrlar',
          startedAt: '08:00:00',
        ),
        rows: [
          LessonSessionRow(
            id: 1,
            studentId: 100,
            studentName: 'Ali Valiyev',
            coin: 20,
            isPresent: true,
          ),
          LessonSessionRow(
            id: 2,
            studentId: 101,
            studentName: 'Vali Aliyev',
            isPresent: false,
          ),
        ],
        topics: const [],
      );
    });

    await tester.pumpWidget(
      buildTestApp(
        const LessonSessionScreen(sessionId: 1),
        overrides: [lessonRepositoryProvider.overrideWithValue(repository)],
      ),
    );
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.text(l10n.lessonSessionTitle), findsOneWidget);
    expect(find.text(l10n.lessonSessionTopicLabel), findsOneWidget);
    expect(find.text(l10n.lessonSessionStudentsTitle), findsOneWidget);
    expect(find.text('Ali Valiyev'), findsOneWidget);
    expect(find.text(l10n.presentStatusShort), findsOneWidget);
    expect(find.text(l10n.absentStatusShort), findsOneWidget);
    expect(find.text(l10n.lessonCoinsSaved(20)), findsOneWidget);
  });
}
