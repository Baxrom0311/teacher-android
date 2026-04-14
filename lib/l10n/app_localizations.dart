import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_uz.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
    Locale('uz'),
  ];

  /// No description provided for @appName.
  ///
  /// In uz, this message translates to:
  /// **'Teacher Portal'**
  String get appName;

  /// No description provided for @changeLanguage.
  ///
  /// In uz, this message translates to:
  /// **'Tilni o\'zgartirish'**
  String get changeLanguage;

  /// No description provided for @changeTheme.
  ///
  /// In uz, this message translates to:
  /// **'Mavzuni o\'zgartirish'**
  String get changeTheme;

  /// No description provided for @themeSystem.
  ///
  /// In uz, this message translates to:
  /// **'Tizim bo\'yicha'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In uz, this message translates to:
  /// **'Yorug\''**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In uz, this message translates to:
  /// **'Qorong\'u'**
  String get themeDark;

  /// No description provided for @notificationFallbackTitle.
  ///
  /// In uz, this message translates to:
  /// **'Yangi xabarnoma'**
  String get notificationFallbackTitle;

  /// No description provided for @close.
  ///
  /// In uz, this message translates to:
  /// **'Yopish'**
  String get close;

  /// No description provided for @teacherPortal.
  ///
  /// In uz, this message translates to:
  /// **'Teacher Portal'**
  String get teacherPortal;

  /// No description provided for @teacherSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Darslar va mashg\'ulotlarni boshqarish uchun tizimga kiring'**
  String get teacherSubtitle;

  /// No description provided for @selectSchool.
  ///
  /// In uz, this message translates to:
  /// **'Maktabni tanlang'**
  String get selectSchool;

  /// No description provided for @selectSchoolSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Kirmoqchi bo\'lgan maktabingizni tanlang'**
  String get selectSchoolSubtitle;

  /// No description provided for @noSchoolsFound.
  ///
  /// In uz, this message translates to:
  /// **'Maktablar topilmadi'**
  String get noSchoolsFound;

  /// No description provided for @changeSchool.
  ///
  /// In uz, this message translates to:
  /// **'Maktabni o\'zgartirish'**
  String get changeSchool;

  /// No description provided for @usernameLabel.
  ///
  /// In uz, this message translates to:
  /// **'Telefon raqami'**
  String get usernameLabel;

  /// No description provided for @phoneNumberLabel.
  ///
  /// In uz, this message translates to:
  /// **'Telefon raqami'**
  String get phoneNumberLabel;

  /// No description provided for @phoneNumberRequired.
  ///
  /// In uz, this message translates to:
  /// **'Telefon raqamini kiriting'**
  String get phoneNumberRequired;

  /// No description provided for @usernameRequired.
  ///
  /// In uz, this message translates to:
  /// **'Telefon raqamini kiriting'**
  String get usernameRequired;

  /// No description provided for @usernameMinimum.
  ///
  /// In uz, this message translates to:
  /// **'Kamida 3 ta belgi kiriting'**
  String get usernameMinimum;

  /// No description provided for @passwordLabel.
  ///
  /// In uz, this message translates to:
  /// **'Parol'**
  String get passwordLabel;

  /// No description provided for @passwordRequired.
  ///
  /// In uz, this message translates to:
  /// **'Parolni kiriting'**
  String get passwordRequired;

  /// No description provided for @passwordTooShort.
  ///
  /// In uz, this message translates to:
  /// **'Parol kamida 6 ta belgidan iborat bo\'lishi kerak'**
  String get passwordTooShort;

  /// No description provided for @signIn.
  ///
  /// In uz, this message translates to:
  /// **'Kirish'**
  String get signIn;

  /// No description provided for @home.
  ///
  /// In uz, this message translates to:
  /// **'Asosiy'**
  String get home;

  /// No description provided for @lessons.
  ///
  /// In uz, this message translates to:
  /// **'Darslar'**
  String get lessons;

  /// No description provided for @chat.
  ///
  /// In uz, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @profile.
  ///
  /// In uz, this message translates to:
  /// **'Profil'**
  String get profile;

  /// No description provided for @reviewHomeworkTitle.
  ///
  /// In uz, this message translates to:
  /// **'Vazifani tekshirish'**
  String get reviewHomeworkTitle;

  /// No description provided for @assessmentResultsTitle.
  ///
  /// In uz, this message translates to:
  /// **'Imtihon natijalari'**
  String get assessmentResultsTitle;

  /// No description provided for @subjectLessonsTitle.
  ///
  /// In uz, this message translates to:
  /// **'Fan darslari'**
  String get subjectLessonsTitle;

  /// No description provided for @userFallbackName.
  ///
  /// In uz, this message translates to:
  /// **'Foydalanuvchi'**
  String get userFallbackName;

  /// No description provided for @noInternet.
  ///
  /// In uz, this message translates to:
  /// **'Internetga ulanish mavjud emas'**
  String get noInternet;

  /// No description provided for @errorGeneric.
  ///
  /// In uz, this message translates to:
  /// **'Kutilmagan xatolik yuz berdi. Iltimos, qaytadan urinib ko\'ring.'**
  String get errorGeneric;

  /// No description provided for @errorServer.
  ///
  /// In uz, this message translates to:
  /// **'Serverda xatolik yuz berdi. Iltimos, keyinroq qaytadan urinib ko\'ring.'**
  String get errorServer;

  /// No description provided for @errorAuth.
  ///
  /// In uz, this message translates to:
  /// **'Avtorizatsiyadan o\'tilmagan. Iltimos, hisobingizga kiring.'**
  String get errorAuth;

  /// No description provided for @sessionExpired.
  ///
  /// In uz, this message translates to:
  /// **'Sessiya tugadi. Davom etish uchun qaytadan tizimga kiring.'**
  String get sessionExpired;

  /// No description provided for @requestTimeout.
  ///
  /// In uz, this message translates to:
  /// **'Server bilan aloqa vaqti tugadi. Qayta urinib ko\'ring.'**
  String get requestTimeout;

  /// No description provided for @requestCancelled.
  ///
  /// In uz, this message translates to:
  /// **'So\'rov bekor qilindi'**
  String get requestCancelled;

  /// No description provided for @badRequest.
  ///
  /// In uz, this message translates to:
  /// **'Noto\'g\'ri so\'rov'**
  String get badRequest;

  /// No description provided for @forbidden.
  ///
  /// In uz, this message translates to:
  /// **'Ruxsat berilmagan'**
  String get forbidden;

  /// No description provided for @notFound.
  ///
  /// In uz, this message translates to:
  /// **'Ma\'lumot topilmadi'**
  String get notFound;

  /// No description provided for @failedFetchProfile.
  ///
  /// In uz, this message translates to:
  /// **'Foydalanuvchi profili yuklab bo\'lmadi.'**
  String get failedFetchProfile;

  /// No description provided for @failedLoadOptions.
  ///
  /// In uz, this message translates to:
  /// **'Kerakli variantlarni yuklab bo\'lmadi.'**
  String get failedLoadOptions;

  /// No description provided for @loadingTitle.
  ///
  /// In uz, this message translates to:
  /// **'Yuklanmoqda'**
  String get loadingTitle;

  /// No description provided for @errorTitle.
  ///
  /// In uz, this message translates to:
  /// **'Xatolik yuz berdi'**
  String get errorTitle;

  /// No description provided for @retry.
  ///
  /// In uz, this message translates to:
  /// **'Qayta urinish'**
  String get retry;

  /// No description provided for @emptyTitle.
  ///
  /// In uz, this message translates to:
  /// **'Hozircha ma\'lumot yo\'q'**
  String get emptyTitle;

  /// No description provided for @todayLessonsTitle.
  ///
  /// In uz, this message translates to:
  /// **'Bugungi darslar'**
  String get todayLessonsTitle;

  /// No description provided for @noLessonsTodayTitle.
  ///
  /// In uz, this message translates to:
  /// **'Bugungi darslar yo\'q'**
  String get noLessonsTodayTitle;

  /// No description provided for @noLessonsTodayMessage.
  ///
  /// In uz, this message translates to:
  /// **'Bugun siz uchun rejalashtirilgan dars topilmadi.'**
  String get noLessonsTodayMessage;

  /// No description provided for @lessonsLoadingTitle.
  ///
  /// In uz, this message translates to:
  /// **'Darslar yuklanmoqda'**
  String get lessonsLoadingTitle;

  /// No description provided for @lessonsLoadingSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Bugungi jadval tayyorlanmoqda'**
  String get lessonsLoadingSubtitle;

  /// No description provided for @lessonsLoadErrorTitle.
  ///
  /// In uz, this message translates to:
  /// **'Darslarni yuklab bo\'lmadi'**
  String get lessonsLoadErrorTitle;

  /// No description provided for @startLessonButton.
  ///
  /// In uz, this message translates to:
  /// **'Darsni boshlash / kirish'**
  String get startLessonButton;

  /// No description provided for @attendanceCreateTitle.
  ///
  /// In uz, this message translates to:
  /// **'Davomat yo\'qlash'**
  String get attendanceCreateTitle;

  /// No description provided for @attendanceCreateSavePendingMessage.
  ///
  /// In uz, this message translates to:
  /// **'Davomat API saqlash integratsiyasi tayyorlanmoqda'**
  String get attendanceCreateSavePendingMessage;

  /// No description provided for @attendanceOptionsLoadingTitle.
  ///
  /// In uz, this message translates to:
  /// **'Davomat variantlari yuklanmoqda'**
  String get attendanceOptionsLoadingTitle;

  /// No description provided for @attendanceOptionsLoadingSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Statuslar va talabalar ro\'yxati tayyorlanmoqda'**
  String get attendanceOptionsLoadingSubtitle;

  /// No description provided for @attendanceOptionsLoadErrorTitle.
  ///
  /// In uz, this message translates to:
  /// **'Davomat variantlarini yuklab bo\'lmadi'**
  String get attendanceOptionsLoadErrorTitle;

  /// No description provided for @absenceReviewTitle.
  ///
  /// In uz, this message translates to:
  /// **'Sababnomalar'**
  String get absenceReviewTitle;

  /// No description provided for @absenceReviewEmptyMessage.
  ///
  /// In uz, this message translates to:
  /// **'Arizalar topilmadi'**
  String get absenceReviewEmptyMessage;

  /// No description provided for @approveAction.
  ///
  /// In uz, this message translates to:
  /// **'Tasdiqlash'**
  String get approveAction;

  /// No description provided for @rejectAction.
  ///
  /// In uz, this message translates to:
  /// **'Rad etish'**
  String get rejectAction;

  /// No description provided for @absenceReviewLoadingTitle.
  ///
  /// In uz, this message translates to:
  /// **'Sababnomalar yuklanmoqda'**
  String get absenceReviewLoadingTitle;

  /// No description provided for @absenceReviewLoadingSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Yangi davomat arizalari tekshirilmoqda'**
  String get absenceReviewLoadingSubtitle;

  /// No description provided for @absenceReviewLoadErrorTitle.
  ///
  /// In uz, this message translates to:
  /// **'Sababnomalarni yuklab bo\'lmadi'**
  String get absenceReviewLoadErrorTitle;

  /// No description provided for @absenceApprovedSuccess.
  ///
  /// In uz, this message translates to:
  /// **'Tasdiqlandi'**
  String get absenceApprovedSuccess;

  /// No description provided for @absenceRejectedSuccess.
  ///
  /// In uz, this message translates to:
  /// **'Rad etildi'**
  String get absenceRejectedSuccess;

  /// No description provided for @messagesTitle.
  ///
  /// In uz, this message translates to:
  /// **'Xabarlar'**
  String get messagesTitle;

  /// No description provided for @contactsEmptyTitle.
  ///
  /// In uz, this message translates to:
  /// **'Kontaktlar topilmadi'**
  String get contactsEmptyTitle;

  /// No description provided for @contactsEmptyMessage.
  ///
  /// In uz, this message translates to:
  /// **'Hozircha yozishmalar mavjud emas.'**
  String get contactsEmptyMessage;

  /// No description provided for @messagesLoadingTitle.
  ///
  /// In uz, this message translates to:
  /// **'Xabarlar yuklanmoqda'**
  String get messagesLoadingTitle;

  /// No description provided for @messagesLoadingSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Suhbatlar ro\'yxati tayyorlanmoqda'**
  String get messagesLoadingSubtitle;

  /// No description provided for @messagesLoadErrorTitle.
  ///
  /// In uz, this message translates to:
  /// **'Xabarlarni yuklab bo\'lmadi'**
  String get messagesLoadErrorTitle;

  /// No description provided for @sendMessagePlaceholder.
  ///
  /// In uz, this message translates to:
  /// **'Xabar yuborish'**
  String get sendMessagePlaceholder;

  /// No description provided for @chatRoomEmptyMessage.
  ///
  /// In uz, this message translates to:
  /// **'Xabarlar yo\'q. Uning bilan birinchi bo\'lib muloqotni boshlang.'**
  String get chatRoomEmptyMessage;

  /// No description provided for @chatSendingAttachmentPlaceholder.
  ///
  /// In uz, this message translates to:
  /// **'Fayl yuborilmoqda...'**
  String get chatSendingAttachmentPlaceholder;

  /// No description provided for @profileSettingsTitle.
  ///
  /// In uz, this message translates to:
  /// **'Profil va Sozlamalar'**
  String get profileSettingsTitle;

  /// No description provided for @scientificWorkDeleted.
  ///
  /// In uz, this message translates to:
  /// **'Ilmiy ish o\'chirildi'**
  String get scientificWorkDeleted;

  /// No description provided for @teacherFallbackName.
  ///
  /// In uz, this message translates to:
  /// **'O\'qituvchi'**
  String get teacherFallbackName;

  /// No description provided for @teacherEmailFallback.
  ///
  /// In uz, this message translates to:
  /// **'teacher@eschool.uz'**
  String get teacherEmailFallback;

  /// No description provided for @infoSectionTitle.
  ///
  /// In uz, this message translates to:
  /// **'Ma\'lumotlar'**
  String get infoSectionTitle;

  /// No description provided for @universityLabel.
  ///
  /// In uz, this message translates to:
  /// **'Universitet'**
  String get universityLabel;

  /// No description provided for @specializationLabel.
  ///
  /// In uz, this message translates to:
  /// **'Mutaxassislik'**
  String get specializationLabel;

  /// No description provided for @categoryLabel.
  ///
  /// In uz, this message translates to:
  /// **'Toifa'**
  String get categoryLabel;

  /// No description provided for @graduationDateLabel.
  ///
  /// In uz, this message translates to:
  /// **'Bitirgan sana'**
  String get graduationDateLabel;

  /// No description provided for @addressLabel.
  ///
  /// In uz, this message translates to:
  /// **'Manzil'**
  String get addressLabel;

  /// No description provided for @genderLabel.
  ///
  /// In uz, this message translates to:
  /// **'Jins'**
  String get genderLabel;

  /// No description provided for @achievementsLabel.
  ///
  /// In uz, this message translates to:
  /// **'Yutuqlar'**
  String get achievementsLabel;

  /// No description provided for @documentsTitle.
  ///
  /// In uz, this message translates to:
  /// **'Hujjatlar'**
  String get documentsTitle;

  /// No description provided for @diplomaTitle.
  ///
  /// In uz, this message translates to:
  /// **'Diplom'**
  String get diplomaTitle;

  /// No description provided for @passportCopyTitle.
  ///
  /// In uz, this message translates to:
  /// **'Passport nusxasi'**
  String get passportCopyTitle;

  /// No description provided for @uploadedStatus.
  ///
  /// In uz, this message translates to:
  /// **'Yuklangan'**
  String get uploadedStatus;

  /// No description provided for @notUploadedStatus.
  ///
  /// In uz, this message translates to:
  /// **'Yuklanmagan'**
  String get notUploadedStatus;

  /// No description provided for @portfolioTitle.
  ///
  /// In uz, this message translates to:
  /// **'Ilmiy Ishlar (Portfolio)'**
  String get portfolioTitle;

  /// No description provided for @portfolioEmptyTitle.
  ///
  /// In uz, this message translates to:
  /// **'Portfolio bo\'sh'**
  String get portfolioEmptyTitle;

  /// No description provided for @portfolioEmptyMessage.
  ///
  /// In uz, this message translates to:
  /// **'Hozircha ilmiy ishlar qo\'shilmagan.'**
  String get portfolioEmptyMessage;

  /// No description provided for @pdfUploadedLabel.
  ///
  /// In uz, this message translates to:
  /// **'PDF yuklangan'**
  String get pdfUploadedLabel;

  /// No description provided for @notificationsCenterTitle.
  ///
  /// In uz, this message translates to:
  /// **'Bildirishnomalar'**
  String get notificationsCenterTitle;

  /// No description provided for @notificationsCenterSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Teacher notification markazi'**
  String get notificationsCenterSubtitle;

  /// No description provided for @notificationsLoadingTitle.
  ///
  /// In uz, this message translates to:
  /// **'Bildirishnomalar yuklanmoqda'**
  String get notificationsLoadingTitle;

  /// No description provided for @notificationsLoadingSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Yangi xabarlar tekshirilmoqda'**
  String get notificationsLoadingSubtitle;

  /// No description provided for @notificationsLoadErrorTitle.
  ///
  /// In uz, this message translates to:
  /// **'Bildirishnomalarni yuklab bo\'lmadi'**
  String get notificationsLoadErrorTitle;

  /// No description provided for @notificationsEmptyTitle.
  ///
  /// In uz, this message translates to:
  /// **'Bildirishnomalar yo\'q'**
  String get notificationsEmptyTitle;

  /// No description provided for @notificationsEmptyMessage.
  ///
  /// In uz, this message translates to:
  /// **'Hozircha siz uchun yangi bildirishnoma yo\'q.'**
  String get notificationsEmptyMessage;

  /// No description provided for @libraryMenuTitle.
  ///
  /// In uz, this message translates to:
  /// **'Kutubxona'**
  String get libraryMenuTitle;

  /// No description provided for @libraryMenuSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Kitob olish va qaytarish'**
  String get libraryMenuSubtitle;

  /// No description provided for @eventsMenuTitle.
  ///
  /// In uz, this message translates to:
  /// **'Tadbirlar'**
  String get eventsMenuTitle;

  /// No description provided for @eventsMenuSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Maktab tadbirlari ro\'yxati'**
  String get eventsMenuSubtitle;

  /// No description provided for @logoutTitle.
  ///
  /// In uz, this message translates to:
  /// **'Tizimdan chiqish'**
  String get logoutTitle;

  /// No description provided for @logoutConfirmMessage.
  ///
  /// In uz, this message translates to:
  /// **'Haqiqatan ham hisobingizdan chiqmoqchimisiz?'**
  String get logoutConfirmMessage;

  /// No description provided for @cancel.
  ///
  /// In uz, this message translates to:
  /// **'Bekor qilish'**
  String get cancel;

  /// No description provided for @logoutAction.
  ///
  /// In uz, this message translates to:
  /// **'Chiqish'**
  String get logoutAction;

  /// No description provided for @profileLoadingTitle.
  ///
  /// In uz, this message translates to:
  /// **'Profil yuklanmoqda'**
  String get profileLoadingTitle;

  /// No description provided for @profileLoadingSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'O\'qituvchi ma\'lumotlari tayyorlanmoqda'**
  String get profileLoadingSubtitle;

  /// No description provided for @profileLoadErrorTitle.
  ///
  /// In uz, this message translates to:
  /// **'Profilni yuklab bo\'lmadi'**
  String get profileLoadErrorTitle;

  /// No description provided for @timetableTitle.
  ///
  /// In uz, this message translates to:
  /// **'Dars jadvali'**
  String get timetableTitle;

  /// No description provided for @noLessonsOnSelectedDate.
  ///
  /// In uz, this message translates to:
  /// **'Ushbu sanada darslar yo\'q'**
  String get noLessonsOnSelectedDate;

  /// No description provided for @unknownSubjectFallback.
  ///
  /// In uz, this message translates to:
  /// **'Fan noma\'lum'**
  String get unknownSubjectFallback;

  /// No description provided for @roomFallback.
  ///
  /// In uz, this message translates to:
  /// **'Xona -'**
  String get roomFallback;

  /// No description provided for @subjectsTitle.
  ///
  /// In uz, this message translates to:
  /// **'Mening fanlarim'**
  String get subjectsTitle;

  /// No description provided for @noAssignedSubjects.
  ///
  /// In uz, this message translates to:
  /// **'Sizga fanlar biriktirilmagan.'**
  String get noAssignedSubjects;

  /// No description provided for @addTopicTooltip.
  ///
  /// In uz, this message translates to:
  /// **'Yangi mavzu qo\'shish'**
  String get addTopicTooltip;

  /// No description provided for @noTopicsYet.
  ///
  /// In uz, this message translates to:
  /// **'Mavzular hozircha yo\'q'**
  String get noTopicsYet;

  /// No description provided for @noTopicsForGroup.
  ///
  /// In uz, this message translates to:
  /// **'Ushbu guruh uchun mavzular kiritilmagan.'**
  String get noTopicsForGroup;

  /// No description provided for @filesTitle.
  ///
  /// In uz, this message translates to:
  /// **'Fayllar'**
  String get filesTitle;

  /// No description provided for @fileOpenFailed.
  ///
  /// In uz, this message translates to:
  /// **'Kechirasiz, faylni ochib bo\'lmadi'**
  String get fileOpenFailed;

  /// No description provided for @newTopicTitle.
  ///
  /// In uz, this message translates to:
  /// **'Yangi mavzu'**
  String get newTopicTitle;

  /// No description provided for @topicTitleLabel.
  ///
  /// In uz, this message translates to:
  /// **'Sarlavha'**
  String get topicTitleLabel;

  /// No description provided for @topicTitleHint.
  ///
  /// In uz, this message translates to:
  /// **'Mavzu nomi'**
  String get topicTitleHint;

  /// No description provided for @topicDescriptionLabel.
  ///
  /// In uz, this message translates to:
  /// **'Qo\'shimcha ma\'lumotlar (ixtiyoriy)'**
  String get topicDescriptionLabel;

  /// No description provided for @topicDescriptionHint.
  ///
  /// In uz, this message translates to:
  /// **'Izoh...'**
  String get topicDescriptionHint;

  /// No description provided for @attachedFilesTitle.
  ///
  /// In uz, this message translates to:
  /// **'Biriktirilgan fayllar'**
  String get attachedFilesTitle;

  /// No description provided for @chooseFileAction.
  ///
  /// In uz, this message translates to:
  /// **'Fayl tanlash'**
  String get chooseFileAction;

  /// No description provided for @noFilesSelected.
  ///
  /// In uz, this message translates to:
  /// **'Hozircha fayllar tanlanmagan.'**
  String get noFilesSelected;

  /// No description provided for @addTopicAction.
  ///
  /// In uz, this message translates to:
  /// **'Mavzuni qo\'shish'**
  String get addTopicAction;

  /// No description provided for @topicTitleRequired.
  ///
  /// In uz, this message translates to:
  /// **'Mavzu sarlavhasini kiriting'**
  String get topicTitleRequired;

  /// No description provided for @topicFilesRequired.
  ///
  /// In uz, this message translates to:
  /// **'Kamida bitta PDF/DOC/Rasm fayl yuklash majburiy'**
  String get topicFilesRequired;

  /// No description provided for @topicSaved.
  ///
  /// In uz, this message translates to:
  /// **'Mavzu saqlandi'**
  String get topicSaved;

  /// No description provided for @paymentsTitle.
  ///
  /// In uz, this message translates to:
  /// **'To\'lovlar (o\'quvchilar)'**
  String get paymentsTitle;

  /// No description provided for @allGroups.
  ///
  /// In uz, this message translates to:
  /// **'Barcha guruhlar'**
  String get allGroups;

  /// No description provided for @searchStudentHint.
  ///
  /// In uz, this message translates to:
  /// **'O\'quvchini qidirish...'**
  String get searchStudentHint;

  /// No description provided for @noStudentsFound.
  ///
  /// In uz, this message translates to:
  /// **'O\'quvchilar topilmadi.'**
  String get noStudentsFound;

  /// No description provided for @paidStatus.
  ///
  /// In uz, this message translates to:
  /// **'To\'lagan'**
  String get paidStatus;

  /// No description provided for @debtorStatus.
  ///
  /// In uz, this message translates to:
  /// **'Qarzdor'**
  String get debtorStatus;

  /// No description provided for @studentPaymentsTitle.
  ///
  /// In uz, this message translates to:
  /// **'O\'quvchi to\'lovlari'**
  String get studentPaymentsTitle;

  /// No description provided for @newPaymentTitle.
  ///
  /// In uz, this message translates to:
  /// **'Yangi to\'lov'**
  String get newPaymentTitle;

  /// No description provided for @paymentTypeLabel.
  ///
  /// In uz, this message translates to:
  /// **'To\'lov turi'**
  String get paymentTypeLabel;

  /// No description provided for @monthlyPaymentType.
  ///
  /// In uz, this message translates to:
  /// **'Oylik to\'lov'**
  String get monthlyPaymentType;

  /// No description provided for @yearlyPaymentType.
  ///
  /// In uz, this message translates to:
  /// **'Yillik to\'lov'**
  String get yearlyPaymentType;

  /// No description provided for @yearLabel.
  ///
  /// In uz, this message translates to:
  /// **'Yil'**
  String get yearLabel;

  /// No description provided for @monthLabel.
  ///
  /// In uz, this message translates to:
  /// **'Oy'**
  String get monthLabel;

  /// No description provided for @paymentMethodLabel.
  ///
  /// In uz, this message translates to:
  /// **'To\'lov usuli'**
  String get paymentMethodLabel;

  /// No description provided for @paymentMethodCash.
  ///
  /// In uz, this message translates to:
  /// **'Naqd pul'**
  String get paymentMethodCash;

  /// No description provided for @paymentMethodCard.
  ///
  /// In uz, this message translates to:
  /// **'Plastik karta'**
  String get paymentMethodCard;

  /// No description provided for @paymentMethodTransfer.
  ///
  /// In uz, this message translates to:
  /// **'Karta orqali o\'tkazma (P2P)'**
  String get paymentMethodTransfer;

  /// No description provided for @paymentMethodTerminal.
  ///
  /// In uz, this message translates to:
  /// **'Terminal'**
  String get paymentMethodTerminal;

  /// No description provided for @amountLabel.
  ///
  /// In uz, this message translates to:
  /// **'Summa'**
  String get amountLabel;

  /// No description provided for @amountCurrencyLabel.
  ///
  /// In uz, this message translates to:
  /// **'Summa (so\'m)'**
  String get amountCurrencyLabel;

  /// No description provided for @noteOptional.
  ///
  /// In uz, this message translates to:
  /// **'Izoh (ixtiyoriy)'**
  String get noteOptional;

  /// No description provided for @confirmAction.
  ///
  /// In uz, this message translates to:
  /// **'Tasdiqlash'**
  String get confirmAction;

  /// No description provided for @paymentAmountRequired.
  ///
  /// In uz, this message translates to:
  /// **'To\'lov summasini kiriting'**
  String get paymentAmountRequired;

  /// No description provided for @paymentAccepted.
  ///
  /// In uz, this message translates to:
  /// **'To\'lov qabul qilindi!'**
  String get paymentAccepted;

  /// No description provided for @paymentHistoryTitle.
  ///
  /// In uz, this message translates to:
  /// **'To\'lovlar tarixi'**
  String get paymentHistoryTitle;

  /// No description provided for @noPaymentsForStudent.
  ///
  /// In uz, this message translates to:
  /// **'Ushbu o\'quvchida to\'lovlar yo\'q.'**
  String get noPaymentsForStudent;

  /// No description provided for @monthlyFeeLabel.
  ///
  /// In uz, this message translates to:
  /// **'Oylik to\'lov'**
  String get monthlyFeeLabel;

  /// No description provided for @discountLabel.
  ///
  /// In uz, this message translates to:
  /// **'Chegirma'**
  String get discountLabel;

  /// No description provided for @currencySymbol.
  ///
  /// In uz, this message translates to:
  /// **'So\'m'**
  String get currencySymbol;

  /// No description provided for @saveAction.
  ///
  /// In uz, this message translates to:
  /// **'Saqlash'**
  String get saveAction;

  /// No description provided for @editAction.
  ///
  /// In uz, this message translates to:
  /// **'Tahrirlash'**
  String get editAction;

  /// No description provided for @homeworkListTitle.
  ///
  /// In uz, this message translates to:
  /// **'Uyga vazifalar'**
  String get homeworkListTitle;

  /// No description provided for @noAssignedHomeworks.
  ///
  /// In uz, this message translates to:
  /// **'Hali vazifalar biriktirilmagan.'**
  String get noAssignedHomeworks;

  /// No description provided for @homeworkGroupFallback.
  ///
  /// In uz, this message translates to:
  /// **'Guruh'**
  String get homeworkGroupFallback;

  /// No description provided for @homeworkDescriptionFallback.
  ///
  /// In uz, this message translates to:
  /// **'Tavsif yo\'q'**
  String get homeworkDescriptionFallback;

  /// No description provided for @homeworkCreateTitle.
  ///
  /// In uz, this message translates to:
  /// **'Yangi vazifa'**
  String get homeworkCreateTitle;

  /// No description provided for @homeworkTitleLabel.
  ///
  /// In uz, this message translates to:
  /// **'Sarlavha'**
  String get homeworkTitleLabel;

  /// No description provided for @homeworkTitleHint.
  ///
  /// In uz, this message translates to:
  /// **'Masalan: 5-mashq'**
  String get homeworkTitleHint;

  /// No description provided for @homeworkDescriptionTitle.
  ///
  /// In uz, this message translates to:
  /// **'Tavsif'**
  String get homeworkDescriptionTitle;

  /// No description provided for @homeworkDescriptionHint.
  ///
  /// In uz, this message translates to:
  /// **'Vazifa haqida batafsil...'**
  String get homeworkDescriptionHint;

  /// No description provided for @homeworkDueDateTitle.
  ///
  /// In uz, this message translates to:
  /// **'Topshirish muddati (ixtiyoriy)'**
  String get homeworkDueDateTitle;

  /// No description provided for @homeworkSelectDueDate.
  ///
  /// In uz, this message translates to:
  /// **'Muddatni tanlang'**
  String get homeworkSelectDueDate;

  /// No description provided for @homeworkTitleRequired.
  ///
  /// In uz, this message translates to:
  /// **'Sarlavhani kiriting'**
  String get homeworkTitleRequired;

  /// No description provided for @homeworkCreatedSuccess.
  ///
  /// In uz, this message translates to:
  /// **'Vazifa yaratildi!'**
  String get homeworkCreatedSuccess;

  /// No description provided for @homeworkCheckDialogTitle.
  ///
  /// In uz, this message translates to:
  /// **'Baho qo\'yish'**
  String get homeworkCheckDialogTitle;

  /// No description provided for @homeworkCommentHint.
  ///
  /// In uz, this message translates to:
  /// **'Izoh (ixtiyoriy)'**
  String get homeworkCommentHint;

  /// No description provided for @homeworkNoSubmissions.
  ///
  /// In uz, this message translates to:
  /// **'Hozircha vazifalar topshirilmagan.'**
  String get homeworkNoSubmissions;

  /// No description provided for @homeworkGradedStatus.
  ///
  /// In uz, this message translates to:
  /// **'Baholangan'**
  String get homeworkGradedStatus;

  /// No description provided for @homeworkSubmittedStatus.
  ///
  /// In uz, this message translates to:
  /// **'Javob berilgan'**
  String get homeworkSubmittedStatus;

  /// No description provided for @homeworkViewFileAction.
  ///
  /// In uz, this message translates to:
  /// **'Faylni ko\'rish'**
  String get homeworkViewFileAction;

  /// No description provided for @gradeAction.
  ///
  /// In uz, this message translates to:
  /// **'Baho qo\'yish'**
  String get gradeAction;

  /// No description provided for @eventsEmptyTitle.
  ///
  /// In uz, this message translates to:
  /// **'Faol tadbirlar yo\'q'**
  String get eventsEmptyTitle;

  /// No description provided for @eventsEmptyMessage.
  ///
  /// In uz, this message translates to:
  /// **'Hozircha faol tadbirlar ro\'yxatga olinmagan.'**
  String get eventsEmptyMessage;

  /// No description provided for @eventsLoadingTitle.
  ///
  /// In uz, this message translates to:
  /// **'Tadbirlar yuklanmoqda'**
  String get eventsLoadingTitle;

  /// No description provided for @eventsLoadingSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Maktab kalendari yangilanmoqda'**
  String get eventsLoadingSubtitle;

  /// No description provided for @eventsLoadErrorTitle.
  ///
  /// In uz, this message translates to:
  /// **'Tadbirlarni yuklab bo\'lmadi'**
  String get eventsLoadErrorTitle;

  /// No description provided for @eventFallbackTitle.
  ///
  /// In uz, this message translates to:
  /// **'Tadbir'**
  String get eventFallbackTitle;

  /// No description provided for @eventDateUnavailable.
  ///
  /// In uz, this message translates to:
  /// **'Sana ko\'rsatilmagan'**
  String get eventDateUnavailable;

  /// No description provided for @eventTypeHoliday.
  ///
  /// In uz, this message translates to:
  /// **'Bayram'**
  String get eventTypeHoliday;

  /// No description provided for @eventTypeExam.
  ///
  /// In uz, this message translates to:
  /// **'Imtihon'**
  String get eventTypeExam;

  /// No description provided for @eventTypeMeeting.
  ///
  /// In uz, this message translates to:
  /// **'Uchrashuv'**
  String get eventTypeMeeting;

  /// No description provided for @eventTypeSport.
  ///
  /// In uz, this message translates to:
  /// **'Sport'**
  String get eventTypeSport;

  /// No description provided for @eventTypeOther.
  ///
  /// In uz, this message translates to:
  /// **'Boshqa'**
  String get eventTypeOther;

  /// No description provided for @librarySearchHint.
  ///
  /// In uz, this message translates to:
  /// **'Kitob, muallif yoki ISBN bo‘yicha qidiring'**
  String get librarySearchHint;

  /// No description provided for @libraryBorrowedSuccess.
  ///
  /// In uz, this message translates to:
  /// **'Kitob muvaffaqiyatli olindi'**
  String get libraryBorrowedSuccess;

  /// No description provided for @libraryReturnedSuccess.
  ///
  /// In uz, this message translates to:
  /// **'Kitob qaytarildi'**
  String get libraryReturnedSuccess;

  /// No description provided for @libraryMyBooksTitle.
  ///
  /// In uz, this message translates to:
  /// **'Mening kitoblarim'**
  String get libraryMyBooksTitle;

  /// No description provided for @libraryCatalogTitle.
  ///
  /// In uz, this message translates to:
  /// **'Katalog'**
  String get libraryCatalogTitle;

  /// No description provided for @libraryNoLoansMessage.
  ///
  /// In uz, this message translates to:
  /// **'Siz hali kutubxonadan kitob olmagansiz.'**
  String get libraryNoLoansMessage;

  /// No description provided for @libraryNoBooksMessage.
  ///
  /// In uz, this message translates to:
  /// **'So‘rovingiz bo‘yicha kitob topilmadi.'**
  String get libraryNoBooksMessage;

  /// No description provided for @libraryLoadingTitle.
  ///
  /// In uz, this message translates to:
  /// **'Kutubxona yuklanmoqda'**
  String get libraryLoadingTitle;

  /// No description provided for @libraryLoadingSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Kitoblar va qarz yozuvlari olinmoqda'**
  String get libraryLoadingSubtitle;

  /// No description provided for @libraryLoadErrorTitle.
  ///
  /// In uz, this message translates to:
  /// **'Kutubxonani yuklab bo\'lmadi'**
  String get libraryLoadErrorTitle;

  /// No description provided for @libraryBookFallback.
  ///
  /// In uz, this message translates to:
  /// **'Kitob'**
  String get libraryBookFallback;

  /// No description provided for @libraryBorrowedStatus.
  ///
  /// In uz, this message translates to:
  /// **'Qo‘lingizda'**
  String get libraryBorrowedStatus;

  /// No description provided for @libraryReturnedStatus.
  ///
  /// In uz, this message translates to:
  /// **'Qaytarilgan'**
  String get libraryReturnedStatus;

  /// No description provided for @libraryReturnAction.
  ///
  /// In uz, this message translates to:
  /// **'Qaytarish'**
  String get libraryReturnAction;

  /// No description provided for @libraryBorrowAction.
  ///
  /// In uz, this message translates to:
  /// **'Olish'**
  String get libraryBorrowAction;

  /// No description provided for @libraryUnavailableAction.
  ///
  /// In uz, this message translates to:
  /// **'Mavjud emas'**
  String get libraryUnavailableAction;

  /// No description provided for @assessmentRequiredFields.
  ///
  /// In uz, this message translates to:
  /// **'Barcha majburiy maydonlarni tanlang'**
  String get assessmentRequiredFields;

  /// No description provided for @assessmentCreatedSuccess.
  ///
  /// In uz, this message translates to:
  /// **'Imtihon muvaffaqiyatli yaratildi!'**
  String get assessmentCreatedSuccess;

  /// No description provided for @assessmentCreateTitle.
  ///
  /// In uz, this message translates to:
  /// **'Yangi imtihon'**
  String get assessmentCreateTitle;

  /// No description provided for @assessmentQuarterLabel.
  ///
  /// In uz, this message translates to:
  /// **'Chorak'**
  String get assessmentQuarterLabel;

  /// No description provided for @assessmentGroupLabel.
  ///
  /// In uz, this message translates to:
  /// **'Guruh'**
  String get assessmentGroupLabel;

  /// No description provided for @assessmentSubjectLabel.
  ///
  /// In uz, this message translates to:
  /// **'Fan'**
  String get assessmentSubjectLabel;

  /// No description provided for @assessmentTypeFieldLabel.
  ///
  /// In uz, this message translates to:
  /// **'Imtihon turi'**
  String get assessmentTypeFieldLabel;

  /// No description provided for @assessmentOptionalTitleLabel.
  ///
  /// In uz, this message translates to:
  /// **'Sarlavha (ixtiyoriy)'**
  String get assessmentOptionalTitleLabel;

  /// No description provided for @assessmentOptionalTitleHint.
  ///
  /// In uz, this message translates to:
  /// **'Masalan: 1-chorak nazorat ishi'**
  String get assessmentOptionalTitleHint;

  /// No description provided for @assessmentMaxScoreLabel.
  ///
  /// In uz, this message translates to:
  /// **'Maksimal ball'**
  String get assessmentMaxScoreLabel;

  /// No description provided for @assessmentWeightLabel.
  ///
  /// In uz, this message translates to:
  /// **'Vazni (%)'**
  String get assessmentWeightLabel;

  /// No description provided for @assessmentDateLabel.
  ///
  /// In uz, this message translates to:
  /// **'O\'tkazilish sanasi'**
  String get assessmentDateLabel;

  /// No description provided for @assessmentSelectDate.
  ///
  /// In uz, this message translates to:
  /// **'Sana tanlang'**
  String get assessmentSelectDate;

  /// No description provided for @assessmentResultsSaved.
  ///
  /// In uz, this message translates to:
  /// **'Natijalar muvaffaqiyatli saqlandi'**
  String get assessmentResultsSaved;

  /// No description provided for @assessmentNoStudents.
  ///
  /// In uz, this message translates to:
  /// **'Ushbu guruhda o\'quvchilar topilmadi.'**
  String get assessmentNoStudents;

  /// No description provided for @assessmentScoreLabel.
  ///
  /// In uz, this message translates to:
  /// **'Ball:'**
  String get assessmentScoreLabel;

  /// No description provided for @assessmentScoreHint.
  ///
  /// In uz, this message translates to:
  /// **'0-100'**
  String get assessmentScoreHint;

  /// No description provided for @assessmentCommentLabel.
  ///
  /// In uz, this message translates to:
  /// **'Izoh:'**
  String get assessmentCommentLabel;

  /// No description provided for @assessmentCommentHintEmpty.
  ///
  /// In uz, this message translates to:
  /// **'Kiritilmadi'**
  String get assessmentCommentHintEmpty;

  /// No description provided for @conferenceCreateTitle.
  ///
  /// In uz, this message translates to:
  /// **'Majlis yaratish'**
  String get conferenceCreateTitle;

  /// No description provided for @conferenceSelectDateLabel.
  ///
  /// In uz, this message translates to:
  /// **'Sanani tanlang:'**
  String get conferenceSelectDateLabel;

  /// No description provided for @conferenceLocationLabel.
  ///
  /// In uz, this message translates to:
  /// **'Manzil / Xona:'**
  String get conferenceLocationLabel;

  /// No description provided for @conferenceLocationHint.
  ///
  /// In uz, this message translates to:
  /// **'Masalan: 204-xona yoki Zoom'**
  String get conferenceLocationHint;

  /// No description provided for @conferenceSlotsLabel.
  ///
  /// In uz, this message translates to:
  /// **'Vaqt oraliqlari (slotlar):'**
  String get conferenceSlotsLabel;

  /// No description provided for @conferenceNoSlots.
  ///
  /// In uz, this message translates to:
  /// **'Hali slotlar qo\'shilmadi'**
  String get conferenceNoSlots;

  /// No description provided for @conferenceCreateSuccess.
  ///
  /// In uz, this message translates to:
  /// **'Muvaffaqiyatli yaratildi!'**
  String get conferenceCreateSuccess;

  /// No description provided for @assessmentsListTitle.
  ///
  /// In uz, this message translates to:
  /// **'Imtihon va baholashlar'**
  String get assessmentsListTitle;

  /// No description provided for @addAssessmentTooltip.
  ///
  /// In uz, this message translates to:
  /// **'Yangi imtihon qo\'shish'**
  String get addAssessmentTooltip;

  /// No description provided for @assessmentsListEmpty.
  ///
  /// In uz, this message translates to:
  /// **'Hali imtihonlar qo\'shilmagan.'**
  String get assessmentsListEmpty;

  /// No description provided for @assessmentFallbackTitle.
  ///
  /// In uz, this message translates to:
  /// **'Imtihon'**
  String get assessmentFallbackTitle;

  /// No description provided for @assessmentUnknownGroup.
  ///
  /// In uz, this message translates to:
  /// **'Noma\'lum guruh'**
  String get assessmentUnknownGroup;

  /// No description provided for @profileEditTitle.
  ///
  /// In uz, this message translates to:
  /// **'Profilni tahrirlash'**
  String get profileEditTitle;

  /// No description provided for @profileUpdatedSuccess.
  ///
  /// In uz, this message translates to:
  /// **'Profil yangilandi'**
  String get profileUpdatedSuccess;

  /// No description provided for @dateInputHint.
  ///
  /// In uz, this message translates to:
  /// **'YYYY-MM-DD'**
  String get dateInputHint;

  /// No description provided for @alreadyUploadedLabel.
  ///
  /// In uz, this message translates to:
  /// **'Avval yuklangan'**
  String get alreadyUploadedLabel;

  /// No description provided for @selectAction.
  ///
  /// In uz, this message translates to:
  /// **'Tanlash'**
  String get selectAction;

  /// No description provided for @documentNotSelected.
  ///
  /// In uz, this message translates to:
  /// **'Hujjat tanlanmagan'**
  String get documentNotSelected;

  /// No description provided for @portfolioCreateTitle.
  ///
  /// In uz, this message translates to:
  /// **'Ilmiy ish qo\'shish'**
  String get portfolioCreateTitle;

  /// No description provided for @portfolioWorkFallbackTitle.
  ///
  /// In uz, this message translates to:
  /// **'Ilmiy ish'**
  String get portfolioWorkFallbackTitle;

  /// No description provided for @portfolioWorkTitleLabel.
  ///
  /// In uz, this message translates to:
  /// **'Sarlavha'**
  String get portfolioWorkTitleLabel;

  /// No description provided for @portfolioWorkTitleHint.
  ///
  /// In uz, this message translates to:
  /// **'Maqola yoki kitob nomi'**
  String get portfolioWorkTitleHint;

  /// No description provided for @portfolioPublishedPlaceLabel.
  ///
  /// In uz, this message translates to:
  /// **'Nashr qilingan joy'**
  String get portfolioPublishedPlaceLabel;

  /// No description provided for @portfolioPublishedPlaceHint.
  ///
  /// In uz, this message translates to:
  /// **'Jurnal yoki nashriyot'**
  String get portfolioPublishedPlaceHint;

  /// No description provided for @portfolioPublishedDateLabel.
  ///
  /// In uz, this message translates to:
  /// **'Nashr sanasi'**
  String get portfolioPublishedDateLabel;

  /// No description provided for @portfolioCoauthorSearchTitle.
  ///
  /// In uz, this message translates to:
  /// **'Hammuallif qidirish'**
  String get portfolioCoauthorSearchTitle;

  /// No description provided for @portfolioCoauthorSearchHint.
  ///
  /// In uz, this message translates to:
  /// **'Passport seriyasi yoki raqami bo‘yicha qidiring'**
  String get portfolioCoauthorSearchHint;

  /// No description provided for @addAction.
  ///
  /// In uz, this message translates to:
  /// **'Qo‘shish'**
  String get addAction;

  /// No description provided for @pdfOnlyFileLabel.
  ///
  /// In uz, this message translates to:
  /// **'Fayl (faqat PDF)'**
  String get pdfOnlyFileLabel;

  /// No description provided for @uploadAction.
  ///
  /// In uz, this message translates to:
  /// **'Yuklash'**
  String get uploadAction;

  /// No description provided for @portfolioTitleRequired.
  ///
  /// In uz, this message translates to:
  /// **'Sarlavhani kiriting'**
  String get portfolioTitleRequired;

  /// No description provided for @portfolioWorkAdded.
  ///
  /// In uz, this message translates to:
  /// **'Ilmiy ish qo\'shildi'**
  String get portfolioWorkAdded;

  /// No description provided for @lessonSessionTitle.
  ///
  /// In uz, this message translates to:
  /// **'Dars baholari'**
  String get lessonSessionTitle;

  /// No description provided for @addHomeworkTooltip.
  ///
  /// In uz, this message translates to:
  /// **'Uyga vazifa qo\'shish'**
  String get addHomeworkTooltip;

  /// No description provided for @lessonSessionLoadingTitle.
  ///
  /// In uz, this message translates to:
  /// **'Dars sessiyasi yuklanmoqda'**
  String get lessonSessionLoadingTitle;

  /// No description provided for @lessonSessionLoadingSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Baholar va mavzu ma\'lumotlari olinmoqda'**
  String get lessonSessionLoadingSubtitle;

  /// No description provided for @lessonSessionLoadErrorTitle.
  ///
  /// In uz, this message translates to:
  /// **'Dars sessiyasini yuklab bo\'lmadi'**
  String get lessonSessionLoadErrorTitle;

  /// No description provided for @lessonSessionSavedSuccess.
  ///
  /// In uz, this message translates to:
  /// **'Dars muvaffaqiyatli saqlandi!'**
  String get lessonSessionSavedSuccess;

  /// No description provided for @lessonSessionSaveErrorFallback.
  ///
  /// In uz, this message translates to:
  /// **'Saqlashda xatolik yuz berdi'**
  String get lessonSessionSaveErrorFallback;

  /// No description provided for @lessonSessionTopicLabel.
  ///
  /// In uz, this message translates to:
  /// **'Mavzu'**
  String get lessonSessionTopicLabel;

  /// No description provided for @lessonSessionTopicHint.
  ///
  /// In uz, this message translates to:
  /// **'Bugungi dars mavzusini kiriting...'**
  String get lessonSessionTopicHint;

  /// No description provided for @lessonSessionStudentsTitle.
  ///
  /// In uz, this message translates to:
  /// **'O\'quvchilar bahosi'**
  String get lessonSessionStudentsTitle;

  /// No description provided for @presentStatusShort.
  ///
  /// In uz, this message translates to:
  /// **'Keldi'**
  String get presentStatusShort;

  /// No description provided for @absentStatusShort.
  ///
  /// In uz, this message translates to:
  /// **'Kelmadi'**
  String get absentStatusShort;

  /// No description provided for @dashboardQuickActionsTitle.
  ///
  /// In uz, this message translates to:
  /// **'Tezkor harakatlar'**
  String get dashboardQuickActionsTitle;

  /// No description provided for @dashboardRecentAssessmentsTitle.
  ///
  /// In uz, this message translates to:
  /// **'So\'nggi baholashlar'**
  String get dashboardRecentAssessmentsTitle;

  /// No description provided for @dashboardRecentAssessmentsEmptyTitle.
  ///
  /// In uz, this message translates to:
  /// **'Baholashlar topilmadi'**
  String get dashboardRecentAssessmentsEmptyTitle;

  /// No description provided for @dashboardRecentAssessmentsEmptyMessage.
  ///
  /// In uz, this message translates to:
  /// **'Hozircha yaqinda baholangan imtihonlar yo\'q.'**
  String get dashboardRecentAssessmentsEmptyMessage;

  /// No description provided for @dashboardLoadingTitle.
  ///
  /// In uz, this message translates to:
  /// **'Dashboard yuklanmoqda'**
  String get dashboardLoadingTitle;

  /// No description provided for @dashboardLoadingSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Asosiy statistikalar olinmoqda'**
  String get dashboardLoadingSubtitle;

  /// No description provided for @dashboardLoadErrorTitle.
  ///
  /// In uz, this message translates to:
  /// **'Dashboardni yuklab bo\'lmadi'**
  String get dashboardLoadErrorTitle;

  /// No description provided for @dashboardWeeklyInsightsTitle.
  ///
  /// In uz, this message translates to:
  /// **'Haftalik tahlillar'**
  String get dashboardWeeklyInsightsTitle;

  /// No description provided for @dashboardAttendanceChartTitle.
  ///
  /// In uz, this message translates to:
  /// **'Haftalik davomat'**
  String get dashboardAttendanceChartTitle;

  /// No description provided for @dashboardPendingTasksTitle.
  ///
  /// In uz, this message translates to:
  /// **'Kutilayotgan vazifalar'**
  String get dashboardPendingTasksTitle;

  /// No description provided for @dashboardGroupsLabel.
  ///
  /// In uz, this message translates to:
  /// **'Guruhlar'**
  String get dashboardGroupsLabel;

  /// No description provided for @dashboardSubjectsLabel.
  ///
  /// In uz, this message translates to:
  /// **'Fanlar'**
  String get dashboardSubjectsLabel;

  /// No description provided for @dashboardStudentsLabel.
  ///
  /// In uz, this message translates to:
  /// **'O\'quvchilar'**
  String get dashboardStudentsLabel;

  /// No description provided for @dashboardAbsentLabel.
  ///
  /// In uz, this message translates to:
  /// **'Yo\'qlar'**
  String get dashboardAbsentLabel;

  /// No description provided for @dashboardAttendanceAction.
  ///
  /// In uz, this message translates to:
  /// **'Davomat'**
  String get dashboardAttendanceAction;

  /// No description provided for @dashboardExcusesAction.
  ///
  /// In uz, this message translates to:
  /// **'Sababnomalar'**
  String get dashboardExcusesAction;

  /// No description provided for @dashboardConferencesAction.
  ///
  /// In uz, this message translates to:
  /// **'Majlislar'**
  String get dashboardConferencesAction;

  /// No description provided for @dashboardHomeworkAction.
  ///
  /// In uz, this message translates to:
  /// **'Uyga vazifa'**
  String get dashboardHomeworkAction;

  /// No description provided for @dashboardAssessmentsAction.
  ///
  /// In uz, this message translates to:
  /// **'Imtihonlar'**
  String get dashboardAssessmentsAction;

  /// No description provided for @dashboardSubjectsAction.
  ///
  /// In uz, this message translates to:
  /// **'Fanlar'**
  String get dashboardSubjectsAction;

  /// No description provided for @dashboardLessonsLabel.
  ///
  /// In uz, this message translates to:
  /// **'Darslar'**
  String get dashboardLessonsLabel;

  /// No description provided for @dashboardOpenSessionsLabel.
  ///
  /// In uz, this message translates to:
  /// **'Ochiq session'**
  String get dashboardOpenSessionsLabel;

  /// No description provided for @dashboardClosedSessionsLabel.
  ///
  /// In uz, this message translates to:
  /// **'Yopilgan'**
  String get dashboardClosedSessionsLabel;

  /// No description provided for @dashboardTodayDateUnavailable.
  ///
  /// In uz, this message translates to:
  /// **'Bugungi sana mavjud emas'**
  String get dashboardTodayDateUnavailable;

  /// No description provided for @dashboardYearFallbackBadge.
  ///
  /// In uz, this message translates to:
  /// **'O\'quv yili'**
  String get dashboardYearFallbackBadge;

  /// No description provided for @dashboardQuarterFallbackBadge.
  ///
  /// In uz, this message translates to:
  /// **'Chorak belgilanmagan'**
  String get dashboardQuarterFallbackBadge;

  /// No description provided for @gradesListTitle.
  ///
  /// In uz, this message translates to:
  /// **'O\'quvchilar baholari'**
  String get gradesListTitle;

  /// No description provided for @gradesQuarterTab.
  ///
  /// In uz, this message translates to:
  /// **'Choraklik'**
  String get gradesQuarterTab;

  /// No description provided for @gradesYearTab.
  ///
  /// In uz, this message translates to:
  /// **'Yillik'**
  String get gradesYearTab;

  /// No description provided for @gradesEmptyMessage.
  ///
  /// In uz, this message translates to:
  /// **'Baholar topilmadi.'**
  String get gradesEmptyMessage;

  /// No description provided for @gradesLoadingTitle.
  ///
  /// In uz, this message translates to:
  /// **'Baholar yuklanmoqda'**
  String get gradesLoadingTitle;

  /// No description provided for @gradesLoadingSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'O\'quvchilar natijalari tayyorlanmoqda'**
  String get gradesLoadingSubtitle;

  /// No description provided for @gradesLoadErrorTitle.
  ///
  /// In uz, this message translates to:
  /// **'Baholarni yuklab bo\'lmadi'**
  String get gradesLoadErrorTitle;

  /// No description provided for @gradesSearchHint.
  ///
  /// In uz, this message translates to:
  /// **'Ism, tel, email...'**
  String get gradesSearchHint;

  /// No description provided for @unknownStudentFallback.
  ///
  /// In uz, this message translates to:
  /// **'Noma\'lum o\'quvchi'**
  String get unknownStudentFallback;

  /// No description provided for @unknownGroupFallback.
  ///
  /// In uz, this message translates to:
  /// **'Guruh noma\'lum'**
  String get unknownGroupFallback;

  /// No description provided for @mealsReportTitle.
  ///
  /// In uz, this message translates to:
  /// **'Ovqatlanish hisoboti'**
  String get mealsReportTitle;

  /// No description provided for @mealsNoGroupsMessage.
  ///
  /// In uz, this message translates to:
  /// **'Guruhlar topilmadi.'**
  String get mealsNoGroupsMessage;

  /// No description provided for @mealsNameLabel.
  ///
  /// In uz, this message translates to:
  /// **'Ovqat nomi'**
  String get mealsNameLabel;

  /// No description provided for @mealsNameHint.
  ///
  /// In uz, this message translates to:
  /// **'Masalan: Macaroni with cheese'**
  String get mealsNameHint;

  /// No description provided for @mealsRecipeLabel.
  ///
  /// In uz, this message translates to:
  /// **'Tarkibi / retsept'**
  String get mealsRecipeLabel;

  /// No description provided for @mealsRecipeHint.
  ///
  /// In uz, this message translates to:
  /// **'Tarkibi: un, suv, pishloq...'**
  String get mealsRecipeHint;

  /// No description provided for @mealsImagesLabel.
  ///
  /// In uz, this message translates to:
  /// **'Rasmlar (dalil uchun)'**
  String get mealsImagesLabel;

  /// No description provided for @mealsAddImageAction.
  ///
  /// In uz, this message translates to:
  /// **'Rasm qo\'shish'**
  String get mealsAddImageAction;

  /// No description provided for @mealsSystemImagesTitle.
  ///
  /// In uz, this message translates to:
  /// **'Tizimdagi rasmlar'**
  String get mealsSystemImagesTitle;

  /// No description provided for @mealsSaveAction.
  ///
  /// In uz, this message translates to:
  /// **'Hisobotni saqlash'**
  String get mealsSaveAction;

  /// No description provided for @mealsGroupLabel.
  ///
  /// In uz, this message translates to:
  /// **'Guruh'**
  String get mealsGroupLabel;

  /// No description provided for @mealsTimeLabel.
  ///
  /// In uz, this message translates to:
  /// **'Vaqt'**
  String get mealsTimeLabel;

  /// No description provided for @mealsLoadingTitle.
  ///
  /// In uz, this message translates to:
  /// **'Ovqatlanish hisobotlari yuklanmoqda'**
  String get mealsLoadingTitle;

  /// No description provided for @mealsLoadingSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Guruhlar va bugungi ma\'lumotlar olinmoqda'**
  String get mealsLoadingSubtitle;

  /// No description provided for @mealsLoadErrorTitle.
  ///
  /// In uz, this message translates to:
  /// **'Ovqatlanish hisobotini yuklab bo\'lmadi'**
  String get mealsLoadErrorTitle;

  /// No description provided for @mealsNameRequired.
  ///
  /// In uz, this message translates to:
  /// **'Ovqat nomini kiriting!'**
  String get mealsNameRequired;

  /// No description provided for @mealsSavedSuccess.
  ///
  /// In uz, this message translates to:
  /// **'Hisobot saqlandi!'**
  String get mealsSavedSuccess;

  /// No description provided for @langUz.
  ///
  /// In uz, this message translates to:
  /// **'O\'zbekcha'**
  String get langUz;

  /// No description provided for @langRu.
  ///
  /// In uz, this message translates to:
  /// **'Ruscha'**
  String get langRu;

  /// No description provided for @langEn.
  ///
  /// In uz, this message translates to:
  /// **'Inglizcha'**
  String get langEn;

  /// No description provided for @paymentSuccessTitle.
  ///
  /// In uz, this message translates to:
  /// **'To\'lov muvaffaqiyatli!'**
  String get paymentSuccessTitle;

  /// No description provided for @paymentSuccessMessage.
  ///
  /// In uz, this message translates to:
  /// **'Mablag\' to\'liq qabul qilindi va tizimda aks etdi.'**
  String get paymentSuccessMessage;

  /// No description provided for @backToHome.
  ///
  /// In uz, this message translates to:
  /// **'Asosiy ekranga qaytish'**
  String get backToHome;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru', 'uz'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
    case 'uz':
      return AppLocalizationsUz();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
