import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teacher_school_app/l10n/app_localizations.dart';

import 'package:teacher_school_app/presentation/screens/conference/conference_create_screen.dart';

import '../../helpers/test_app.dart';

void main() {
  testWidgets('conference create screen renders localized empty state', (
    tester,
  ) async {
    final l10n = lookupAppLocalizations(const Locale('uz'));
    await tester.pumpWidget(buildTestApp(const ConferenceCreateScreen()));
    await tester.pumpAndSettle();

    expect(find.text(l10n.conferenceCreateTitle), findsOneWidget);
    expect(
      find.text(l10n.conferenceSelectDateLabel.toUpperCase()),
      findsOneWidget,
    );
    expect(
      find.text(l10n.conferenceLocationLabel.toUpperCase()),
      findsOneWidget,
    );
    expect(find.text(l10n.conferenceNoSlots), findsOneWidget);
    expect(find.text(l10n.saveAction), findsOneWidget);
  });
}
