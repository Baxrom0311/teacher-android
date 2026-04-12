import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:teacher_school_app/l10n/app_localizations.dart';

import 'package:teacher_school_app/data/repositories/homework_repository.dart';
import 'package:teacher_school_app/presentation/providers/homework_provider.dart';
import 'package:teacher_school_app/presentation/screens/homework/homework_create_screen.dart';

import '../../helpers/test_app.dart';

class MockHomeworkRepository extends Mock implements HomeworkRepository {}

void main() {
  testWidgets('homework create screen renders localized form', (tester) async {
    final l10n = lookupAppLocalizations(const Locale('uz'));

    await tester.pumpWidget(
      buildTestApp(
        const HomeworkCreateScreen(sessionId: 12),
        overrides: [
          homeworkControllerProvider.overrideWith(
            (ref) => HomeworkController(MockHomeworkRepository()),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(l10n.homeworkCreateTitle), findsOneWidget);
    expect(find.text(l10n.homeworkTitleLabel.toUpperCase()), findsOneWidget);
    expect(
      find.text(l10n.homeworkDescriptionTitle.toUpperCase()),
      findsOneWidget,
    );
    expect(find.text(l10n.homeworkDueDateTitle.toUpperCase()), findsOneWidget);
    expect(find.text(l10n.homeworkSelectDueDate), findsOneWidget);
    expect(find.text(l10n.saveAction.toUpperCase()), findsOneWidget);
  });
}
