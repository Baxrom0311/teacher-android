import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:teacher_school_app/core/routing/app_router.dart';
import 'package:teacher_school_app/data/repositories/auth_repository.dart';
import 'package:teacher_school_app/data/repositories/notification_repository.dart';
import 'package:teacher_school_app/presentation/providers/auth_provider.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockNotificationRepository extends Mock
    implements NotificationRepository {}

class TestAuthController extends AuthController {
  TestAuthController(super.repository, super.notificationRepository);

  void update(AuthState nextState) {
    state = nextState;
  }
}

void main() {
  test(
    'router provider keeps the same GoRouter instance across auth changes',
    () async {
      final authRepository = MockAuthRepository();
      final notificationRepository = MockNotificationRepository();
      when(() => authRepository.hasToken()).thenAnswer((_) async => false);

      final authController = TestAuthController(
        authRepository,
        notificationRepository,
      );
      final container = ProviderContainer(
        overrides: [
          authControllerProvider.overrideWith((ref) => authController),
        ],
      );
      addTearDown(container.dispose);

      final initialRouter = container.read(routerProvider);
      final secondRead = container.read(routerProvider);

      expect(identical(initialRouter, secondRead), isTrue);

      authController.update(AuthState(isLoading: false, isAuthenticated: true));
      await Future<void>.delayed(Duration.zero);

      final routerAfterAuthChange = container.read(routerProvider);
      expect(identical(initialRouter, routerAfterAuthChange), isTrue);
    },
  );
}
