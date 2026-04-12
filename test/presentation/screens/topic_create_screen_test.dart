import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:teacher_school_app/core/localization/l10n_extension.dart';

import 'package:teacher_school_app/data/models/subject_model.dart';
import 'package:teacher_school_app/data/repositories/subject_repository.dart';
import 'package:teacher_school_app/l10n/app_localizations.dart';
import 'package:teacher_school_app/presentation/providers/subject_provider.dart';
import 'package:teacher_school_app/presentation/screens/subjects/topic_create_screen.dart';

import '../../helpers/test_app.dart';

class MockSubjectRepository extends Mock implements SubjectRepository {}

void main() {
  testWidgets('topic create screen renders localized form', (tester) async {
    final l10n = lookupAppLocalizations(const Locale('uz'));
    await tester.pumpWidget(
      buildTestApp(
        TopicCreateScreen(
          subjectId: 3,
          groupContext: SubjectDetail(
            groupSubjectId: 7,
            groupId: 2,
            groupName: '7-A',
            topics: const [],
          ),
        ),
        overrides: [
          subjectControllerProvider.overrideWith(
            (ref) => SubjectController(MockSubjectRepository()),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(l10n.newTopicTitle), findsOneWidget);
    expect(find.text(l10n.topicTitleLabel.toUpperCase()), findsOneWidget);
    expect(find.text(l10n.topicDescriptionLabel.toUpperCase()), findsOneWidget);
    expect(find.text(l10n.groupLabelText('7-A')), findsOneWidget);
    expect(find.text(l10n.attachedFilesTitle.toUpperCase()), findsOneWidget);
    expect(find.text(l10n.addTopicAction), findsOneWidget);
  });
}
