import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import 'package:teacher_school_app/data/models/dashboard_model.dart';
import 'package:teacher_school_app/data/models/teacher_model.dart';
import 'package:teacher_school_app/l10n/app_localizations.dart';
import 'package:teacher_school_app/presentation/providers/auth_provider.dart';
import 'package:teacher_school_app/presentation/providers/dashboard_provider.dart';
import 'package:teacher_school_app/presentation/screens/home/dashboard_screen.dart';

import '../../helpers/test_app.dart';

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
  testWidgets('dashboard screen renders live summary cards', (tester) async {
    final l10n = lookupAppLocalizations(const Locale('uz'));
    const dashboard = TeacherDashboardResponse(
      currentYear: DashboardPeriodData(id: 1, name: '2025/2026'),
      currentQuarter: DashboardPeriodData(id: 2, name: '3-chorak'),
      today: DashboardTodayData(
        date: '2026-04-05',
        lessonsTotal: 5,
        sessionsOpen: 2,
        sessionsClosed: 3,
        absentCount: 4,
      ),
      overview: DashboardOverviewData(
        groupsCount: 6,
        subjectsCount: 4,
        studentsCount: 112,
      ),
      recentAssessments: [
        RecentAssessmentData(
          id: 9,
          title: 'Nazorat ishi',
          date: '2026-04-04',
          maxScore: 100,
          subjectName: 'Matematika',
          groupName: '9-A',
        ),
      ],
    );

    final fakeUser = TeacherModel(
      id: 7,
      name: 'Baxrom',
      email: 'teacher@example.com',
      role: 'teacher',
    );

    await tester.pumpWidget(
      buildTestApp(
        const DashboardScreen(),
        overrides: [
          authControllerProvider.overrideWith(
            (ref) => _FakeAuthController(fakeUser),
          ),
          dashboardProvider.overrideWith((ref) => dashboard),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(l10n.dashboardHeroGreeting('Baxrom')), findsOneWidget);
    expect(
      find.text(l10n.dashboardQuickActionsTitle.toUpperCase()),
      findsOneWidget,
    );
  });
}
