import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:teacher_school_app/data/repositories/homework_repository.dart';
import 'package:teacher_school_app/presentation/providers/homework_provider.dart';
import 'package:teacher_school_app/presentation/screens/homework/homework_create_screen.dart';

import '../../helpers/test_app.dart';

class MockHomeworkRepository extends Mock implements HomeworkRepository {}

void main() {
  testWidgets('homework create screen renders localized form', (tester) async {
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

    expect(find.text('Yangi vazifa'), findsOneWidget);
    expect(find.text('Sarlavha'), findsOneWidget);
    expect(find.text('Tavsif'), findsOneWidget);
    expect(find.text('Topshirish muddati (ixtiyoriy)'), findsOneWidget);
    expect(find.text('Muddatni tanlang'), findsOneWidget);
    expect(find.text('Saqlash'), findsOneWidget);
  });
}
