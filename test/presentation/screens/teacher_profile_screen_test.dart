import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import 'package:teacher_school_app/data/models/profile_model.dart';
import 'package:teacher_school_app/data/models/teacher_model.dart';
import 'package:teacher_school_app/l10n/app_localizations.dart';
import 'package:teacher_school_app/presentation/providers/profile_provider.dart';
import 'package:teacher_school_app/presentation/screens/profile/teacher_profile_screen.dart';

import '../../helpers/test_app.dart';

void main() {
  testWidgets('teacher profile screen renders works and document states', (
    tester,
  ) async {
    final l10n = lookupAppLocalizations(const Locale('uz'));
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
    await tester.pumpAndSettle();

    expect(find.text('Dilshod Ustoz'), findsWidgets);
    expect(find.text('TATU'), findsOneWidget);
    await tester.dragUntilVisible(
      find.text(l10n.documentsTitle.toUpperCase()),
      find.byType(Scrollable),
      const Offset(0, -120),
    );
    expect(find.text(l10n.documentsTitle.toUpperCase()), findsOneWidget);
    expect(find.text(l10n.uploadedStatus), findsOneWidget);
    expect(find.text(l10n.notUploadedStatus), findsOneWidget);
    await tester.dragUntilVisible(
      find.text(l10n.portfolioTitle.toUpperCase()),
      find.byType(Scrollable),
      const Offset(0, -120),
    );
    expect(find.text(l10n.portfolioTitle.toUpperCase()), findsOneWidget);
    await tester.dragUntilVisible(
      find.text(l10n.settingsTitle.toUpperCase()),
      find.byType(Scrollable),
      const Offset(0, -120),
    );
    expect(find.text(l10n.settingsTitle.toUpperCase()), findsOneWidget);
  });

  testWidgets('teacher profile screen uses localized fallback names', (
    tester,
  ) async {
    final l10n = lookupAppLocalizations(const Locale('uz'));
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
    await tester.pumpAndSettle();

    expect(find.text(l10n.teacherFallbackName), findsWidgets);
    expect(find.text(l10n.scientificWorkTitle), findsOneWidget);
  });
}
