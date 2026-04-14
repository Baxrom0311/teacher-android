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
import '../../presentation/screens/auth/school_selection_screen.dart';
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
import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/meals/meals_list_screen.dart';
import '../../presentation/screens/notifications/notifications_screen.dart';
import '../../presentation/screens/payments/payment_detail_screen.dart';
import '../../presentation/screens/payments/payment_success_screen.dart';
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
import '../services/app_telemetry_service.dart';

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

    if (authState.isLoading && location == TeacherRoutes.splash) {
      return null;
    }

    if (!authState.isAuthenticated && !isPublicRoute) {
      if (!authState.isSchoolSelected && location != TeacherRoutes.selectSchool) {
        return TeacherRoutes.selectSchool;
      }
      if (authState.isSchoolSelected && location != TeacherRoutes.login) {
        return TeacherRoutes.login;
      }
    }

    if (authState.isAuthenticated &&
        (location == TeacherRoutes.login || 
         location == TeacherRoutes.splash || 
         location == TeacherRoutes.selectSchool)) {
      return TeacherRoutes.dashboard;
    }

    return null;
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final routerNotifier = ref.watch(routerNotifierProvider.notifier);

  return GoRouter(
    navigatorKey: TeacherAppRouter.rootNavigatorKey,
    initialLocation: TeacherRoutes.splash,
    debugLogDiagnostics: kDebugMode,
    refreshListenable: routerNotifier,
    redirect: routerNotifier.redirect,
    observers: AppTelemetryService.navigatorObservers,
    routes: TeacherAppRouter.routes,
  );
});

class TeacherAppRouter {
  TeacherAppRouter._();

  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');
  static final GlobalKey<NavigatorState> shellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'shell');

  static const Set<String> publicRoutes = {
    TeacherRoutes.login,
    TeacherRoutes.splash,
    TeacherRoutes.selectSchool,
  };

  static final List<RouteBase> routes = [
    GoRoute(
      name: TeacherRoutes.splash,
      path: TeacherRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      name: TeacherRoutes.login,
      path: TeacherRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      name: TeacherRoutes.selectSchool,
      path: TeacherRoutes.selectSchool,
      builder: (context, state) => const SchoolSelectionScreen(),
    ),
    GoRoute(
      name: TeacherRoutes.lessonSession,
      path: TeacherRoutes.lessonSession,
      builder: (context, state) {
        final sessionId = int.parse(state.pathParameters['id']!);
        return LessonSessionScreen(sessionId: sessionId);
      },
    ),
    GoRoute(
      name: TeacherRoutes.attendanceCreate,
      path: TeacherRoutes.attendanceCreate,
      builder: (context, state) => const AttendanceCreateScreen(),
    ),
    GoRoute(
      name: TeacherRoutes.homeworkList,
      path: TeacherRoutes.homeworkList,
      builder: (context, state) => const HomeworkListScreen(),
    ),
    GoRoute(
      name: TeacherRoutes.homeworkCreate,
      path: TeacherRoutes.homeworkCreate,
      builder: (context, state) {
        final sessionId = int.parse(state.pathParameters['sessionId']!);
        return HomeworkCreateScreen(sessionId: sessionId);
      },
    ),
    GoRoute(
      name: TeacherRoutes.homeworkCheck,
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
      name: TeacherRoutes.assessmentsList,
      path: TeacherRoutes.assessmentsList,
      builder: (context, state) => const AssessmentsListScreen(),
    ),
    GoRoute(
      name: TeacherRoutes.assessmentCreate,
      path: TeacherRoutes.assessmentCreate,
      builder: (context, state) => const AssessmentCreateScreen(),
    ),
    GoRoute(
      name: TeacherRoutes.assessmentResults,
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
      name: TeacherRoutes.subjectsList,
      path: TeacherRoutes.subjectsList,
      builder: (context, state) => const SubjectsListScreen(),
    ),
    GoRoute(
      name: TeacherRoutes.subjectDetail,
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
      name: TeacherRoutes.topicCreate,
      path: TeacherRoutes.topicCreate,
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        final groupContext = state.extra as SubjectDetail;
        return TopicCreateScreen(subjectId: id, groupContext: groupContext);
      },
    ),
    GoRoute(
      name: TeacherRoutes.timetable,
      path: TeacherRoutes.timetable,
      builder: (context, state) => const TimetableScreen(),
    ),
    GoRoute(
      name: TeacherRoutes.gradesList,
      path: TeacherRoutes.gradesList,
      builder: (context, state) => const GradesListScreen(),
    ),
    GoRoute(
      name: TeacherRoutes.notifications,
      path: TeacherRoutes.notifications,
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      name: TeacherRoutes.events,
      path: TeacherRoutes.events,
      builder: (context, state) => const EventsScreen(),
    ),
    GoRoute(
      name: TeacherRoutes.absenceReview,
      path: TeacherRoutes.absenceReview,
      builder: (context, state) => const AbsenceReviewScreen(),
    ),
    GoRoute(
      name: TeacherRoutes.conferencesManage,
      path: TeacherRoutes.conferencesManage,
      builder: (context, state) => const ConferenceCreateScreen(),
    ),
    GoRoute(
      name: TeacherRoutes.library,
      path: TeacherRoutes.library,
      builder: (context, state) => const LibraryScreen(),
    ),
    GoRoute(
      name: TeacherRoutes.meal,
      path: TeacherRoutes.meal,
      builder: (context, state) => const MealsListScreen(),
    ),
    GoRoute(
      name: TeacherRoutes.payments,
      path: TeacherRoutes.payments,
      builder: (context, state) => const PaymentsScreen(),
    ),
    GoRoute(
      name: TeacherRoutes.paymentDetail,
      path: TeacherRoutes.paymentDetail,
      builder: (context, state) {
        final id = int.parse(state.pathParameters['studentId']!);
        return PaymentDetailScreen(studentId: id);
      },
    ),
    GoRoute(
      name: TeacherRoutes.paymentSuccess,
      path: TeacherRoutes.paymentSuccess,
      builder: (context, state) => const PaymentSuccessScreen(),
    ),
    GoRoute(
      name: TeacherRoutes.profileEdit,
      path: TeacherRoutes.profileEdit,
      builder: (context, state) {
        final profile = state.extra as ProfileResponse;
        return ProfileEditScreen(currentProfile: profile);
      },
    ),
    GoRoute(
      name: TeacherRoutes.portfolioWorkCreate,
      path: TeacherRoutes.portfolioWorkCreate,
      builder: (context, state) => const PortfolioWorkCreateScreen(),
    ),
    GoRoute(
      name: TeacherRoutes.chatRoom,
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
          name: TeacherRoutes.dashboard,
          path: TeacherRoutes.dashboard,
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          name: TeacherRoutes.lessons,
          path: TeacherRoutes.lessons,
          builder: (context, state) => const TodayLessonsScreen(),
        ),
        GoRoute(
          name: TeacherRoutes.chat,
          path: TeacherRoutes.chat,
          builder: (context, state) => const ChatContactsScreen(),
        ),
        GoRoute(
          name: TeacherRoutes.profile,
          path: TeacherRoutes.profile,
          builder: (context, state) => const TeacherProfileScreen(),
        ),
      ],
    ),
  ];
}
