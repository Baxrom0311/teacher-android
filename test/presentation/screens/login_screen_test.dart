import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teacher_school_app/core/storage/shared_prefs_service.dart';
import 'package:teacher_school_app/data/repositories/auth_repository.dart';
import 'package:teacher_school_app/data/repositories/notification_repository.dart';
import 'package:teacher_school_app/presentation/providers/auth_provider.dart';
import 'package:teacher_school_app/presentation/screens/auth/login_screen.dart';

import '../../helpers/test_app.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockNotificationRepository extends Mock
    implements NotificationRepository {}

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await SharedPrefsService.init();
  });

  testWidgets('login screen renders localized form', (tester) async {
    final authRepository = MockAuthRepository();
    final notificationRepository = MockNotificationRepository();

    when(() => authRepository.hasToken()).thenAnswer((_) async => false);

    await tester.pumpWidget(
      buildTestApp(
        const LoginScreen(),
        overrides: [
          authControllerProvider.overrideWith(
            (ref) => AuthController(authRepository, notificationRepository),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Teacher Portal'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Parol'), findsOneWidget);
    expect(find.text('Kirish'), findsOneWidget);
  });
}
