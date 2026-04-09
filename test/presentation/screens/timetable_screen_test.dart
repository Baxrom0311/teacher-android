import 'package:flutter_test/flutter_test.dart';
import 'package:teacher_school_app/data/models/timetable_model.dart';
import 'package:teacher_school_app/presentation/providers/timetable_provider.dart';
import 'package:teacher_school_app/presentation/screens/timetable/timetable_screen.dart';

import '../../helpers/test_app.dart';

void main() {
  testWidgets('timetable screen renders localized card', (tester) async {
    final now = DateTime.now();
    final dateStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    await tester.pumpWidget(
      buildTestApp(
        const TimetableScreen(),
        overrides: [
          timetableProvider.overrideWith(
            (ref, params) => {
              'schedule_by_date': {
                dateStr: [
                  TimetableEntry(
                    id: 1,
                    date: dateStr,
                    subjectName: 'Matematika',
                    roomName: '205',
                    startsAt: '08:30:00',
                    endsAt: '09:15:00',
                    lessonNo: 1,
                    groupNames: '7-A',
                  ),
                ],
              },
            },
          ),
        ],
      ),
    );
    await tester.pump();

    expect(find.text('Dars jadvali'), findsOneWidget);
    expect(find.text('Matematika'), findsOneWidget);
    expect(find.textContaining('7-A'), findsOneWidget);
    expect(find.textContaining('205'), findsOneWidget);
  });
}
