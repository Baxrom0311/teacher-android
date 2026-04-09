import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:teacher_school_app/data/repositories/profile_repository.dart';
import 'package:teacher_school_app/presentation/providers/profile_provider.dart';
import 'package:teacher_school_app/presentation/screens/profile/portfolio_work_create_screen.dart';

import '../../helpers/test_app.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  testWidgets('portfolio work create screen renders localized form', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        const PortfolioWorkCreateScreen(),
        overrides: [
          profileControllerProvider.overrideWith(
            (ref) => ProfileController(MockProfileRepository()),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ilmiy ish qo\'shish'), findsOneWidget);
    expect(find.text('Sarlavha'), findsOneWidget);
    expect(find.text('Nashr qilingan joy'), findsOneWidget);
    expect(find.text('Hammuallif qidirish'), findsOneWidget);
    expect(find.text('Fayl (faqat PDF)'), findsOneWidget);
    expect(find.text('Saqlash'), findsOneWidget);
  });
}
