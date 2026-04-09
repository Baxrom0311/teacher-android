import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:teacher_school_app/data/models/subject_model.dart';
import 'package:teacher_school_app/data/repositories/subject_repository.dart';
import 'package:teacher_school_app/presentation/providers/subject_provider.dart';
import 'package:teacher_school_app/presentation/screens/subjects/topic_create_screen.dart';

import '../../helpers/test_app.dart';

class MockSubjectRepository extends Mock implements SubjectRepository {}

void main() {
  testWidgets('topic create screen renders localized form', (tester) async {
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

    expect(find.text('Yangi mavzu'), findsOneWidget);
    expect(find.text('Sarlavha'), findsOneWidget);
    expect(find.text('Qo\'shimcha ma\'lumotlar (ixtiyoriy)'), findsOneWidget);
    expect(find.textContaining('Guruh:'), findsOneWidget);
    expect(find.text('Biriktirilgan fayllar'), findsOneWidget);
    expect(find.text('Mavzuni qo\'shish'), findsOneWidget);
  });
}
