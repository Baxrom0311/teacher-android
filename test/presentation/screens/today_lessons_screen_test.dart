import 'package:flutter_test/flutter_test.dart';
import 'package:teacher_school_app/data/models/lesson_model.dart';
import 'package:teacher_school_app/presentation/providers/lesson_provider.dart';
import 'package:teacher_school_app/presentation/screens/lessons/today_lessons_screen.dart';

import '../../helpers/test_app.dart';

void main() {
  testWidgets('today lessons screen renders localized lesson card', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        const TodayLessonsScreen(),
        overrides: [
          todayLessonsProvider.overrideWith(
            (ref) => TodayLessonsResponse(
              quarterId: 2,
              currentEntryId: 10,
              entries: [
                TimetableEntry(
                  id: 10,
                  subjectId: 1,
                  subjectName: 'Matematika',
                  groupId: 4,
                  groupName: '7-A',
                  startTime: '08:30:00',
                  endTime: '09:15:00',
                  room: '205',
                  dayOfWeek: DateTime.now().weekday,
                  orderNumber: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
    await tester.pump();

    expect(find.text('Bugungi darslar'), findsOneWidget);
    expect(find.text('Matematika'), findsOneWidget);
    expect(find.text('7-A'), findsOneWidget);
    expect(find.text('205'), findsOneWidget);
    expect(find.text('Darsni boshlash / kirish'), findsOneWidget);
  });
}
