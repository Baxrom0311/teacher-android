import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:teacher_school_app/data/models/profile_model.dart';
import 'package:teacher_school_app/data/models/teacher_model.dart';
import 'package:teacher_school_app/data/repositories/profile_repository.dart';
import 'package:teacher_school_app/presentation/providers/profile_provider.dart';
import 'package:teacher_school_app/presentation/screens/profile/profile_edit_screen.dart';

import '../../helpers/test_app.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  testWidgets('profile edit screen renders localized fields', (tester) async {
    final profile = ProfileResponse(
      teacher: TeacherModel(
        id: 1,
        name: 'Malika',
        email: 'malika@example.com',
        role: 'teacher',
      ),
      profile: TeacherProfileData(
        id: 1,
        userId: 1,
        university: 'TATU',
        specialization: 'Matematika',
        graduationDate: '2020-06-01',
        address: 'Samarqand',
        category: '1-toifa',
        gender: 'female',
        achievements: 'Olimpiada g\'olibi',
        diplomaUrl: 'https://example.com/diploma.pdf',
      ),
      works: const [],
      canEdit: true,
    );

    await tester.pumpWidget(
      buildTestApp(
        ProfileEditScreen(currentProfile: profile),
        overrides: [
          profileControllerProvider.overrideWith(
            (ref) => ProfileController(MockProfileRepository()),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Profilni tahrirlash'), findsOneWidget);
    expect(find.text('Universitet'), findsOneWidget);
    expect(find.text('Mutaxassislik'), findsOneWidget);
    expect(find.text('Diplom'), findsOneWidget);
    expect(find.text('Avval yuklangan'), findsOneWidget);
  });
}
