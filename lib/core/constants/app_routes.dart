class TeacherRoutes {
  TeacherRoutes._();

  static const String splash = '/splash';
  static const String dashboard = '/dashboard';
  static const String login = '/login';
  static const String selectSchool = '/select-school';
  static const String lessons = '/lessons';

  // Attendance
  static const String attendanceList = '/attendance';
  static const String attendanceCreate = '/attendance/create';
  static const String attendanceDetail = '/attendance/detail';
  static const String absenceReview = '/attendance/excuses';

  // Lessons
  static const String lessonsToday = '/lessons/today';
  static const String lessonSession = '/lessons/session/:id';
  static String lessonSessionPath(int id) => '/lessons/session/$id';

  // Homework
  static const String homeworkList = '/homework/list';
  static const String homeworkCreate = '/homework/create/:sessionId';
  static String homeworkCreatePath(int sessionId) =>
      '/homework/create/$sessionId';
  static const String homeworkCheck = '/homework/check/:id';
  static String homeworkCheckPath(int id) => '/homework/check/$id';

  // Assessments
  static const String assessmentsList = '/assessments/list';
  static const String assessmentCreate = '/assessments/create';
  static const String assessmentResults = '/assessments/:id/results';
  static String assessmentResultsPath(int id) => '/assessments/$id/results';

  // Conferences
  static const String conferencesManage = '/conferences/manage';

  // Others
  static const String subjectsList = '/subjects/list';
  static const String subjectDetail = '/subjects/:id';
  static String subjectDetailPath(int id) => '/subjects/$id';
  static const String topicCreate = '/subjects/:id/create-topic';
  static String topicCreatePath(int id) => '/subjects/$id/create-topic';
  static const String timetable = '/timetable';
  static const String gradesList = '/grades/list';
  static const String payments = '/payments';
  static const String paymentDetail = '/payments/:studentId';
  static String paymentDetailPath(int studentId) => '/payments/$studentId';
  static const String paymentSuccess = '/payments/success';
  static const String library = '/library';
  static const String events = '/events';
  static const String notifications = '/notifications';
  static const String profile = '/profile';
  static const String profileEdit = '/profile/edit';
  static const String portfolioWorkCreate = '/profile/works/create';
  static const String chat = '/chat';
  static const String chatRoom = '/chat/:userId';
  static String chatRoomPath(int userId) => '/chat/$userId';
  static const String meal = '/meal';

  // Quiz
  static const String quizList = '/quizzes';
  static const String quizCreate = '/quizzes/create';
  static const String quizResults = '/quizzes/:id/results';
  static String quizResultsPath(int id) => '/quizzes/$id/results';

  // Class Story
  static const String stories = '/stories';
  static const String storyCreate = '/stories/create';

  // Behavior
  static const String behaviorList = '/behavior';
  static const String behaviorCreate = '/behavior/create';

  // Gallery
  static const String gallery = '/gallery';
  static const String galleryAlbum = '/gallery/album';

  // Diary / Class Journal
  static const String classJournal = '/diary/class-journal/:groupId';
  static String classJournalPath(int groupId) =>
      '/diary/class-journal/$groupId';
}
