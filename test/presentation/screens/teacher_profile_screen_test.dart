import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teacher_school_app/data/models/profile_model.dart';
import 'package:teacher_school_app/data/models/teacher_model.dart';
import 'package:teacher_school_app/presentation/providers/profile_provider.dart';
import 'package:teacher_school_app/presentation/screens/profile/teacher_profile_screen.dart';

import '../../helpers/test_app.dart';

void main() {
  testWidgets('teacher profile screen renders works and document states', (
    tester,
  ) async {
    final response = ProfileResponse(
      teacher: TeacherModel(
        id: 3,
        name: 'Dilshod Ustoz',
        email: 'dilshod@example.com',
        phone: '+998901112233',
        passportNo: 'AB1234567',
        role: 'teacher',
      ),
      profile: TeacherProfileData(
        id: 1,
        userId: 3,
        university: 'TATU',
        specialization: 'Matematika',
        category: '1-toifa',
        graduationDate: '2018-06-30',
        diplomaUrl: 'https://example.com/diploma.pdf',
      ),
      works: [
        ScientificWorkData(
          id: 7,
          title: 'STEAM yondashuvi',
          publishedAt: '2026-03-20',
          publishedPlace: 'Xalq ta\'limi jurnali',
          fileUrl: 'https://example.com/work.pdf',
          createdBy: 3,
          authors: const [
            TeacherCoauthorData(id: 3, name: 'Dilshod Ustoz'),
            TeacherCoauthorData(id: 8, name: 'Malika Ustoz'),
          ],
        ),
      ],
      canEdit: true,
    );

    await tester.pumpWidget(
      buildTestApp(
        const TeacherProfileScreen(),
        overrides: [profileProvider.overrideWith((ref) => response)],
      ),
    );
    await tester.pump();

    expect(find.text('Dilshod Ustoz'), findsWidgets);
    expect(find.textContaining('AB1234567'), findsOneWidget);
    expect(find.text('Diplom'), findsOneWidget);
    expect(find.text('Yuklangan'), findsOneWidget);
    expect(find.text('Yuklanmagan'), findsOneWidget);
    await tester.dragUntilVisible(
      find.text('Ilmiy Ishlar (Portfolio)'),
      find.byType(Scrollable),
      const Offset(0, -120),
    );
    expect(find.text('Ilmiy Ishlar (Portfolio)'), findsOneWidget);
    expect(find.text('Profil va Sozlamalar'), findsOneWidget);
  });

  testWidgets('teacher profile screen uses localized fallback names', (
    tester,
  ) async {
    final response = ProfileResponse(
      teacher: TeacherModel(id: 9, name: '', email: '', role: 'teacher'),
      profile: null,
      works: [
        ScientificWorkData(
          id: 11,
          title: '',
          publishedAt: null,
          publishedPlace: null,
          fileUrl: null,
          createdBy: 9,
          authors: const [TeacherCoauthorData(id: 9, name: '')],
        ),
      ],
      canEdit: true,
    );

    await tester.pumpWidget(
      buildTestApp(
        const TeacherProfileScreen(),
        overrides: [profileProvider.overrideWith((ref) => response)],
      ),
    );
    await tester.pump();

    expect(find.text('O\'qituvchi'), findsWidgets);
    expect(find.text('Ilmiy ish'), findsOneWidget);
  });
}
