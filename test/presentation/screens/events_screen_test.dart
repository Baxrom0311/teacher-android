import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import 'package:teacher_school_app/data/models/event_model.dart';
import 'package:teacher_school_app/l10n/app_localizations.dart';
import 'package:teacher_school_app/presentation/providers/event_provider.dart';
import 'package:teacher_school_app/presentation/screens/events/events_screen.dart';

import '../../helpers/test_app.dart';

void main() {
  testWidgets('events screen renders event cards from provider', (
    tester,
  ) async {
    final l10n = lookupAppLocalizations(const Locale('uz'));
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

    expect(find.text(l10n.eventsMenuTitle), findsOneWidget);
    expect(find.text('Fan olimpiadasi'), findsOneWidget);
    expect(
      find.text(l10n.eventsTypeLabel('exam').toUpperCase()),
      findsOneWidget,
    );
    expect(find.text('Faollar zali'), findsOneWidget);
    expect(find.text('Hududiy bosqich'), findsOneWidget);
  });

  testWidgets('events screen shows localized fallback title when empty', (
    tester,
  ) async {
    final l10n = lookupAppLocalizations(const Locale('uz'));
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

    expect(find.text(l10n.eventFallbackTitle), findsOneWidget);
    expect(
      find.text(l10n.eventsTypeLabel('meeting').toUpperCase()),
      findsOneWidget,
    );
  });
}
