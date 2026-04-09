// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Uzbek (`uz`).
class AppLocalizationsUz extends AppLocalizations {
  AppLocalizationsUz([String locale = 'uz']) : super(locale);

  @override
  String get appName => 'Teacher Portal';

  @override
  String get changeLanguage => 'Tilni o\'zgartirish';

  @override
  String get changeTheme => 'Mavzuni o\'zgartirish';

  @override
  String get themeSystem => 'Tizim bo\'yicha';

  @override
  String get themeLight => 'Yorug\'';

  @override
  String get themeDark => 'Qorong\'u';

  @override
  String get notificationFallbackTitle => 'Yangi xabarnoma';

  @override
  String get close => 'Yopish';

  @override
  String get teacherPortal => 'Teacher Portal';

  @override
  String get teacherSubtitle =>
      'Sinf va darslaringizni boshqarish uchun tizimga kiring';

  @override
  String get usernameLabel => 'Login';

  @override
  String get usernameRequired => 'Login yoki telefon raqamni kiriting';

  @override
  String get usernameMinimum => 'Kamida 3 ta belgi kiriting';

  @override
  String get passwordLabel => 'Parol';

  @override
  String get passwordRequired => 'Parolni kiriting';

  @override
  String get passwordTooShort =>
      'Parol kamida 6 ta belgidan iborat bo\'lishi kerak';

  @override
  String get signIn => 'Kirish';

  @override
  String get home => 'Asosiy';

  @override
  String get lessons => 'Darslar';

  @override
  String get chat => 'Chat';

  @override
  String get profile => 'Profil';

  @override
  String get reviewHomeworkTitle => 'Vazifani tekshirish';

  @override
  String get assessmentResultsTitle => 'Imtihon natijalari';

  @override
  String get subjectLessonsTitle => 'Fan darslari';

  @override
  String get userFallbackName => 'Foydalanuvchi';

  @override
  String get noInternet => 'Internetga ulanish mavjud emas';

  @override
  String get errorGeneric =>
      'Kutilmagan xatolik yuz berdi. Iltimos, qaytadan urinib ko\'ring.';

  @override
  String get errorServer =>
      'Serverda xatolik yuz berdi. Iltimos, keyinroq qaytadan urinib ko\'ring.';

  @override
  String get errorAuth =>
      'Avtorizatsiyadan o\'tilmagan. Iltimos, hisobingizga kiring.';

  @override
  String get sessionExpired =>
      'Sessiya tugadi. Davom etish uchun qaytadan tizimga kiring.';

  @override
  String get requestTimeout =>
      'Server bilan aloqa vaqti tugadi. Qayta urinib ko\'ring.';

  @override
  String get requestCancelled => 'So\'rov bekor qilindi';

  @override
  String get badRequest => 'Noto\'g\'ri so\'rov';

  @override
  String get forbidden => 'Ruxsat berilmagan';

  @override
  String get notFound => 'Ma\'lumot topilmadi';

  @override
  String get failedFetchProfile => 'Foydalanuvchi profili yuklab bo\'lmadi.';

  @override
  String get failedLoadOptions => 'Kerakli variantlarni yuklab bo\'lmadi.';

  @override
  String get loadingTitle => 'Yuklanmoqda';

  @override
  String get errorTitle => 'Xatolik yuz berdi';

  @override
  String get retry => 'Qayta urinish';

  @override
  String get emptyTitle => 'Hozircha ma\'lumot yo\'q';

  @override
  String get todayLessonsTitle => 'Bugungi darslar';

  @override
  String get noLessonsTodayTitle => 'Bugungi darslar yo\'q';

  @override
  String get noLessonsTodayMessage =>
      'Bugun siz uchun rejalashtirilgan dars topilmadi.';

  @override
  String get lessonsLoadingTitle => 'Darslar yuklanmoqda';

  @override
  String get lessonsLoadingSubtitle => 'Bugungi jadval tayyorlanmoqda';

  @override
  String get lessonsLoadErrorTitle => 'Darslarni yuklab bo\'lmadi';

  @override
  String get startLessonButton => 'Darsni boshlash / kirish';

  @override
  String get attendanceCreateTitle => 'Davomat yo\'qlash';

  @override
  String get attendanceCreateSavePendingMessage =>
      'Davomat API saqlash integratsiyasi tayyorlanmoqda';

  @override
  String get attendanceOptionsLoadingTitle => 'Davomat variantlari yuklanmoqda';

  @override
  String get attendanceOptionsLoadingSubtitle =>
      'Statuslar va talabalar ro\'yxati tayyorlanmoqda';

  @override
  String get attendanceOptionsLoadErrorTitle =>
      'Davomat variantlarini yuklab bo\'lmadi';

  @override
  String get absenceReviewTitle => 'Sababnomalar';

  @override
  String get absenceReviewEmptyMessage => 'Arizalar topilmadi';

  @override
  String get approveAction => 'Tasdiqlash';

  @override
  String get rejectAction => 'Rad etish';

  @override
  String get absenceReviewLoadingTitle => 'Sababnomalar yuklanmoqda';

  @override
  String get absenceReviewLoadingSubtitle =>
      'Yangi davomat arizalari tekshirilmoqda';

  @override
  String get absenceReviewLoadErrorTitle => 'Sababnomalarni yuklab bo\'lmadi';

  @override
  String get absenceApprovedSuccess => 'Tasdiqlandi';

  @override
  String get absenceRejectedSuccess => 'Rad etildi';

  @override
  String get messagesTitle => 'Xabarlar';

  @override
  String get contactsEmptyTitle => 'Kontaktlar topilmadi';

  @override
  String get contactsEmptyMessage => 'Hozircha yozishmalar mavjud emas.';

  @override
  String get messagesLoadingTitle => 'Xabarlar yuklanmoqda';

  @override
  String get messagesLoadingSubtitle => 'Suhbatlar ro\'yxati tayyorlanmoqda';

  @override
  String get messagesLoadErrorTitle => 'Xabarlarni yuklab bo\'lmadi';

  @override
  String get sendMessagePlaceholder => 'Xabar yuborish';

  @override
  String get chatRoomEmptyMessage =>
      'Xabarlar yo\'q. Uning bilan birinchi bo\'lib muloqotni boshlang.';

  @override
  String get chatSendingAttachmentPlaceholder => 'Fayl yuborilmoqda...';

  @override
  String get profileSettingsTitle => 'Profil va Sozlamalar';

  @override
  String get scientificWorkDeleted => 'Ilmiy ish o\'chirildi';

  @override
  String get teacherFallbackName => 'O\'qituvchi';

  @override
  String get teacherEmailFallback => 'teacher@eschool.uz';

  @override
  String get infoSectionTitle => 'Ma\'lumotlar';

  @override
  String get universityLabel => 'Universitet';

  @override
  String get specializationLabel => 'Mutaxassislik';

  @override
  String get categoryLabel => 'Toifa';

  @override
  String get graduationDateLabel => 'Bitirgan sana';

  @override
  String get addressLabel => 'Manzil';

  @override
  String get genderLabel => 'Jins';

  @override
  String get achievementsLabel => 'Yutuqlar';

  @override
  String get documentsTitle => 'Hujjatlar';

  @override
  String get diplomaTitle => 'Diplom';

  @override
  String get passportCopyTitle => 'Passport nusxasi';

  @override
  String get uploadedStatus => 'Yuklangan';

  @override
  String get notUploadedStatus => 'Yuklanmagan';

  @override
  String get portfolioTitle => 'Ilmiy Ishlar (Portfolio)';

  @override
  String get portfolioEmptyTitle => 'Portfolio bo\'sh';

  @override
  String get portfolioEmptyMessage => 'Hozircha ilmiy ishlar qo\'shilmagan.';

  @override
  String get pdfUploadedLabel => 'PDF yuklangan';

  @override
  String get notificationsCenterTitle => 'Bildirishnomalar';

  @override
  String get notificationsCenterSubtitle => 'Teacher notification markazi';

  @override
  String get notificationsLoadingTitle => 'Bildirishnomalar yuklanmoqda';

  @override
  String get notificationsLoadingSubtitle => 'Yangi xabarlar tekshirilmoqda';

  @override
  String get notificationsLoadErrorTitle =>
      'Bildirishnomalarni yuklab bo\'lmadi';

  @override
  String get notificationsEmptyTitle => 'Bildirishnomalar yo\'q';

  @override
  String get notificationsEmptyMessage =>
      'Hozircha siz uchun yangi bildirishnoma yo\'q.';

  @override
  String get libraryMenuTitle => 'Kutubxona';

  @override
  String get libraryMenuSubtitle => 'Kitob olish va qaytarish';

  @override
  String get eventsMenuTitle => 'Tadbirlar';

  @override
  String get eventsMenuSubtitle => 'Maktab tadbirlari ro\'yxati';

  @override
  String get logoutTitle => 'Tizimdan chiqish';

  @override
  String get logoutConfirmMessage =>
      'Haqiqatan ham hisobingizdan chiqmoqchimisiz?';

  @override
  String get cancel => 'Bekor qilish';

  @override
  String get logoutAction => 'Chiqish';

  @override
  String get profileLoadingTitle => 'Profil yuklanmoqda';

  @override
  String get profileLoadingSubtitle =>
      'O\'qituvchi ma\'lumotlari tayyorlanmoqda';

  @override
  String get profileLoadErrorTitle => 'Profilni yuklab bo\'lmadi';

  @override
  String get timetableTitle => 'Dars jadvali';

  @override
  String get noLessonsOnSelectedDate => 'Ushbu sanada darslar yo\'q';

  @override
  String get unknownSubjectFallback => 'Fan noma\'lum';

  @override
  String get roomFallback => 'Xona -';

  @override
  String get subjectsTitle => 'Mening fanlarim';

  @override
  String get noAssignedSubjects => 'Sizga fanlar biriktirilmagan.';

  @override
  String get addTopicTooltip => 'Yangi mavzu qo\'shish';

  @override
  String get noTopicsYet => 'Mavzular hozircha yo\'q';

  @override
  String get noTopicsForGroup => 'Ushbu guruh uchun mavzular kiritilmagan.';

  @override
  String get filesTitle => 'Fayllar';

  @override
  String get fileOpenFailed => 'Kechirasiz, faylni ochib bo\'lmadi';

  @override
  String get newTopicTitle => 'Yangi mavzu';

  @override
  String get topicTitleLabel => 'Sarlavha';

  @override
  String get topicTitleHint => 'Mavzu nomi';

  @override
  String get topicDescriptionLabel => 'Qo\'shimcha ma\'lumotlar (ixtiyoriy)';

  @override
  String get topicDescriptionHint => 'Izoh...';

  @override
  String get attachedFilesTitle => 'Biriktirilgan fayllar';

  @override
  String get chooseFileAction => 'Fayl tanlash';

  @override
  String get noFilesSelected => 'Hozircha fayllar tanlanmagan.';

  @override
  String get addTopicAction => 'Mavzuni qo\'shish';

  @override
  String get topicTitleRequired => 'Mavzu sarlavhasini kiriting';

  @override
  String get topicFilesRequired =>
      'Kamida bitta PDF/DOC/Rasm fayl yuklash majburiy';

  @override
  String get topicSaved => 'Mavzu saqlandi';

  @override
  String get paymentsTitle => 'To\'lovlar (o\'quvchilar)';

  @override
  String get allGroups => 'Barcha guruhlar';

  @override
  String get searchStudentHint => 'O\'quvchini qidirish...';

  @override
  String get noStudentsFound => 'O\'quvchilar topilmadi.';

  @override
  String get paidStatus => 'To\'lagan';

  @override
  String get debtorStatus => 'Qarzdor';

  @override
  String get studentPaymentsTitle => 'O\'quvchi to\'lovlari';

  @override
  String get newPaymentTitle => 'Yangi to\'lov';

  @override
  String get paymentTypeLabel => 'To\'lov turi';

  @override
  String get monthlyPaymentType => 'Oylik to\'lov';

  @override
  String get yearlyPaymentType => 'Yillik to\'lov';

  @override
  String get yearLabel => 'Yil';

  @override
  String get monthLabel => 'Oy';

  @override
  String get paymentMethodLabel => 'To\'lov usuli';

  @override
  String get paymentMethodCash => 'Naqd pul';

  @override
  String get paymentMethodCard => 'Plastik karta';

  @override
  String get paymentMethodTransfer => 'Karta orqali o\'tkazma (P2P)';

  @override
  String get paymentMethodTerminal => 'Terminal';

  @override
  String get amountLabel => 'Summa';

  @override
  String get amountCurrencyLabel => 'Summa (so\'m)';

  @override
  String get noteOptional => 'Izoh (ixtiyoriy)';

  @override
  String get confirmAction => 'Tasdiqlash';

  @override
  String get paymentAmountRequired => 'To\'lov summasini kiriting';

  @override
  String get paymentAccepted => 'To\'lov qabul qilindi!';

  @override
  String get paymentHistoryTitle => 'To\'lovlar tarixi';

  @override
  String get noPaymentsForStudent => 'Ushbu o\'quvchida to\'lovlar yo\'q.';

  @override
  String get monthlyFeeLabel => 'Oylik to\'lov';

  @override
  String get discountLabel => 'Chegirma';

  @override
  String get currencySymbol => 'So\'m';

  @override
  String get saveAction => 'Saqlash';

  @override
  String get editAction => 'Tahrirlash';

  @override
  String get homeworkListTitle => 'Uyga vazifalar';

  @override
  String get noAssignedHomeworks => 'Hali vazifalar biriktirilmagan.';

  @override
  String get homeworkGroupFallback => 'Guruh';

  @override
  String get homeworkDescriptionFallback => 'Tavsif yo\'q';

  @override
  String get homeworkCreateTitle => 'Yangi vazifa';

  @override
  String get homeworkTitleLabel => 'Sarlavha';

  @override
  String get homeworkTitleHint => 'Masalan: 5-mashq';

  @override
  String get homeworkDescriptionTitle => 'Tavsif';

  @override
  String get homeworkDescriptionHint => 'Vazifa haqida batafsil...';

  @override
  String get homeworkDueDateTitle => 'Topshirish muddati (ixtiyoriy)';

  @override
  String get homeworkSelectDueDate => 'Muddatni tanlang';

  @override
  String get homeworkTitleRequired => 'Sarlavhani kiriting';

  @override
  String get homeworkCreatedSuccess => 'Vazifa yaratildi!';

  @override
  String get homeworkCheckDialogTitle => 'Baho qo\'yish';

  @override
  String get homeworkCommentHint => 'Izoh (ixtiyoriy)';

  @override
  String get homeworkNoSubmissions => 'Hozircha vazifalar topshirilmagan.';

  @override
  String get homeworkGradedStatus => 'Baholangan';

  @override
  String get homeworkSubmittedStatus => 'Javob berilgan';

  @override
  String get homeworkViewFileAction => 'Faylni ko\'rish';

  @override
  String get gradeAction => 'Baho qo\'yish';

  @override
  String get eventsEmptyTitle => 'Faol tadbirlar yo\'q';

  @override
  String get eventsEmptyMessage =>
      'Hozircha faol tadbirlar ro\'yxatga olinmagan.';

  @override
  String get eventsLoadingTitle => 'Tadbirlar yuklanmoqda';

  @override
  String get eventsLoadingSubtitle => 'Maktab kalendari yangilanmoqda';

  @override
  String get eventsLoadErrorTitle => 'Tadbirlarni yuklab bo\'lmadi';

  @override
  String get eventFallbackTitle => 'Tadbir';

  @override
  String get eventDateUnavailable => 'Sana ko\'rsatilmagan';

  @override
  String get eventTypeHoliday => 'Bayram';

  @override
  String get eventTypeExam => 'Imtihon';

  @override
  String get eventTypeMeeting => 'Uchrashuv';

  @override
  String get eventTypeSport => 'Sport';

  @override
  String get eventTypeOther => 'Boshqa';

  @override
  String get librarySearchHint => 'Kitob, muallif yoki ISBN bo‘yicha qidiring';

  @override
  String get libraryBorrowedSuccess => 'Kitob muvaffaqiyatli olindi';

  @override
  String get libraryReturnedSuccess => 'Kitob qaytarildi';

  @override
  String get libraryMyBooksTitle => 'Mening kitoblarim';

  @override
  String get libraryCatalogTitle => 'Katalog';

  @override
  String get libraryNoLoansMessage => 'Siz hali kutubxonadan kitob olmagansiz.';

  @override
  String get libraryNoBooksMessage => 'So‘rovingiz bo‘yicha kitob topilmadi.';

  @override
  String get libraryLoadingTitle => 'Kutubxona yuklanmoqda';

  @override
  String get libraryLoadingSubtitle => 'Kitoblar va qarz yozuvlari olinmoqda';

  @override
  String get libraryLoadErrorTitle => 'Kutubxonani yuklab bo\'lmadi';

  @override
  String get libraryBookFallback => 'Kitob';

  @override
  String get libraryBorrowedStatus => 'Qo‘lingizda';

  @override
  String get libraryReturnedStatus => 'Qaytarilgan';

  @override
  String get libraryReturnAction => 'Qaytarish';

  @override
  String get libraryBorrowAction => 'Olish';

  @override
  String get libraryUnavailableAction => 'Mavjud emas';

  @override
  String get assessmentRequiredFields => 'Barcha majburiy maydonlarni tanlang';

  @override
  String get assessmentCreatedSuccess => 'Imtihon muvaffaqiyatli yaratildi!';

  @override
  String get assessmentCreateTitle => 'Yangi imtihon';

  @override
  String get assessmentQuarterLabel => 'Chorak';

  @override
  String get assessmentGroupLabel => 'Guruh';

  @override
  String get assessmentSubjectLabel => 'Fan';

  @override
  String get assessmentTypeFieldLabel => 'Imtihon turi';

  @override
  String get assessmentOptionalTitleLabel => 'Sarlavha (ixtiyoriy)';

  @override
  String get assessmentOptionalTitleHint => 'Masalan: 1-chorak nazorat ishi';

  @override
  String get assessmentMaxScoreLabel => 'Maksimal ball';

  @override
  String get assessmentWeightLabel => 'Vazni (%)';

  @override
  String get assessmentDateLabel => 'O\'tkazilish sanasi';

  @override
  String get assessmentSelectDate => 'Sana tanlang';

  @override
  String get assessmentResultsSaved => 'Natijalar muvaffaqiyatli saqlandi';

  @override
  String get assessmentNoStudents => 'Ushbu guruhda o\'quvchilar topilmadi.';

  @override
  String get assessmentScoreLabel => 'Ball:';

  @override
  String get assessmentScoreHint => '0-100';

  @override
  String get assessmentCommentLabel => 'Izoh:';

  @override
  String get assessmentCommentHintEmpty => 'Kiritilmadi';

  @override
  String get conferenceCreateTitle => 'Majlis yaratish';

  @override
  String get conferenceSelectDateLabel => 'Sanani tanlang:';

  @override
  String get conferenceLocationLabel => 'Manzil / Xona:';

  @override
  String get conferenceLocationHint => 'Masalan: 204-xona yoki Zoom';

  @override
  String get conferenceSlotsLabel => 'Vaqt oraliqlari (slotlar):';

  @override
  String get conferenceNoSlots => 'Hali slotlar qo\'shilmadi';

  @override
  String get conferenceCreateSuccess => 'Muvaffaqiyatli yaratildi!';

  @override
  String get assessmentsListTitle => 'Imtihon va baholashlar';

  @override
  String get addAssessmentTooltip => 'Yangi imtihon qo\'shish';

  @override
  String get assessmentsListEmpty => 'Hali imtihonlar qo\'shilmagan.';

  @override
  String get assessmentFallbackTitle => 'Imtihon';

  @override
  String get assessmentUnknownGroup => 'Noma\'lum guruh';

  @override
  String get profileEditTitle => 'Profilni tahrirlash';

  @override
  String get profileUpdatedSuccess => 'Profil yangilandi';

  @override
  String get dateInputHint => 'YYYY-MM-DD';

  @override
  String get alreadyUploadedLabel => 'Avval yuklangan';

  @override
  String get selectAction => 'Tanlash';

  @override
  String get documentNotSelected => 'Hujjat tanlanmagan';

  @override
  String get portfolioCreateTitle => 'Ilmiy ish qo\'shish';

  @override
  String get portfolioWorkFallbackTitle => 'Ilmiy ish';

  @override
  String get portfolioWorkTitleLabel => 'Sarlavha';

  @override
  String get portfolioWorkTitleHint => 'Maqola yoki kitob nomi';

  @override
  String get portfolioPublishedPlaceLabel => 'Nashr qilingan joy';

  @override
  String get portfolioPublishedPlaceHint => 'Jurnal yoki nashriyot';

  @override
  String get portfolioPublishedDateLabel => 'Nashr sanasi';

  @override
  String get portfolioCoauthorSearchTitle => 'Hammuallif qidirish';

  @override
  String get portfolioCoauthorSearchHint =>
      'Passport seriyasi yoki raqami bo‘yicha qidiring';

  @override
  String get addAction => 'Qo‘shish';

  @override
  String get pdfOnlyFileLabel => 'Fayl (faqat PDF)';

  @override
  String get uploadAction => 'Yuklash';

  @override
  String get portfolioTitleRequired => 'Sarlavhani kiriting';

  @override
  String get portfolioWorkAdded => 'Ilmiy ish qo\'shildi';

  @override
  String get lessonSessionTitle => 'Dars baholari';

  @override
  String get addHomeworkTooltip => 'Uyga vazifa qo\'shish';

  @override
  String get lessonSessionLoadingTitle => 'Dars sessiyasi yuklanmoqda';

  @override
  String get lessonSessionLoadingSubtitle =>
      'Baholar va mavzu ma\'lumotlari olinmoqda';

  @override
  String get lessonSessionLoadErrorTitle => 'Dars sessiyasini yuklab bo\'lmadi';

  @override
  String get lessonSessionSavedSuccess => 'Dars muvaffaqiyatli saqlandi!';

  @override
  String get lessonSessionSaveErrorFallback => 'Saqlashda xatolik yuz berdi';

  @override
  String get lessonSessionTopicLabel => 'Mavzu';

  @override
  String get lessonSessionTopicHint => 'Bugungi dars mavzusini kiriting...';

  @override
  String get lessonSessionStudentsTitle => 'O\'quvchilar bahosi';

  @override
  String get presentStatusShort => 'Keldi';

  @override
  String get absentStatusShort => 'Kelmadi';

  @override
  String get dashboardQuickActionsTitle => 'Tezkor harakatlar';

  @override
  String get dashboardRecentAssessmentsTitle => 'So\'nggi baholashlar';

  @override
  String get dashboardRecentAssessmentsEmptyTitle => 'Baholashlar topilmadi';

  @override
  String get dashboardRecentAssessmentsEmptyMessage =>
      'Hozircha yaqinda baholangan imtihonlar yo\'q.';

  @override
  String get dashboardLoadingTitle => 'Dashboard yuklanmoqda';

  @override
  String get dashboardLoadingSubtitle => 'Asosiy statistikalar olinmoqda';

  @override
  String get dashboardLoadErrorTitle => 'Dashboardni yuklab bo\'lmadi';

  @override
  String get dashboardWeeklyInsightsTitle => 'Haftalik tahlillar';

  @override
  String get dashboardAttendanceChartTitle => 'Haftalik davomat';

  @override
  String get dashboardPendingTasksTitle => 'Kutilayotgan vazifalar';

  @override
  String get dashboardGroupsLabel => 'Guruhlar';

  @override
  String get dashboardSubjectsLabel => 'Fanlar';

  @override
  String get dashboardStudentsLabel => 'O\'quvchilar';

  @override
  String get dashboardAbsentLabel => 'Yo\'qlar';

  @override
  String get dashboardAttendanceAction => 'Davomat';

  @override
  String get dashboardExcusesAction => 'Sababnomalar';

  @override
  String get dashboardConferencesAction => 'Majlislar';

  @override
  String get dashboardHomeworkAction => 'Uyga vazifa';

  @override
  String get dashboardAssessmentsAction => 'Imtihonlar';

  @override
  String get dashboardSubjectsAction => 'Fanlar';

  @override
  String get dashboardLessonsLabel => 'Darslar';

  @override
  String get dashboardOpenSessionsLabel => 'Ochiq session';

  @override
  String get dashboardClosedSessionsLabel => 'Yopilgan';

  @override
  String get dashboardTodayDateUnavailable => 'Bugungi sana mavjud emas';

  @override
  String get dashboardYearFallbackBadge => 'O\'quv yili';

  @override
  String get dashboardQuarterFallbackBadge => 'Chorak belgilanmagan';

  @override
  String get gradesListTitle => 'O\'quvchilar baholari';

  @override
  String get gradesQuarterTab => 'Choraklik';

  @override
  String get gradesYearTab => 'Yillik';

  @override
  String get gradesEmptyMessage => 'Baholar topilmadi.';

  @override
  String get gradesLoadingTitle => 'Baholar yuklanmoqda';

  @override
  String get gradesLoadingSubtitle => 'O\'quvchilar natijalari tayyorlanmoqda';

  @override
  String get gradesLoadErrorTitle => 'Baholarni yuklab bo\'lmadi';

  @override
  String get gradesSearchHint => 'Ism, tel, email...';

  @override
  String get unknownStudentFallback => 'Noma\'lum o\'quvchi';

  @override
  String get unknownGroupFallback => 'Guruh noma\'lum';

  @override
  String get mealsReportTitle => 'Ovqatlanish hisoboti';

  @override
  String get mealsNoGroupsMessage => 'Guruhlar topilmadi.';

  @override
  String get mealsNameLabel => 'Ovqat nomi';

  @override
  String get mealsNameHint => 'Masalan: Macaroni with cheese';

  @override
  String get mealsRecipeLabel => 'Tarkibi / retsept';

  @override
  String get mealsRecipeHint => 'Tarkibi: un, suv, pishloq...';

  @override
  String get mealsImagesLabel => 'Rasmlar (dalil uchun)';

  @override
  String get mealsAddImageAction => 'Rasm qo\'shish';

  @override
  String get mealsSystemImagesTitle => 'Tizimdagi rasmlar';

  @override
  String get mealsSaveAction => 'Hisobotni saqlash';

  @override
  String get mealsGroupLabel => 'Guruh';

  @override
  String get mealsTimeLabel => 'Vaqt';

  @override
  String get mealsLoadingTitle => 'Ovqatlanish hisobotlari yuklanmoqda';

  @override
  String get mealsLoadingSubtitle =>
      'Guruhlar va bugungi ma\'lumotlar olinmoqda';

  @override
  String get mealsLoadErrorTitle => 'Ovqatlanish hisobotini yuklab bo\'lmadi';

  @override
  String get mealsNameRequired => 'Ovqat nomini kiriting!';

  @override
  String get mealsSavedSuccess => 'Hisobot saqlandi!';

  @override
  String get langUz => 'O\'zbekcha';

  @override
  String get langRu => 'Ruscha';

  @override
  String get langEn => 'Inglizcha';
}
