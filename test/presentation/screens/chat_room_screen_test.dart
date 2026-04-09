import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:teacher_school_app/data/models/teacher_model.dart';
import 'package:teacher_school_app/data/repositories/chat_repository.dart';
import 'package:teacher_school_app/presentation/providers/auth_provider.dart';
import 'package:teacher_school_app/presentation/providers/chat_provider.dart';
import 'package:teacher_school_app/presentation/screens/chat/chat_room_screen.dart';

import '../../helpers/test_app.dart';

class MockChatRepository extends Mock implements ChatRepository {}

class _FakeAuthController extends StateNotifier<AuthState>
    implements AuthController {
  _FakeAuthController(TeacherModel user)
    : super(AuthState(isLoading: false, isAuthenticated: true, user: user));

  @override
  Future<void> checkAuthStatus() async {}

  @override
  Future<bool> login(
    String username,
    String password,
    String deviceName,
  ) async {
    return true;
  }

  @override
  Future<void> logout() async {
    state = state.copyWith(
      isLoading: false,
      isAuthenticated: false,
      user: null,
    );
  }

  @override
  Future<void> handleSessionExpired() async {
    state = state.copyWith(
      isLoading: false,
      isAuthenticated: false,
      user: null,
      error: 'Sessiya tugadi',
    );
  }

  @override
  void clearError() {
    state = state.copyWith(error: null);
  }
}

void main() {
  testWidgets('chat room screen renders localized empty state and input hint', (
    tester,
  ) async {
    final repository = MockChatRepository();
    when(() => repository.fetchMessages(7)).thenAnswer((_) async => const []);

    final fakeUser = TeacherModel(
      id: 9,
      name: 'Dilshod',
      email: 'dilshod@example.com',
      role: 'teacher',
    );

    await tester.pumpWidget(
      buildTestApp(
        const ChatRoomScreen(userId: 7, userName: 'Dilshod Ustoz'),
        overrides: [
          chatRepositoryProvider.overrideWithValue(repository),
          authControllerProvider.overrideWith(
            (ref) => _FakeAuthController(fakeUser),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Dilshod Ustoz'), findsOneWidget);
    expect(
      find.text(
        'Xabarlar yo\'q. Uning bilan birinchi bo\'lib muloqotni boshlang.',
      ),
      findsOneWidget,
    );
    expect(find.text('Xabar yuborish'), findsOneWidget);
  });
}
