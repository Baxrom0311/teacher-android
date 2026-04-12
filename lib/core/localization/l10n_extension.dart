import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' as intl;
import 'package:teacher_school_app/l10n/app_localizations.dart';

import 'app_locale.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n =>
      AppLocalizations.of(this) ?? AppLocalizationsRegistry.instance;
}

extension AppLocalizationsHelpers on AppLocalizations {
  AppLocale get appLocale => appLocaleFromCode(localeName.split('_').first);

  String get intlLocaleTag => localeName.replaceAll('_', '-');

  bool get _isUz => localeName.startsWith('uz');
  bool get _isRu => localeName.startsWith('ru');

  String _pick({required String uz, required String ru, required String en}) {
    if (_isUz) return uz;
    if (_isRu) return ru;
    return en;
  }

  String _formatDate(dynamic value) {
    if (value == null) return '-';
    if (value is DateTime) {
      return intl.DateFormat.yMMMd(intlLocaleTag).format(value);
    }

    final raw = value.toString();
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) return raw;
    return intl.DateFormat.yMMMd(intlLocaleTag).format(parsed);
  }

  String _humanizeKey(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) return '-';

    return normalized
        .split('_')
        .map(
          (part) => part.isEmpty
              ? part
              : '${part[0].toUpperCase()}${part.substring(1)}',
        )
        .join(' ');
  }

  String lessonOrderLabel(int order) =>
      _pick(uz: '$order-dars', ru: '$order-й урок', en: 'Lesson $order');

  String assessmentTypeLabelText(String type) {
    switch (type.toLowerCase()) {
      case 'quiz':
        return _pick(uz: 'Test', ru: 'Тест', en: 'Quiz');
      case 'oral':
        return _pick(uz: 'Og\'zaki', ru: 'Устный', en: 'Oral');
      case 'written':
        return _pick(uz: 'Yozma', ru: 'Письменный', en: 'Written');
      case 'practical':
        return _pick(uz: 'Amaliy', ru: 'Практический', en: 'Practical');
      case 'midterm':
        return _pick(uz: 'Oraliq', ru: 'Промежуточный', en: 'Midterm');
      case 'final':
        return _pick(uz: 'Yakuniy', ru: 'Итоговый', en: 'Final');
      default:
        return _humanizeKey(type);
    }
  }

  String assessmentMaxScoreText(num? score) =>
      '$assessmentMaxScoreLabel: ${score ?? 0}';

  String assessmentWeightText(num? weight) =>
      '$assessmentWeightLabel: ${weight ?? 0}%';

  String genderLabelText(String gender) {
    switch (gender.toLowerCase()) {
      case 'male':
        return _pick(uz: 'Erkak', ru: 'Мужской', en: 'Male');
      case 'female':
        return _pick(uz: 'Ayol', ru: 'Женский', en: 'Female');
      default:
        return _humanizeKey(gender);
    }
  }

  String groupLabelText(String groupName) => _pick(
    uz: 'Guruh: $groupName',
    ru: 'Группа: $groupName',
    en: 'Group: $groupName',
  );

  String gradesQuarterLabel(String quarterName) => _pick(
    uz: 'Chorak: $quarterName',
    ru: 'Четверть: $quarterName',
    en: 'Quarter: $quarterName',
  );

  String roomLabelText(String roomName) => _pick(
    uz: 'Xona: $roomName',
    ru: 'Кабинет: $roomName',
    en: 'Room: $roomName',
  );

  String absenceStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return _pick(uz: 'Tasdiqlangan', ru: 'Одобрено', en: 'Approved');
      case 'rejected':
        return _pick(uz: 'Rad etilgan', ru: 'Отклонено', en: 'Rejected');
      default:
        return _pick(uz: 'Kutilmoqda', ru: 'Ожидает', en: 'Pending');
    }
  }

  String absenceDateLabel(dynamic date) => _pick(
    uz: 'Sana: ${_formatDate(date)}',
    ru: 'Дата: ${_formatDate(date)}',
    en: 'Date: ${_formatDate(date)}',
  );

  String absenceReasonLabel(String reason) => _pick(
    uz: 'Sabab: $reason',
    ru: 'Причина: $reason',
    en: 'Reason: $reason',
  );

  String attendanceMockStudentLabel(int index) =>
      _pick(uz: 'O\'quvchi $index', ru: 'Ученик $index', en: 'Student $index');

  String dashboardAppBarGreeting(String userName) => _pick(
    uz: 'Salom, $userName',
    ru: 'Здравствуйте, $userName',
    en: 'Hello, $userName',
  );

  String dashboardHeroGreeting(String userName) => _pick(
    uz: '$userName uchun bugungi holat',
    ru: 'Сегодняшняя сводка для $userName',
    en: 'Today\'s overview for $userName',
  );

  String dashboardAttendanceRateLabel(num attendanceRate) => _pick(
    uz: 'Davomat: ${attendanceRate.toStringAsFixed(1)}%',
    ru: 'Посещаемость: ${attendanceRate.toStringAsFixed(1)}%',
    en: 'Attendance: ${attendanceRate.toStringAsFixed(1)}%',
  );

  String dashboardWeekdayShort(int index) {
    const uz = ['Du', 'Se', 'Ch', 'Pa', 'Ju', 'Sh', 'Ya'];
    const ru = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    const en = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    final safeIndex = index.clamp(0, 6);
    if (_isUz) return uz[safeIndex];
    if (_isRu) return ru[safeIndex];
    return en[safeIndex];
  }

  String dashboardAssessmentMaxScoreLabel(num? maxScore) =>
      '$assessmentMaxScoreLabel: ${maxScore ?? 0}';

  String dashboardPendingExcusesSubtitle(int count) => _pick(
    uz: '$count ta sababnoma ko\'rib chiqishni kutmoqda',
    ru: '$count объяснений ожидают рассмотрения',
    en: '$count excuses are waiting for review',
  );

  String dashboardOpenConferenceSlotsSubtitle(int count) => _pick(
    uz: '$count ta aktiv konferensiya sloti mavjud',
    ru: 'Доступно $count активных слотов конференций',
    en: '$count active conference slots are open',
  );

  String get viewAll => _pick(uz: 'Barchasi', ru: 'Все', en: 'View all');

  String get settingsTitle =>
      _pick(uz: 'Sozlamalar', ru: 'Настройки', en: 'Settings');

  String get scientificWorkTitle =>
      _pick(uz: 'Ilmiy ish', ru: 'Научная работа', en: 'Scientific work');

  String get assessmentClassificationTitle =>
      _pick(uz: 'Tasniflash', ru: 'Классификация', en: 'Classification');

  String get assessmentDetailsTitle =>
      _pick(uz: 'Tafsilotlar', ru: 'Детали', en: 'Details');

  String get attendanceAllPresent => _pick(
    uz: 'Barchasi qatnashdi',
    ru: 'Все присутствуют',
    en: 'Mark all present',
  );

  String get attendanceAllAbsent =>
      _pick(uz: 'Barchasi yo`q', ru: 'Все отсутствуют', en: 'Mark all absent');

  String get attendanceNoStudents => _pick(
    uz: 'Ro`yxatda o`quvchi yo`q',
    ru: 'В списке нет учеников',
    en: 'No students available',
  );

  String eventsTypeLabel(String eventType) {
    return switch (eventType.toLowerCase()) {
      'holiday' => eventTypeHoliday,
      'exam' => eventTypeExam,
      'meeting' => eventTypeMeeting,
      'sport' => eventTypeSport,
      _ => eventTypeOther,
    };
  }

  String homeworkDueDateText(dynamic dueDate) => _pick(
    uz: 'Muddat: ${_formatDate(dueDate)}',
    ru: 'Срок: ${_formatDate(dueDate)}',
    en: 'Due: ${_formatDate(dueDate)}',
  );

  String homeworkStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'graded':
        return _pick(uz: 'Baholangan', ru: 'Оценено', en: 'Graded');
      case 'submitted':
        return _pick(uz: 'Topshirilgan', ru: 'Сдано', en: 'Submitted');
      default:
        return _pick(uz: 'Kutilmoqda', ru: 'Ожидает', en: 'Pending');
    }
  }

  String homeworkGradeLabel(num grade) =>
      _pick(uz: 'Baho: $grade', ru: 'Оценка: $grade', en: 'Grade: $grade');

  String lessonCoinsSaved(num coin) => _pick(
    uz: '$coin coin saqlandi',
    ru: '$coin монет сохранено',
    en: '$coin coins saved',
  );

  String libraryLoanRecordsCount(int count) => _pick(
    uz: '$count ta ijaraga olingan kitob',
    ru: '$count книг в выдаче',
    en: '$count borrowed books',
  );

  String libraryAvailableBooksCount(int count) => _pick(
    uz: '$count ta kitob mavjud',
    ru: 'Доступно $count книг',
    en: '$count books available',
  );

  String libraryAuthorLabel(String author) => _pick(
    uz: 'Muallif: $author',
    ru: 'Автор: $author',
    en: 'Author: $author',
  );

  String libraryBorrowedDateLabel(String borrowedDate) => _pick(
    uz: 'Olingan sana: $borrowedDate',
    ru: 'Дата выдачи: $borrowedDate',
    en: 'Borrowed: $borrowedDate',
  );

  String libraryDueDateLabel(String dueDate) => _pick(
    uz: 'Qaytarish muddati: $dueDate',
    ru: 'Срок возврата: $dueDate',
    en: 'Due date: $dueDate',
  );

  String libraryReturnedDateLabel(String returnedDate) => _pick(
    uz: 'Qaytarilgan sana: $returnedDate',
    ru: 'Дата возврата: $returnedDate',
    en: 'Returned: $returnedDate',
  );

  String libraryCopiesLabel(int copies, [int? totalCopies]) {
    final value = totalCopies == null ? '$copies' : '$copies/$totalCopies';
    return _pick(
      uz: 'Nusxalar: $value',
      ru: 'Экземпляры: $value',
      en: 'Copies: $value',
    );
  }

  String libraryIsbnLabel(String isbn) => 'ISBN: $isbn';

  String mealsDateLabel(dynamic date) => _pick(
    uz: 'Sana: ${_formatDate(date)}',
    ru: 'Дата: ${_formatDate(date)}',
    en: 'Date: ${_formatDate(date)}',
  );

  String mealTypeLabel(String mealType) {
    switch (mealType.toLowerCase()) {
      case 'breakfast':
        return _pick(uz: 'Nonushta', ru: 'Завтрак', en: 'Breakfast');
      case 'lunch':
        return _pick(uz: 'Tushlik', ru: 'Обед', en: 'Lunch');
      case 'dinner':
        return _pick(uz: 'Kechki ovqat', ru: 'Ужин', en: 'Dinner');
      default:
        return _humanizeKey(mealType);
    }
  }

  String paymentPeriodLabel({
    required String? payType,
    required int? periodYear,
    required int? periodMonth,
    required String? paymentMethod,
  }) {
    final typeText = switch ((payType ?? '').toLowerCase()) {
      'monthly' => monthlyPaymentType,
      'yearly' => yearlyPaymentType,
      _ => payType ?? paymentTypeLabel,
    };

    final periodText = switch ((
      periodYear,
      periodMonth,
      (payType ?? '').toLowerCase(),
    )) {
      (final year?, final month?, 'monthly') => '$month/$year',
      (final year?, _, _) => '$year',
      _ => '-',
    };

    final methodText = paymentMethod?.trim();
    final methodSuffix = methodText == null || methodText.isEmpty
        ? ''
        : ' • ${_pick(uz: 'Usul', ru: 'Метод', en: 'Method')}: $methodText';

    return '$typeText • ${_pick(uz: 'Davr', ru: 'Период', en: 'Period')}: $periodText$methodSuffix';
  }

  String academicYearLabel(String academicYear) => _pick(
    uz: 'O\'quv yili: $academicYear',
    ru: 'Учебный год: $academicYear',
    en: 'Academic year: $academicYear',
  );

  String syncingActions(int count) => _pick(
    uz: '$count ta amal serverga yuborilmoqda',
    ru: '$count действий отправляется на сервер',
    en: '$count actions are being synced',
  );

  String syncSuccess(int count) => _pick(
    uz: '$count ta amal muvaffaqiyatli sinxronlandi',
    ru: '$count действий успешно синхронизировано',
    en: '$count actions synced successfully',
  );

  String offlineQueued(int count) => _pick(
    uz: '$count ta amal navbatga saqlandi',
    ru: '$count действий сохранено в очереди',
    en: '$count actions were queued offline',
  );

  String pendingQueue(int count) => _pick(
    uz: '$count ta amal sinxronlashni kutmoqda',
    ru: '$count действий ожидают синхронизации',
    en: '$count actions are waiting to sync',
  );

  String get syncErrorFallback => _pick(
    uz: 'Sinxronlashda xatolik yuz berdi',
    ru: 'Произошла ошибка синхронизации',
    en: 'Sync failed',
  );

  String get offlineSavedChanges => _pick(
    uz: 'O\'zgarishlar internet tiklangach yuboriladi',
    ru: 'Изменения будут отправлены после восстановления сети',
    en: 'Changes will sync when the connection returns',
  );
}

/// A static localization holder to bridger the gap for Notifiers and tests
/// where BuildContext is not available.
class AppLocalizationsRegistry {
  static AppLocalizations _instance = lookupAppLocalizations(
    const Locale('uz'),
  );

  static AppLocalizations get instance => _instance;

  static void update(dynamic instance) {
    if (instance is AppLocalizations) {
      _instance = instance;
    }
  }
}
