// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Teacher Portal';

  @override
  String get changeLanguage => 'Change language';

  @override
  String get changeTheme => 'Change theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get notificationFallbackTitle => 'New notification';

  @override
  String get close => 'Close';

  @override
  String get teacherPortal => 'Teacher Portal';

  @override
  String get teacherSubtitle => 'Sign in to manage your classes and lessons';

  @override
  String get selectSchool => 'Select school';

  @override
  String get selectSchoolSubtitle => 'Choose the school you want to sign in to';

  @override
  String get noSchoolsFound => 'No schools found';

  @override
  String get changeSchool => 'Change school';

  @override
  String get usernameLabel => 'Phone number';

  @override
  String get phoneNumberLabel => 'Phone number';

  @override
  String get phoneNumberRequired => 'Enter your phone number';

  @override
  String get usernameRequired => 'Enter your phone number';

  @override
  String get usernameMinimum => 'Enter at least 3 characters';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordRequired => 'Enter your password';

  @override
  String get passwordTooShort => 'Password must contain at least 6 characters';

  @override
  String get signIn => 'Sign in';

  @override
  String get home => 'Home';

  @override
  String get lessons => 'Lessons';

  @override
  String get chat => 'Chat';

  @override
  String get profile => 'Profile';

  @override
  String get reviewHomeworkTitle => 'Review homework';

  @override
  String get assessmentResultsTitle => 'Assessment results';

  @override
  String get subjectLessonsTitle => 'Subject lessons';

  @override
  String get userFallbackName => 'User';

  @override
  String get noInternet => 'No internet connection';

  @override
  String get errorGeneric => 'An unexpected error occurred. Please try again.';

  @override
  String get errorServer => 'Server error. Please try again later.';

  @override
  String get errorAuth => 'You are not authorized. Please sign in again.';

  @override
  String get sessionExpired =>
      'Your session expired. Sign in again to continue.';

  @override
  String get requestTimeout => 'The server timed out. Please try again.';

  @override
  String get requestCancelled => 'Request was cancelled';

  @override
  String get badRequest => 'Bad request';

  @override
  String get forbidden => 'Access denied';

  @override
  String get notFound => 'Data not found';

  @override
  String get failedFetchProfile => 'Failed to fetch user profile.';

  @override
  String get failedLoadOptions => 'Failed to load required options.';

  @override
  String get loadingTitle => 'Loading';

  @override
  String get errorTitle => 'Something went wrong';

  @override
  String get retry => 'Retry';

  @override
  String get emptyTitle => 'No data yet';

  @override
  String get todayLessonsTitle => 'Today\'s lessons';

  @override
  String get noLessonsTodayTitle => 'No lessons today';

  @override
  String get noLessonsTodayMessage => 'No lessons are scheduled for you today.';

  @override
  String get lessonsLoadingTitle => 'Loading lessons';

  @override
  String get lessonsLoadingSubtitle => 'Preparing today\'s schedule';

  @override
  String get lessonsLoadErrorTitle => 'Failed to load lessons';

  @override
  String get startLessonButton => 'Start lesson / enter';

  @override
  String get attendanceCreateTitle => 'Take attendance';

  @override
  String get attendanceCreateSavePendingMessage =>
      'Attendance save API integration is being prepared';

  @override
  String get attendanceOptionsLoadingTitle => 'Loading attendance options';

  @override
  String get attendanceOptionsLoadingSubtitle =>
      'Preparing statuses and the student list';

  @override
  String get attendanceOptionsLoadErrorTitle =>
      'Failed to load attendance options';

  @override
  String get absenceReviewTitle => 'Absence notes';

  @override
  String get absenceReviewEmptyMessage => 'No requests were found';

  @override
  String get approveAction => 'Approve';

  @override
  String get rejectAction => 'Reject';

  @override
  String get absenceReviewLoadingTitle => 'Loading absence notes';

  @override
  String get absenceReviewLoadingSubtitle =>
      'Checking new attendance-related requests';

  @override
  String get absenceReviewLoadErrorTitle => 'Failed to load absence notes';

  @override
  String get absenceApprovedSuccess => 'Approved';

  @override
  String get absenceRejectedSuccess => 'Rejected';

  @override
  String get messagesTitle => 'Messages';

  @override
  String get contactsEmptyTitle => 'No contacts found';

  @override
  String get contactsEmptyMessage => 'There are no conversations yet.';

  @override
  String get messagesLoadingTitle => 'Loading messages';

  @override
  String get messagesLoadingSubtitle => 'Preparing the chat list';

  @override
  String get messagesLoadErrorTitle => 'Failed to load messages';

  @override
  String get sendMessagePlaceholder => 'Send a message';

  @override
  String get chatRoomEmptyMessage =>
      'No messages yet. Start the conversation first.';

  @override
  String get chatSendingAttachmentPlaceholder => 'Sending file...';

  @override
  String get profileSettingsTitle => 'Profile & settings';

  @override
  String get scientificWorkDeleted => 'Scientific work deleted';

  @override
  String get teacherFallbackName => 'Teacher';

  @override
  String get teacherEmailFallback => 'teacher@eschool.uz';

  @override
  String get infoSectionTitle => 'Information';

  @override
  String get universityLabel => 'University';

  @override
  String get specializationLabel => 'Specialization';

  @override
  String get categoryLabel => 'Category';

  @override
  String get graduationDateLabel => 'Graduation date';

  @override
  String get addressLabel => 'Address';

  @override
  String get genderLabel => 'Gender';

  @override
  String get achievementsLabel => 'Achievements';

  @override
  String get documentsTitle => 'Documents';

  @override
  String get diplomaTitle => 'Diploma';

  @override
  String get passportCopyTitle => 'Passport copy';

  @override
  String get uploadedStatus => 'Uploaded';

  @override
  String get notUploadedStatus => 'Not uploaded';

  @override
  String get portfolioTitle => 'Scientific works (portfolio)';

  @override
  String get portfolioEmptyTitle => 'Portfolio is empty';

  @override
  String get portfolioEmptyMessage =>
      'No scientific works have been added yet.';

  @override
  String get pdfUploadedLabel => 'PDF uploaded';

  @override
  String get notificationsCenterTitle => 'Notifications';

  @override
  String get notificationsCenterSubtitle => 'Teacher notification center';

  @override
  String get notificationsLoadingTitle => 'Loading notifications';

  @override
  String get notificationsLoadingSubtitle => 'Checking for new messages';

  @override
  String get notificationsLoadErrorTitle => 'Failed to load notifications';

  @override
  String get notificationsEmptyTitle => 'No notifications';

  @override
  String get notificationsEmptyMessage =>
      'There are no new notifications for you yet.';

  @override
  String get libraryMenuTitle => 'Library';

  @override
  String get libraryMenuSubtitle => 'Borrow and return books';

  @override
  String get eventsMenuTitle => 'Events';

  @override
  String get eventsMenuSubtitle => 'List of school events';

  @override
  String get logoutTitle => 'Log out';

  @override
  String get logoutConfirmMessage =>
      'Are you sure you want to log out of your account?';

  @override
  String get cancel => 'Cancel';

  @override
  String get logoutAction => 'Log out';

  @override
  String get profileLoadingTitle => 'Loading profile';

  @override
  String get profileLoadingSubtitle => 'Preparing teacher information';

  @override
  String get profileLoadErrorTitle => 'Failed to load profile';

  @override
  String get timetableTitle => 'Lesson schedule';

  @override
  String get noLessonsOnSelectedDate => 'There are no lessons on this date';

  @override
  String get unknownSubjectFallback => 'Unknown subject';

  @override
  String get roomFallback => 'Room -';

  @override
  String get subjectsTitle => 'My subjects';

  @override
  String get noAssignedSubjects => 'No subjects are assigned to you.';

  @override
  String get addTopicTooltip => 'Add a new topic';

  @override
  String get noTopicsYet => 'No topics yet';

  @override
  String get noTopicsForGroup =>
      'No topics have been added for this group yet.';

  @override
  String get filesTitle => 'Files';

  @override
  String get fileOpenFailed => 'Sorry, the file could not be opened';

  @override
  String get newTopicTitle => 'New topic';

  @override
  String get topicTitleLabel => 'Title';

  @override
  String get topicTitleHint => 'Topic name';

  @override
  String get topicDescriptionLabel => 'Additional information (optional)';

  @override
  String get topicDescriptionHint => 'Comment...';

  @override
  String get attachedFilesTitle => 'Attached files';

  @override
  String get chooseFileAction => 'Choose file';

  @override
  String get noFilesSelected => 'No files selected yet.';

  @override
  String get addTopicAction => 'Add topic';

  @override
  String get topicTitleRequired => 'Enter the topic title';

  @override
  String get topicFilesRequired => 'Upload at least one PDF/DOC/image file';

  @override
  String get topicSaved => 'Topic saved';

  @override
  String get paymentsTitle => 'Payments (students)';

  @override
  String get allGroups => 'All groups';

  @override
  String get searchStudentHint => 'Search student...';

  @override
  String get noStudentsFound => 'No students found.';

  @override
  String get paidStatus => 'Paid';

  @override
  String get debtorStatus => 'Debtor';

  @override
  String get studentPaymentsTitle => 'Student payments';

  @override
  String get newPaymentTitle => 'New payment';

  @override
  String get paymentTypeLabel => 'Payment type';

  @override
  String get monthlyPaymentType => 'Monthly payment';

  @override
  String get yearlyPaymentType => 'Yearly payment';

  @override
  String get yearLabel => 'Year';

  @override
  String get monthLabel => 'Month';

  @override
  String get paymentMethodLabel => 'Payment method';

  @override
  String get paymentMethodCash => 'Cash';

  @override
  String get paymentMethodCard => 'Card';

  @override
  String get paymentMethodTransfer => 'Card transfer (P2P)';

  @override
  String get paymentMethodTerminal => 'Terminal';

  @override
  String get amountLabel => 'Amount';

  @override
  String get amountCurrencyLabel => 'Amount (UZS)';

  @override
  String get noteOptional => 'Note (optional)';

  @override
  String get confirmAction => 'Confirm';

  @override
  String get paymentAmountRequired => 'Enter the payment amount';

  @override
  String get paymentAccepted => 'Payment received!';

  @override
  String get paymentHistoryTitle => 'Payment history';

  @override
  String get noPaymentsForStudent => 'This student has no payments yet.';

  @override
  String get monthlyFeeLabel => 'Monthly fee';

  @override
  String get discountLabel => 'Discount';

  @override
  String get currencySymbol => 'UZS';

  @override
  String get saveAction => 'Save';

  @override
  String get editAction => 'Edit';

  @override
  String get homeworkListTitle => 'Homework';

  @override
  String get noAssignedHomeworks => 'No homework has been assigned yet.';

  @override
  String get homeworkGroupFallback => 'Group';

  @override
  String get homeworkDescriptionFallback => 'No description';

  @override
  String get homeworkCreateTitle => 'New homework';

  @override
  String get homeworkTitleLabel => 'Title';

  @override
  String get homeworkTitleHint => 'Example: exercise 5';

  @override
  String get homeworkDescriptionTitle => 'Description';

  @override
  String get homeworkDescriptionHint => 'More details about the task...';

  @override
  String get homeworkDueDateTitle => 'Due date (optional)';

  @override
  String get homeworkSelectDueDate => 'Select a deadline';

  @override
  String get homeworkTitleRequired => 'Enter the title';

  @override
  String get homeworkCreatedSuccess => 'Homework created!';

  @override
  String get homeworkCheckDialogTitle => 'Set grade';

  @override
  String get homeworkCommentHint => 'Comment (optional)';

  @override
  String get homeworkNoSubmissions => 'No homework has been submitted yet.';

  @override
  String get homeworkGradedStatus => 'Graded';

  @override
  String get homeworkSubmittedStatus => 'Submitted';

  @override
  String get homeworkViewFileAction => 'View file';

  @override
  String get gradeAction => 'Set grade';

  @override
  String get eventsEmptyTitle => 'No active events';

  @override
  String get eventsEmptyMessage =>
      'No active school events have been posted yet.';

  @override
  String get eventsLoadingTitle => 'Loading events';

  @override
  String get eventsLoadingSubtitle => 'Updating the school calendar';

  @override
  String get eventsLoadErrorTitle => 'Failed to load events';

  @override
  String get eventFallbackTitle => 'Event';

  @override
  String get eventDateUnavailable => 'Date not specified';

  @override
  String get eventTypeHoliday => 'Holiday';

  @override
  String get eventTypeExam => 'Exam';

  @override
  String get eventTypeMeeting => 'Meeting';

  @override
  String get eventTypeSport => 'Sport';

  @override
  String get eventTypeOther => 'Other';

  @override
  String get librarySearchHint => 'Search by book, author, or ISBN';

  @override
  String get libraryBorrowedSuccess => 'Book borrowed successfully';

  @override
  String get libraryReturnedSuccess => 'Book returned';

  @override
  String get libraryMyBooksTitle => 'My books';

  @override
  String get libraryCatalogTitle => 'Catalog';

  @override
  String get libraryNoLoansMessage => 'You have not borrowed any books yet.';

  @override
  String get libraryNoBooksMessage => 'No books matched your search.';

  @override
  String get libraryLoadingTitle => 'Loading library';

  @override
  String get libraryLoadingSubtitle => 'Fetching books and loan records';

  @override
  String get libraryLoadErrorTitle => 'Failed to load library';

  @override
  String get libraryBookFallback => 'Book';

  @override
  String get libraryBorrowedStatus => 'On hand';

  @override
  String get libraryReturnedStatus => 'Returned';

  @override
  String get libraryReturnAction => 'Return';

  @override
  String get libraryBorrowAction => 'Borrow';

  @override
  String get libraryUnavailableAction => 'Unavailable';

  @override
  String get assessmentRequiredFields => 'Select all required fields';

  @override
  String get assessmentCreatedSuccess => 'Assessment created successfully!';

  @override
  String get assessmentCreateTitle => 'New assessment';

  @override
  String get assessmentQuarterLabel => 'Quarter';

  @override
  String get assessmentGroupLabel => 'Group';

  @override
  String get assessmentSubjectLabel => 'Subject';

  @override
  String get assessmentTypeFieldLabel => 'Assessment type';

  @override
  String get assessmentOptionalTitleLabel => 'Title (optional)';

  @override
  String get assessmentOptionalTitleHint => 'For example: quarter 1 test';

  @override
  String get assessmentMaxScoreLabel => 'Maximum score';

  @override
  String get assessmentWeightLabel => 'Weight (%)';

  @override
  String get assessmentDateLabel => 'Held on';

  @override
  String get assessmentSelectDate => 'Select a date';

  @override
  String get assessmentResultsSaved => 'Results saved successfully';

  @override
  String get assessmentNoStudents => 'No students were found in this group.';

  @override
  String get assessmentScoreLabel => 'Score:';

  @override
  String get assessmentScoreHint => '0-100';

  @override
  String get assessmentCommentLabel => 'Comment:';

  @override
  String get assessmentCommentHintEmpty => 'Not provided';

  @override
  String get conferenceCreateTitle => 'Create meeting';

  @override
  String get conferenceSelectDateLabel => 'Select a date:';

  @override
  String get conferenceLocationLabel => 'Location / room:';

  @override
  String get conferenceLocationHint => 'For example: room 204 or Zoom';

  @override
  String get conferenceSlotsLabel => 'Time slots:';

  @override
  String get conferenceNoSlots => 'No slots have been added yet';

  @override
  String get conferenceCreateSuccess => 'Created successfully!';

  @override
  String get assessmentsListTitle => 'Assessments';

  @override
  String get addAssessmentTooltip => 'Add a new assessment';

  @override
  String get assessmentsListEmpty => 'No assessments have been added yet.';

  @override
  String get assessmentFallbackTitle => 'Assessment';

  @override
  String get assessmentUnknownGroup => 'Unknown group';

  @override
  String get profileEditTitle => 'Edit profile';

  @override
  String get profileUpdatedSuccess => 'Profile updated';

  @override
  String get dateInputHint => 'YYYY-MM-DD';

  @override
  String get alreadyUploadedLabel => 'Previously uploaded';

  @override
  String get selectAction => 'Select';

  @override
  String get documentNotSelected => 'No document selected';

  @override
  String get portfolioCreateTitle => 'Add scientific work';

  @override
  String get portfolioWorkFallbackTitle => 'Scientific work';

  @override
  String get portfolioWorkTitleLabel => 'Title';

  @override
  String get portfolioWorkTitleHint => 'Article or book title';

  @override
  String get portfolioPublishedPlaceLabel => 'Published at';

  @override
  String get portfolioPublishedPlaceHint => 'Journal or publisher';

  @override
  String get portfolioPublishedDateLabel => 'Published date';

  @override
  String get portfolioCoauthorSearchTitle => 'Search co-authors';

  @override
  String get portfolioCoauthorSearchHint =>
      'Search by passport series or number';

  @override
  String get addAction => 'Add';

  @override
  String get pdfOnlyFileLabel => 'File (PDF only)';

  @override
  String get uploadAction => 'Upload';

  @override
  String get portfolioTitleRequired => 'Enter a title';

  @override
  String get portfolioWorkAdded => 'Scientific work added';

  @override
  String get lessonSessionTitle => 'Lesson grades';

  @override
  String get addHomeworkTooltip => 'Add homework';

  @override
  String get lessonSessionLoadingTitle => 'Loading lesson session';

  @override
  String get lessonSessionLoadingSubtitle =>
      'Fetching grades and topic details';

  @override
  String get lessonSessionLoadErrorTitle => 'Failed to load the lesson session';

  @override
  String get lessonSessionSavedSuccess => 'Lesson saved successfully!';

  @override
  String get lessonSessionSaveErrorFallback => 'An error occurred while saving';

  @override
  String get lessonSessionTopicLabel => 'Topic';

  @override
  String get lessonSessionTopicHint => 'Enter today\'s lesson topic...';

  @override
  String get lessonSessionStudentsTitle => 'Student grades';

  @override
  String get presentStatusShort => 'Present';

  @override
  String get absentStatusShort => 'Absent';

  @override
  String get dashboardQuickActionsTitle => 'Quick actions';

  @override
  String get dashboardRecentAssessmentsTitle => 'Recent assessments';

  @override
  String get dashboardRecentAssessmentsEmptyTitle => 'No assessments found';

  @override
  String get dashboardRecentAssessmentsEmptyMessage =>
      'There are no recently graded exams yet.';

  @override
  String get dashboardLoadingTitle => 'Loading dashboard';

  @override
  String get dashboardLoadingSubtitle => 'Fetching the core statistics';

  @override
  String get dashboardLoadErrorTitle => 'Failed to load the dashboard';

  @override
  String get dashboardWeeklyInsightsTitle => 'Weekly insights';

  @override
  String get dashboardAttendanceChartTitle => 'Weekly attendance';

  @override
  String get dashboardPendingTasksTitle => 'Pending tasks';

  @override
  String get dashboardGroupsLabel => 'Groups';

  @override
  String get dashboardSubjectsLabel => 'Subjects';

  @override
  String get dashboardStudentsLabel => 'Students';

  @override
  String get dashboardAbsentLabel => 'Absent';

  @override
  String get dashboardAttendanceAction => 'Attendance';

  @override
  String get dashboardExcusesAction => 'Absence notes';

  @override
  String get dashboardConferencesAction => 'Meetings';

  @override
  String get dashboardHomeworkAction => 'Homework';

  @override
  String get dashboardAssessmentsAction => 'Exams';

  @override
  String get dashboardSubjectsAction => 'Subjects';

  @override
  String get dashboardLessonsLabel => 'Lessons';

  @override
  String get dashboardOpenSessionsLabel => 'Open sessions';

  @override
  String get dashboardClosedSessionsLabel => 'Closed';

  @override
  String get dashboardTodayDateUnavailable => 'Today\'s date is unavailable';

  @override
  String get dashboardYearFallbackBadge => 'Academic year';

  @override
  String get dashboardQuarterFallbackBadge => 'Quarter not set';

  @override
  String get gradesListTitle => 'Student grades';

  @override
  String get gradesQuarterTab => 'Quarterly';

  @override
  String get gradesYearTab => 'Yearly';

  @override
  String get gradesEmptyMessage => 'No grades found.';

  @override
  String get gradesLoadingTitle => 'Loading grades';

  @override
  String get gradesLoadingSubtitle => 'Preparing student results';

  @override
  String get gradesLoadErrorTitle => 'Failed to load grades';

  @override
  String get gradesSearchHint => 'Name, phone, email...';

  @override
  String get unknownStudentFallback => 'Unknown student';

  @override
  String get unknownGroupFallback => 'Unknown group';

  @override
  String get mealsReportTitle => 'Meal report';

  @override
  String get mealsNoGroupsMessage => 'No groups found.';

  @override
  String get mealsNameLabel => 'Meal name';

  @override
  String get mealsNameHint => 'For example: Macaroni with cheese';

  @override
  String get mealsRecipeLabel => 'Ingredients / recipe';

  @override
  String get mealsRecipeHint => 'Ingredients: flour, water, cheese...';

  @override
  String get mealsImagesLabel => 'Images (for proof)';

  @override
  String get mealsAddImageAction => 'Add image';

  @override
  String get mealsSystemImagesTitle => 'System images';

  @override
  String get mealsSaveAction => 'Save report';

  @override
  String get mealsGroupLabel => 'Group';

  @override
  String get mealsTimeLabel => 'Time';

  @override
  String get mealsLoadingTitle => 'Loading meal reports';

  @override
  String get mealsLoadingSubtitle => 'Fetching groups and today\'s data';

  @override
  String get mealsLoadErrorTitle => 'Failed to load the meal report';

  @override
  String get mealsNameRequired => 'Enter the meal name!';

  @override
  String get mealsSavedSuccess => 'Report saved!';

  @override
  String get langUz => 'Uzbek';

  @override
  String get langRu => 'Russian';

  @override
  String get langEn => 'English';

  @override
  String get paymentSuccessTitle => 'Payment Success';

  @override
  String get paymentSuccessMessage =>
      'Your payment has been successfully processed.';

  @override
  String get backToHome => 'Back to Home';

  @override
  String get classJournalTitle => 'Class Journal';

  @override
  String get classJournalSelectDate => 'Select date';

  @override
  String get classJournalEmpty => 'No journal data for this date';

  @override
  String get classJournalLoadFailed => 'Failed to load the journal';

  @override
  String classJournalStudentCount(int count) => '$count students';

  @override
  String get classStoryTitle => 'Class News';

  @override
  String get classStoryEmpty => 'No stories yet';

  @override
  String get classStoryLoadFailed => 'Failed to load stories';

  @override
  String get classStoryCommentHint => 'Write a comment...';

  @override
  String get classStoryDelete => 'Delete';

  @override
  String get classStoryCreateTitle => 'Create Story';

  @override
  String get classStoryPublish => 'Publish';

  @override
  String get classStoryTitleHint => 'Title (optional)';

  @override
  String get classStoryBodyHint => 'Story text...';

  @override
  String get classStoryPinLabel => 'Pin to top';

  @override
  String get classStoryCreateFailed => 'Failed to create story';

  @override
  String get quizTitle => 'Quizzes';
  @override
  String get quizEmpty => 'No quizzes yet';
  @override
  String get quizLoadFailed => 'Failed to load quizzes';
  @override
  String get quizAttempts => 'attempts';
  @override
  String get quizPoints => 'pts';
  @override
  String get quizCreateTitle => 'Create Quiz';
  @override
  String get quizSave => 'Save';
  @override
  String get quizTitleHint => 'Quiz title';
  @override
  String get quizDescHint => 'Description (optional)';
  @override
  String get quizTimeLimitHint => 'Time limit';
  @override
  String get quizQuestions => 'Questions';
  @override
  String get quizQuestionN => 'Question';
  @override
  String get quizQuestionHint => 'Enter question text';
  @override
  String get quizOptionHint => 'Option';
  @override
  String get quizAddQuestion => 'Add question';
  @override
  String get quizResultsTitle => 'Quiz Results';
  @override
  String get quizAvgScore => 'Avg. score';
  @override
  String get quizAvgPercent => 'Avg. %';
  @override
  String get quizStudentResults => 'Student Results';
  @override
  String get galleryTitle => 'Photo Gallery';
  @override
  String get galleryEmpty => 'No albums yet';
  @override
  String get galleryLoadFailed => 'Failed to load gallery';
  @override
  String get galleryPhotos => 'photos';
  @override
  String get galleryNoPhotos => 'No photos in this album';
  @override
  String get galleryCreateAlbum => 'Create Album';
  @override
  String get galleryAlbumTitleHint => 'Album title';
  @override
  String get galleryAlbumDescHint => 'Description (optional)';
  @override
  String get galleryCreate => 'Create';
  @override
  String get galleryCreateFailed => 'Failed to create album';
  @override
  String get galleryDeleteAlbum => 'Delete album';
  @override
  String get galleryDelete => 'Delete';
  @override
  String get galleryUploadFailed => 'Failed to upload photos';
  @override
  String get behaviorTitle => 'Behavior';
  @override
  String get behaviorLoadFailed => 'Failed to load data';
  @override
  String get behaviorEmpty => 'No records';
  @override
  String get behaviorAll => 'All';
  @override
  String get behaviorPositive => 'Positive';
  @override
  String get behaviorNegative => 'Negative';
  @override
  String get behaviorCreateTitle => 'New Record';
  @override
  String get behaviorSave => 'Save';
  @override
  String get behaviorType => 'Type';
  @override
  String get behaviorStudentId => 'Student ID';
  @override
  String get behaviorCategory => 'Category';
  @override
  String get behaviorDescription => 'Description';
  @override
  String get behaviorPoints => 'Points (0-100)';
  @override
  String get behaviorDate => 'Date';
  @override
  String get behaviorCreateFailed => 'Failed to create record';
}
