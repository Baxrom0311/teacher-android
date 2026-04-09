import 'package:flutter_test/flutter_test.dart';
import 'package:teacher_school_app/data/models/event_model.dart';
import 'package:teacher_school_app/presentation/providers/event_provider.dart';
import 'package:teacher_school_app/presentation/screens/events/events_screen.dart';

import '../../helpers/test_app.dart';

void main() {
  testWidgets('events screen renders event cards from provider', (
    tester,
  ) async {
    const response = EventsResponse(
      events: [
        SchoolEventData(
          id: 1,
          title: 'Fan olimpiadasi',
          description: 'Hududiy bosqich',
          type: 'exam',
          startDate: '2026-04-10',
          endDate: '2026-04-10',
          startTime: '09:00',
          endTime: '12:00',
          location: 'Faollar zali',
        ),
      ],
      currentPage: 1,
      lastPage: 1,
      total: 1,
    );

    await tester.pumpWidget(
      buildTestApp(
        const EventsScreen(),
        overrides: [eventsProvider.overrideWith((ref) => response)],
      ),
    );
    await tester.pump();

    expect(find.text('Tadbirlar'), findsOneWidget);
    expect(find.text('Fan olimpiadasi'), findsOneWidget);
    expect(find.text('Imtihon'), findsOneWidget);
    expect(find.text('Faollar zali'), findsOneWidget);
    expect(find.text('Hududiy bosqich'), findsOneWidget);
  });

  testWidgets('events screen shows localized fallback title when empty', (
    tester,
  ) async {
    const response = EventsResponse(
      events: [
        SchoolEventData(
          id: 2,
          title: '',
          description: null,
          type: 'meeting',
          startDate: '2026-04-12',
          endDate: '2026-04-12',
          startTime: null,
          endTime: null,
          location: null,
        ),
      ],
      currentPage: 1,
      lastPage: 1,
      total: 1,
    );

    await tester.pumpWidget(
      buildTestApp(
        const EventsScreen(),
        overrides: [eventsProvider.overrideWith((ref) => response)],
      ),
    );
    await tester.pump();

    expect(find.text('Tadbir'), findsOneWidget);
    expect(find.text('Uchrashuv'), findsOneWidget);
  });
}
