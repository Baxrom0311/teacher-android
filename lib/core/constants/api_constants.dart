class ApiConstants {
  static const String _defaultBaseUrl = 'https://ranchschool.izlash.uz';
  static const String _envBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: _defaultBaseUrl,
  );
  static const String _envHostHeader = String.fromEnvironment(
    'API_HOST_HEADER',
    defaultValue: '',
  );

  static String get baseUrl =>
      _envBaseUrl.isEmpty ? _defaultBaseUrl : _envBaseUrl;
  static String? get hostHeader {
    final trimmed = _envHostHeader.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  static Map<String, String> get defaultHeaders {
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    final host = hostHeader;
    if (host != null) {
      headers['Host'] = host;
    }
    return headers;
  }

  static const String apiPrefix = '/api';

  // Auth
  static const String login = '$apiPrefix/login';
  static const String logout = '$apiPrefix/logout';
  static const String me = '$apiPrefix/me';

  // Dashboard
  static const String dashboard = '$apiPrefix/teacher/dashboard';

  // Lessons
  static const String todayLessons = '$apiPrefix/teacher/lessons/today';
  static String startLesson(int id) => '$apiPrefix/teacher/lessons/$id/start';
  static String lessonSession(int id) =>
      '$apiPrefix/teacher/lesson-sessions/$id';
  static String saveLessonSession(int id) =>
      '$apiPrefix/teacher/lesson-sessions/$id/save';
  static String saveLessonHomework(int id) =>
      '$apiPrefix/teacher/lesson-sessions/$id/homework';

  // Attendance
  static const String attendances = '$apiPrefix/teacher/attendance';
  static const String attendanceOptions =
      '$apiPrefix/teacher/attendance/options';
  static String attendanceDetail(int id) => '$apiPrefix/teacher/attendance/$id';

  // Homework
  static const String homeworksList = '$apiPrefix/teacher/homeworks';
  static const String lessonHomeworks = homeworksList;
  static String gradeHomework(int id) =>
      '$apiPrefix/teacher/homeworks/submissions/$id/grade';

  // Chat
  static const String chatContacts = '$apiPrefix/teacher/chat/contacts';
  static String chatMessages(int userId) =>
      '$apiPrefix/teacher/chat/messages/$userId';
  static const String sendChatMessage = '$apiPrefix/teacher/chat/messages';
  static const String sendChatFile = '$apiPrefix/teacher/chat/files';

  // Assessments
  static const String assessments = '$apiPrefix/teacher/assessments';
  static const String assessmentOptions =
      '$apiPrefix/teacher/assessments/options';
  static String assessmentDetail(int id) =>
      '$apiPrefix/teacher/assessments/$id';
  static String assessmentResults(int id) =>
      '$apiPrefix/teacher/assessments/$id/results';

  // Subjects
  static const String subjects = '$apiPrefix/teacher/subjects';
  static String subjectDetail(int id) => '$apiPrefix/teacher/subjects/$id';
  static String subjectTopics(int id) =>
      '$apiPrefix/teacher/subjects/$id/topics';
  static String topicResources(int subjectId, int topicId) =>
      '$apiPrefix/teacher/subjects/$subjectId/topics/$topicId/resources';

  // Timetable
  static const String timetable = '$apiPrefix/teacher/timetable';

  // Grades Summary
  static const String gradesQuarter = '$apiPrefix/teacher/grades/quarter';
  static const String gradesYear = '$apiPrefix/teacher/grades/year';

  // Profile Sync
  static const String profile = '$apiPrefix/teacher/profile';
  static const String profileWorks = '$apiPrefix/teacher/profile/works';
  static String deleteWork(int id) => '$apiPrefix/teacher/profile/works/$id';
  static const String profileCoauthors = '$apiPrefix/teacher/profile/coauthors';

  // Meals
  static const String meals = '$apiPrefix/teacher/meals';

  // Payments
  static const String payments = '$apiPrefix/teacher/payments';
  static String paymentDetail(int id) => '$apiPrefix/teacher/payments/$id';

  // Notifications
  static const String notifications = '$apiPrefix/notifications';
  static const String saveFcmToken = '$apiPrefix/notifications/token';
  static String markNotificationAsRead(int id) =>
      '$apiPrefix/notifications/$id/read';

  // Events
  static const String events = '$apiPrefix/events';

  // Library
  static const String libraryBooks = '$apiPrefix/library/books';
  static const String libraryMyLoans = '$apiPrefix/library/my-loans';
  static String borrowBook(int id) => '$apiPrefix/library/books/$id/borrow';
  static String returnLoan(int id) => '$apiPrefix/library/loans/$id/return';

  // WebSocket (Laravel Reverb)
  static const String reverbKey = String.fromEnvironment(
    'REVERB_APP_KEY',
    defaultValue: 'local',
  );
  static const String reverbHost = String.fromEnvironment(
    'REVERB_HOST',
    defaultValue: 'ranchschool.izlash.uz',
  );
  static const int reverbPort = int.fromEnvironment(
    'REVERB_PORT',
    defaultValue: 443,
  );
  static const String reverbScheme = String.fromEnvironment(
    'REVERB_SCHEME',
    defaultValue: 'https',
  );
}
