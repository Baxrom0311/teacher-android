import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/profile_model.dart';
import '../../data/models/subject_model.dart';
import '../../presentation/providers/auth_provider.dart';
import '../../presentation/screens/assessments/assessment_create_screen.dart';
import '../../presentation/screens/assessments/assessment_results_screen.dart';
import '../../presentation/screens/assessments/assessments_list_screen.dart';
import '../../presentation/screens/attendance/absence_review_screen.dart';
import '../../presentation/screens/attendance/attendance_create_screen.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/chat/chat_contacts_screen.dart';
import '../../presentation/screens/chat/chat_room_screen.dart';
import '../../presentation/screens/conference/conference_create_screen.dart';
import '../../presentation/screens/events/events_screen.dart';
import '../../presentation/screens/grades/grades_list_screen.dart';
import '../../presentation/screens/home/dashboard_screen.dart';
import '../../presentation/screens/home/main_navigation_layout.dart';
import '../../presentation/screens/homework/homework_check_screen.dart';
import '../../presentation/screens/homework/homework_create_screen.dart';
import '../../presentation/screens/homework/homework_list_screen.dart';
import '../../presentation/screens/library/library_screen.dart';
import '../../presentation/screens/lessons/lesson_session_screen.dart';
import '../../presentation/screens/lessons/today_lessons_screen.dart';
import '../../presentation/screens/meals/meals_list_screen.dart';
import '../../presentation/screens/notifications/notifications_screen.dart';
import '../../presentation/screens/payments/payment_detail_screen.dart';
import '../../presentation/screens/payments/payments_screen.dart';
import '../../presentation/screens/profile/portfolio_work_create_screen.dart';
import '../../presentation/screens/profile/profile_edit_screen.dart';
import '../../presentation/screens/profile/teacher_profile_screen.dart';
import '../../presentation/screens/subjects/subject_detail_screen.dart';
import '../../presentation/screens/subjects/subjects_list_screen.dart';
import '../../presentation/screens/subjects/topic_create_screen.dart';
import '../../presentation/screens/timetable/timetable_screen.dart';
import '../constants/app_routes.dart';
import '../localization/app_localizations.dart';

final routerNotifierProvider = ChangeNotifierProvider(
  (ref) => TeacherRouterNotifier(ref),
);

class TeacherRouterNotifier extends ChangeNotifier {
  final Ref _ref;

  TeacherRouterNotifier(this._ref) {
    _ref.listen<AuthState>(
      authControllerProvider,
      (_, __) => notifyListeners(),
    );
  }

  String? redirect(BuildContext context, GoRouterState state) {
    final authState = _ref.read(authControllerProvider);
    final location = state.matchedLocation;
    final isPublicRoute = TeacherAppRouter.publicRoutes.contains(location);

    if (authState.isLoading) {
      return null;
    }

    if (!authState.isAuthenticated && !isPublicRoute) {
      return TeacherRoutes.login;
    }

    if (authState.isAuthenticated && isPublicRoute) {
      return TeacherRoutes.dashboard;
    }

    return null;
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final routerNotifier = ref.watch(routerNotifierProvider.notifier);

  return GoRouter(
    navigatorKey: TeacherAppRouter.rootNavigatorKey,
    initialLocation: TeacherRoutes.login,
    debugLogDiagnostics: kDebugMode,
    refreshListenable: routerNotifier,
    redirect: routerNotifier.redirect,
    routes: TeacherAppRouter.routes,
  );
});

class TeacherAppRouter {
  TeacherAppRouter._();

  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');
  static final GlobalKey<NavigatorState> shellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'shell');

  static const Set<String> publicRoutes = {TeacherRoutes.login};

  static final List<RouteBase> routes = [
    GoRoute(
      path: TeacherRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: TeacherRoutes.lessonSession,
      builder: (context, state) {
        final sessionId = int.parse(state.pathParameters['id']!);
        return LessonSessionScreen(sessionId: sessionId);
      },
    ),
    GoRoute(
      path: TeacherRoutes.attendanceCreate,
      builder: (context, state) => const AttendanceCreateScreen(),
    ),
    GoRoute(
      path: TeacherRoutes.homeworkList,
      builder: (context, state) => const HomeworkListScreen(),
    ),
    GoRoute(
      path: TeacherRoutes.homeworkCreate,
      builder: (context, state) {
        final sessionId = int.parse(state.pathParameters['sessionId']!);
        return HomeworkCreateScreen(sessionId: sessionId);
      },
    ),
    GoRoute(
      path: TeacherRoutes.homeworkCheck,
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        final title =
            state.extra as String? ??
            AppLocalizationsRegistry.instance.reviewHomeworkTitle;
        return HomeworkCheckScreen(lessonHomeworkId: id, title: title);
      },
    ),
    GoRoute(
      path: TeacherRoutes.assessmentsList,
      builder: (context, state) => const AssessmentsListScreen(),
    ),
    GoRoute(
      path: TeacherRoutes.assessmentCreate,
      builder: (context, state) => const AssessmentCreateScreen(),
    ),
    GoRoute(
      path: TeacherRoutes.assessmentResults,
      builder: (context, state) {
        final assessmentId = int.parse(state.pathParameters['id']!);
        final title =
            state.extra as String? ??
            AppLocalizationsRegistry.instance.assessmentResultsTitle;
        return AssessmentResultsScreen(
          assessmentId: assessmentId,
          title: title,
        );
      },
    ),
    GoRoute(
      path: TeacherRoutes.subjectsList,
      builder: (context, state) => const SubjectsListScreen(),
    ),
    GoRoute(
      path: TeacherRoutes.subjectDetail,
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        final title =
            state.extra as String? ??
            AppLocalizationsRegistry.instance.subjectLessonsTitle;
        return SubjectDetailScreen(subjectId: id, title: title);
      },
    ),
    GoRoute(
      path: TeacherRoutes.topicCreate,
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        final groupContext = state.extra as SubjectDetail;
        return TopicCreateScreen(subjectId: id, groupContext: groupContext);
      },
    ),
    GoRoute(
      path: TeacherRoutes.timetable,
      builder: (context, state) => const TimetableScreen(),
    ),
    GoRoute(
      path: TeacherRoutes.gradesList,
      builder: (context, state) => const GradesListScreen(),
    ),
    GoRoute(
      path: TeacherRoutes.notifications,
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: TeacherRoutes.events,
      builder: (context, state) => const EventsScreen(),
    ),
    GoRoute(
      path: TeacherRoutes.absenceReview,
      builder: (context, state) => const AbsenceReviewScreen(),
    ),
    GoRoute(
      path: TeacherRoutes.conferencesManage,
      builder: (context, state) => const ConferenceCreateScreen(),
    ),
    GoRoute(
      path: TeacherRoutes.library,
      builder: (context, state) => const LibraryScreen(),
    ),
    GoRoute(
      path: TeacherRoutes.meal,
      builder: (context, state) => const MealsListScreen(),
    ),
    GoRoute(
      path: TeacherRoutes.payments,
      builder: (context, state) => const PaymentsScreen(),
    ),
    GoRoute(
      path: TeacherRoutes.paymentDetail,
      builder: (context, state) {
        final id = int.parse(state.pathParameters['studentId']!);
        return PaymentDetailScreen(studentId: id);
      },
    ),
    GoRoute(
      path: TeacherRoutes.profileEdit,
      builder: (context, state) {
        final profile = state.extra as ProfileResponse;
        return ProfileEditScreen(currentProfile: profile);
      },
    ),
    GoRoute(
      path: TeacherRoutes.portfolioWorkCreate,
      builder: (context, state) => const PortfolioWorkCreateScreen(),
    ),
    GoRoute(
      path: TeacherRoutes.chatRoom,
      builder: (context, state) {
        final id = int.parse(state.pathParameters['userId']!);
        final name =
            state.extra as String? ??
            AppLocalizationsRegistry.instance.userFallbackName;
        return ChatRoomScreen(userId: id, userName: name);
      },
    ),
    ShellRoute(
      navigatorKey: shellNavigatorKey,
      builder: (context, state, child) => MainNavigationLayout(child: child),
      routes: [
        GoRoute(
          path: TeacherRoutes.dashboard,
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: TeacherRoutes.lessons,
          builder: (context, state) => const TodayLessonsScreen(),
        ),
        GoRoute(
          path: TeacherRoutes.chat,
          builder: (context, state) => const ChatContactsScreen(),
        ),
        GoRoute(
          path: TeacherRoutes.profile,
          builder: (context, state) => const TeacherProfileScreen(),
        ),
      ],
    ),
  ];
}
