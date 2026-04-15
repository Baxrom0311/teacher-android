// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'Teacher Portal';

  @override
  String get changeLanguage => 'Сменить язык';

  @override
  String get changeTheme => 'Сменить тему';

  @override
  String get themeSystem => 'Как в системе';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeDark => 'Тёмная';

  @override
  String get notificationFallbackTitle => 'Новое уведомление';

  @override
  String get close => 'Закрыть';

  @override
  String get teacherPortal => 'Teacher Portal';

  @override
  String get teacherSubtitle =>
      'Войдите, чтобы управлять вашими классами и уроками';

  @override
  String get selectSchool => 'Выберите школу';

  @override
  String get selectSchoolSubtitle => 'Выберите школу, в которую хотите войти';

  @override
  String get noSchoolsFound => 'Школы не найдены';

  @override
  String get changeSchool => 'Сменить школу';

  @override
  String get usernameLabel => 'Номер телефона';

  @override
  String get phoneNumberLabel => 'Номер телефона';

  @override
  String get phoneNumberRequired => 'Введите номер телефона';

  @override
  String get usernameRequired => 'Введите номер телефона';

  @override
  String get usernameMinimum => 'Введите минимум 3 символа';

  @override
  String get passwordLabel => 'Пароль';

  @override
  String get passwordRequired => 'Введите пароль';

  @override
  String get passwordTooShort => 'Пароль должен содержать минимум 6 символов';

  @override
  String get signIn => 'Войти';

  @override
  String get home => 'Главная';

  @override
  String get lessons => 'Уроки';

  @override
  String get chat => 'Чат';

  @override
  String get profile => 'Профиль';

  @override
  String get reviewHomeworkTitle => 'Проверка задания';

  @override
  String get assessmentResultsTitle => 'Результаты экзамена';

  @override
  String get subjectLessonsTitle => 'Уроки по предмету';

  @override
  String get userFallbackName => 'Пользователь';

  @override
  String get noInternet => 'Нет подключения к интернету';

  @override
  String get errorGeneric =>
      'Произошла непредвиденная ошибка. Попробуйте снова.';

  @override
  String get errorServer => 'Ошибка сервера. Попробуйте позже.';

  @override
  String get errorAuth => 'Вы не авторизованы. Пожалуйста, войдите в аккаунт.';

  @override
  String get sessionExpired =>
      'Сессия завершилась. Войдите снова, чтобы продолжить.';

  @override
  String get requestTimeout =>
      'Время ожидания ответа сервера истекло. Повторите попытку.';

  @override
  String get requestCancelled => 'Запрос отменен';

  @override
  String get badRequest => 'Некорректный запрос';

  @override
  String get forbidden => 'Доступ запрещен';

  @override
  String get notFound => 'Данные не найдены';

  @override
  String get failedFetchProfile => 'Не удалось загрузить профиль пользователя.';

  @override
  String get failedLoadOptions => 'Не удалось загрузить необходимые варианты.';

  @override
  String get loadingTitle => 'Загрузка';

  @override
  String get errorTitle => 'Произошла ошибка';

  @override
  String get retry => 'Повторить';

  @override
  String get emptyTitle => 'Пока нет данных';

  @override
  String get todayLessonsTitle => 'Сегодняшние уроки';

  @override
  String get noLessonsTodayTitle => 'На сегодня уроков нет';

  @override
  String get noLessonsTodayMessage =>
      'На сегодня для вас не запланировано уроков.';

  @override
  String get lessonsLoadingTitle => 'Загрузка уроков';

  @override
  String get lessonsLoadingSubtitle => 'Подготавливается расписание на сегодня';

  @override
  String get lessonsLoadErrorTitle => 'Не удалось загрузить уроки';

  @override
  String get startLessonButton => 'Начать урок / войти';

  @override
  String get attendanceCreateTitle => 'Отметка посещаемости';

  @override
  String get attendanceCreateSavePendingMessage =>
      'Интеграция сохранения посещаемости готовится';

  @override
  String get attendanceOptionsLoadingTitle => 'Загрузка вариантов посещаемости';

  @override
  String get attendanceOptionsLoadingSubtitle =>
      'Подготавливаются статусы и список учеников';

  @override
  String get attendanceOptionsLoadErrorTitle =>
      'Не удалось загрузить варианты посещаемости';

  @override
  String get absenceReviewTitle => 'Оправдательные записки';

  @override
  String get absenceReviewEmptyMessage => 'Заявки не найдены';

  @override
  String get approveAction => 'Подтвердить';

  @override
  String get rejectAction => 'Отклонить';

  @override
  String get absenceReviewLoadingTitle => 'Загрузка оправдательных записок';

  @override
  String get absenceReviewLoadingSubtitle =>
      'Проверяются новые заявки по посещаемости';

  @override
  String get absenceReviewLoadErrorTitle =>
      'Не удалось загрузить оправдательные записки';

  @override
  String get absenceApprovedSuccess => 'Подтверждено';

  @override
  String get absenceRejectedSuccess => 'Отклонено';

  @override
  String get messagesTitle => 'Сообщения';

  @override
  String get contactsEmptyTitle => 'Контакты не найдены';

  @override
  String get contactsEmptyMessage => 'Переписок пока нет.';

  @override
  String get messagesLoadingTitle => 'Загрузка сообщений';

  @override
  String get messagesLoadingSubtitle => 'Подготавливается список чатов';

  @override
  String get messagesLoadErrorTitle => 'Не удалось загрузить сообщения';

  @override
  String get sendMessagePlaceholder => 'Написать сообщение';

  @override
  String get chatRoomEmptyMessage => 'Сообщений нет. Начните переписку первым.';

  @override
  String get chatSendingAttachmentPlaceholder => 'Файл отправляется...';

  @override
  String get profileSettingsTitle => 'Профиль и настройки';

  @override
  String get scientificWorkDeleted => 'Научная работа удалена';

  @override
  String get teacherFallbackName => 'Учитель';

  @override
  String get teacherEmailFallback => 'teacher@eschool.uz';

  @override
  String get infoSectionTitle => 'Информация';

  @override
  String get universityLabel => 'Университет';

  @override
  String get specializationLabel => 'Специализация';

  @override
  String get categoryLabel => 'Категория';

  @override
  String get graduationDateLabel => 'Дата окончания';

  @override
  String get addressLabel => 'Адрес';

  @override
  String get genderLabel => 'Пол';

  @override
  String get achievementsLabel => 'Достижения';

  @override
  String get documentsTitle => 'Документы';

  @override
  String get diplomaTitle => 'Диплом';

  @override
  String get passportCopyTitle => 'Копия паспорта';

  @override
  String get uploadedStatus => 'Загружено';

  @override
  String get notUploadedStatus => 'Не загружено';

  @override
  String get portfolioTitle => 'Научные работы (портфолио)';

  @override
  String get portfolioEmptyTitle => 'Портфолио пусто';

  @override
  String get portfolioEmptyMessage => 'Научные работы пока не добавлены.';

  @override
  String get pdfUploadedLabel => 'PDF загружен';

  @override
  String get notificationsCenterTitle => 'Уведомления';

  @override
  String get notificationsCenterSubtitle => 'Центр уведомлений учителя';

  @override
  String get notificationsLoadingTitle => 'Загрузка уведомлений';

  @override
  String get notificationsLoadingSubtitle => 'Проверяем новые сообщения';

  @override
  String get notificationsLoadErrorTitle => 'Не удалось загрузить уведомления';

  @override
  String get notificationsEmptyTitle => 'Уведомлений нет';

  @override
  String get notificationsEmptyMessage => 'Пока для вас нет новых уведомлений.';

  @override
  String get libraryMenuTitle => 'Библиотека';

  @override
  String get libraryMenuSubtitle => 'Получение и возврат книг';

  @override
  String get eventsMenuTitle => 'События';

  @override
  String get eventsMenuSubtitle => 'Список школьных мероприятий';

  @override
  String get logoutTitle => 'Выйти из системы';

  @override
  String get logoutConfirmMessage =>
      'Вы действительно хотите выйти из аккаунта?';

  @override
  String get cancel => 'Отмена';

  @override
  String get logoutAction => 'Выйти';

  @override
  String get profileLoadingTitle => 'Загрузка профиля';

  @override
  String get profileLoadingSubtitle => 'Подготавливаются данные учителя';

  @override
  String get profileLoadErrorTitle => 'Не удалось загрузить профиль';

  @override
  String get timetableTitle => 'Расписание уроков';

  @override
  String get noLessonsOnSelectedDate => 'На эту дату уроков нет';

  @override
  String get unknownSubjectFallback => 'Предмет не указан';

  @override
  String get roomFallback => 'Кабинет -';

  @override
  String get subjectsTitle => 'Мои предметы';

  @override
  String get noAssignedSubjects => 'За вами не закреплены предметы.';

  @override
  String get addTopicTooltip => 'Добавить новую тему';

  @override
  String get noTopicsYet => 'Тем пока нет';

  @override
  String get noTopicsForGroup => 'Для этой группы темы еще не добавлены.';

  @override
  String get filesTitle => 'Файлы';

  @override
  String get fileOpenFailed => 'Не удалось открыть файл';

  @override
  String get newTopicTitle => 'Новая тема';

  @override
  String get topicTitleLabel => 'Заголовок';

  @override
  String get topicTitleHint => 'Название темы';

  @override
  String get topicDescriptionLabel =>
      'Дополнительная информация (необязательно)';

  @override
  String get topicDescriptionHint => 'Комментарий...';

  @override
  String get attachedFilesTitle => 'Прикрепленные файлы';

  @override
  String get chooseFileAction => 'Выбрать файл';

  @override
  String get noFilesSelected => 'Файлы пока не выбраны.';

  @override
  String get addTopicAction => 'Добавить тему';

  @override
  String get topicTitleRequired => 'Введите заголовок темы';

  @override
  String get topicFilesRequired =>
      'Нужно загрузить хотя бы один PDF/DOC/изображение';

  @override
  String get topicSaved => 'Тема сохранена';

  @override
  String get paymentsTitle => 'Платежи (ученики)';

  @override
  String get allGroups => 'Все группы';

  @override
  String get searchStudentHint => 'Поиск ученика...';

  @override
  String get noStudentsFound => 'Ученики не найдены.';

  @override
  String get paidStatus => 'Оплатил';

  @override
  String get debtorStatus => 'Должник';

  @override
  String get studentPaymentsTitle => 'Платежи ученика';

  @override
  String get newPaymentTitle => 'Новый платеж';

  @override
  String get paymentTypeLabel => 'Тип платежа';

  @override
  String get monthlyPaymentType => 'Ежемесячный платеж';

  @override
  String get yearlyPaymentType => 'Годовой платеж';

  @override
  String get yearLabel => 'Год';

  @override
  String get monthLabel => 'Месяц';

  @override
  String get paymentMethodLabel => 'Способ оплаты';

  @override
  String get paymentMethodCash => 'Наличные';

  @override
  String get paymentMethodCard => 'Пластиковая карта';

  @override
  String get paymentMethodTransfer => 'Перевод с карты (P2P)';

  @override
  String get paymentMethodTerminal => 'Терминал';

  @override
  String get amountLabel => 'Сумма';

  @override
  String get amountCurrencyLabel => 'Сумма (сум)';

  @override
  String get noteOptional => 'Комментарий (необязательно)';

  @override
  String get confirmAction => 'Подтвердить';

  @override
  String get paymentAmountRequired => 'Введите сумму платежа';

  @override
  String get paymentAccepted => 'Платеж принят!';

  @override
  String get paymentHistoryTitle => 'История платежей';

  @override
  String get noPaymentsForStudent => 'У этого ученика пока нет платежей.';

  @override
  String get monthlyFeeLabel => 'Ежемесячный платеж';

  @override
  String get discountLabel => 'Скидка';

  @override
  String get currencySymbol => 'сум';

  @override
  String get saveAction => 'Сохранить';

  @override
  String get editAction => 'Редактировать';

  @override
  String get homeworkListTitle => 'Домашние задания';

  @override
  String get noAssignedHomeworks => 'Домашние задания пока не назначены.';

  @override
  String get homeworkGroupFallback => 'Группа';

  @override
  String get homeworkDescriptionFallback => 'Описание отсутствует';

  @override
  String get homeworkCreateTitle => 'Новое задание';

  @override
  String get homeworkTitleLabel => 'Заголовок';

  @override
  String get homeworkTitleHint => 'Например: упражнение 5';

  @override
  String get homeworkDescriptionTitle => 'Описание';

  @override
  String get homeworkDescriptionHint => 'Подробнее о задании...';

  @override
  String get homeworkDueDateTitle => 'Срок сдачи (необязательно)';

  @override
  String get homeworkSelectDueDate => 'Выберите срок';

  @override
  String get homeworkTitleRequired => 'Введите заголовок';

  @override
  String get homeworkCreatedSuccess => 'Задание создано!';

  @override
  String get homeworkCheckDialogTitle => 'Поставить оценку';

  @override
  String get homeworkCommentHint => 'Комментарий (необязательно)';

  @override
  String get homeworkNoSubmissions => 'Пока нет отправленных заданий.';

  @override
  String get homeworkGradedStatus => 'Оценено';

  @override
  String get homeworkSubmittedStatus => 'Отправлено';

  @override
  String get homeworkViewFileAction => 'Открыть файл';

  @override
  String get gradeAction => 'Поставить оценку';

  @override
  String get eventsEmptyTitle => 'Активных событий нет';

  @override
  String get eventsEmptyMessage =>
      'Пока активные школьные события не зарегистрированы.';

  @override
  String get eventsLoadingTitle => 'Загрузка событий';

  @override
  String get eventsLoadingSubtitle => 'Обновляется школьный календарь';

  @override
  String get eventsLoadErrorTitle => 'Не удалось загрузить события';

  @override
  String get eventFallbackTitle => 'Событие';

  @override
  String get eventDateUnavailable => 'Дата не указана';

  @override
  String get eventTypeHoliday => 'Праздник';

  @override
  String get eventTypeExam => 'Экзамен';

  @override
  String get eventTypeMeeting => 'Встреча';

  @override
  String get eventTypeSport => 'Спорт';

  @override
  String get eventTypeOther => 'Другое';

  @override
  String get librarySearchHint => 'Ищите по книге, автору или ISBN';

  @override
  String get libraryBorrowedSuccess => 'Книга успешно выдана';

  @override
  String get libraryReturnedSuccess => 'Книга возвращена';

  @override
  String get libraryMyBooksTitle => 'Мои книги';

  @override
  String get libraryCatalogTitle => 'Каталог';

  @override
  String get libraryNoLoansMessage => 'Вы еще не брали книги в библиотеке.';

  @override
  String get libraryNoBooksMessage => 'По вашему запросу книги не найдены.';

  @override
  String get libraryLoadingTitle => 'Загрузка библиотеки';

  @override
  String get libraryLoadingSubtitle => 'Получаем книги и записи о выдаче';

  @override
  String get libraryLoadErrorTitle => 'Не удалось загрузить библиотеку';

  @override
  String get libraryBookFallback => 'Книга';

  @override
  String get libraryBorrowedStatus => 'У вас';

  @override
  String get libraryReturnedStatus => 'Возвращено';

  @override
  String get libraryReturnAction => 'Вернуть';

  @override
  String get libraryBorrowAction => 'Взять';

  @override
  String get libraryUnavailableAction => 'Недоступно';

  @override
  String get assessmentRequiredFields => 'Заполните все обязательные поля';

  @override
  String get assessmentCreatedSuccess => 'Экзамен успешно создан!';

  @override
  String get assessmentCreateTitle => 'Новый экзамен';

  @override
  String get assessmentQuarterLabel => 'Четверть';

  @override
  String get assessmentGroupLabel => 'Группа';

  @override
  String get assessmentSubjectLabel => 'Предмет';

  @override
  String get assessmentTypeFieldLabel => 'Тип экзамена';

  @override
  String get assessmentOptionalTitleLabel => 'Заголовок (необязательно)';

  @override
  String get assessmentOptionalTitleHint =>
      'Например: контрольная за 1 четверть';

  @override
  String get assessmentMaxScoreLabel => 'Максимальный балл';

  @override
  String get assessmentWeightLabel => 'Вес (%)';

  @override
  String get assessmentDateLabel => 'Дата проведения';

  @override
  String get assessmentSelectDate => 'Выберите дату';

  @override
  String get assessmentResultsSaved => 'Результаты успешно сохранены';

  @override
  String get assessmentNoStudents => 'В этой группе не найдены ученики.';

  @override
  String get assessmentScoreLabel => 'Балл:';

  @override
  String get assessmentScoreHint => '0-100';

  @override
  String get assessmentCommentLabel => 'Комментарий:';

  @override
  String get assessmentCommentHintEmpty => 'Не указано';

  @override
  String get conferenceCreateTitle => 'Создать собрание';

  @override
  String get conferenceSelectDateLabel => 'Выберите дату:';

  @override
  String get conferenceLocationLabel => 'Место / кабинет:';

  @override
  String get conferenceLocationHint => 'Например: кабинет 204 или Zoom';

  @override
  String get conferenceSlotsLabel => 'Временные интервалы (слоты):';

  @override
  String get conferenceNoSlots => 'Слоты еще не добавлены';

  @override
  String get conferenceCreateSuccess => 'Успешно создано!';

  @override
  String get assessmentsListTitle => 'Экзамены и оценки';

  @override
  String get addAssessmentTooltip => 'Добавить новый экзамен';

  @override
  String get assessmentsListEmpty => 'Экзамены пока не добавлены.';

  @override
  String get assessmentFallbackTitle => 'Экзамен';

  @override
  String get assessmentUnknownGroup => 'Неизвестная группа';

  @override
  String get profileEditTitle => 'Редактирование профиля';

  @override
  String get profileUpdatedSuccess => 'Профиль обновлен';

  @override
  String get dateInputHint => 'YYYY-MM-DD';

  @override
  String get alreadyUploadedLabel => 'Уже загружено';

  @override
  String get selectAction => 'Выбрать';

  @override
  String get documentNotSelected => 'Документ не выбран';

  @override
  String get portfolioCreateTitle => 'Добавить научную работу';

  @override
  String get portfolioWorkFallbackTitle => 'Научная работа';

  @override
  String get portfolioWorkTitleLabel => 'Заголовок';

  @override
  String get portfolioWorkTitleHint => 'Название статьи или книги';

  @override
  String get portfolioPublishedPlaceLabel => 'Место публикации';

  @override
  String get portfolioPublishedPlaceHint => 'Журнал или издательство';

  @override
  String get portfolioPublishedDateLabel => 'Дата публикации';

  @override
  String get portfolioCoauthorSearchTitle => 'Поиск соавторов';

  @override
  String get portfolioCoauthorSearchHint =>
      'Ищите по серии или номеру паспорта';

  @override
  String get addAction => 'Добавить';

  @override
  String get pdfOnlyFileLabel => 'Файл (только PDF)';

  @override
  String get uploadAction => 'Загрузить';

  @override
  String get portfolioTitleRequired => 'Введите заголовок';

  @override
  String get portfolioWorkAdded => 'Научная работа добавлена';

  @override
  String get lessonSessionTitle => 'Оценки урока';

  @override
  String get addHomeworkTooltip => 'Добавить домашнее задание';

  @override
  String get lessonSessionLoadingTitle => 'Загрузка занятия';

  @override
  String get lessonSessionLoadingSubtitle => 'Получаем оценки и тему урока';

  @override
  String get lessonSessionLoadErrorTitle => 'Не удалось загрузить занятие';

  @override
  String get lessonSessionSavedSuccess => 'Урок успешно сохранен!';

  @override
  String get lessonSessionSaveErrorFallback =>
      'Произошла ошибка при сохранении';

  @override
  String get lessonSessionTopicLabel => 'Тема';

  @override
  String get lessonSessionTopicHint => 'Введите тему сегодняшнего урока...';

  @override
  String get lessonSessionStudentsTitle => 'Оценки учеников';

  @override
  String get presentStatusShort => 'Был';

  @override
  String get absentStatusShort => 'Не был';

  @override
  String get dashboardQuickActionsTitle => 'Быстрые действия';

  @override
  String get dashboardRecentAssessmentsTitle => 'Последние оценки';

  @override
  String get dashboardRecentAssessmentsEmptyTitle => 'Оценки не найдены';

  @override
  String get dashboardRecentAssessmentsEmptyMessage =>
      'Пока нет недавно оцененных экзаменов.';

  @override
  String get dashboardLoadingTitle => 'Загрузка дашборда';

  @override
  String get dashboardLoadingSubtitle => 'Получаем основную статистику';

  @override
  String get dashboardLoadErrorTitle => 'Не удалось загрузить дашборд';

  @override
  String get dashboardWeeklyInsightsTitle => 'Недельная аналитика';

  @override
  String get dashboardAttendanceChartTitle => 'Недельная посещаемость';

  @override
  String get dashboardPendingTasksTitle => 'Ожидающие задачи';

  @override
  String get dashboardGroupsLabel => 'Группы';

  @override
  String get dashboardSubjectsLabel => 'Предметы';

  @override
  String get dashboardStudentsLabel => 'Ученики';

  @override
  String get dashboardAbsentLabel => 'Отсутствующие';

  @override
  String get dashboardAttendanceAction => 'Посещаемость';

  @override
  String get dashboardExcusesAction => 'Оправдательные';

  @override
  String get dashboardConferencesAction => 'Встречи';

  @override
  String get dashboardHomeworkAction => 'Домашнее задание';

  @override
  String get dashboardAssessmentsAction => 'Экзамены';

  @override
  String get dashboardSubjectsAction => 'Предметы';

  @override
  String get dashboardLessonsLabel => 'Уроки';

  @override
  String get dashboardOpenSessionsLabel => 'Открытые сессии';

  @override
  String get dashboardClosedSessionsLabel => 'Закрытые';

  @override
  String get dashboardTodayDateUnavailable => 'Сегодняшняя дата недоступна';

  @override
  String get dashboardYearFallbackBadge => 'Учебный год';

  @override
  String get dashboardQuarterFallbackBadge => 'Четверть не указана';

  @override
  String get gradesListTitle => 'Оценки учеников';

  @override
  String get gradesQuarterTab => 'Четвертные';

  @override
  String get gradesYearTab => 'Годовые';

  @override
  String get gradesEmptyMessage => 'Оценки не найдены.';

  @override
  String get gradesLoadingTitle => 'Загрузка оценок';

  @override
  String get gradesLoadingSubtitle => 'Подготавливаются результаты учеников';

  @override
  String get gradesLoadErrorTitle => 'Не удалось загрузить оценки';

  @override
  String get gradesSearchHint => 'Имя, телефон, email...';

  @override
  String get unknownStudentFallback => 'Неизвестный ученик';

  @override
  String get unknownGroupFallback => 'Группа не указана';

  @override
  String get mealsReportTitle => 'Отчет по питанию';

  @override
  String get mealsNoGroupsMessage => 'Группы не найдены.';

  @override
  String get mealsNameLabel => 'Название блюда';

  @override
  String get mealsNameHint => 'Например: Macaroni with cheese';

  @override
  String get mealsRecipeLabel => 'Состав / рецепт';

  @override
  String get mealsRecipeHint => 'Состав: мука, вода, сыр...';

  @override
  String get mealsImagesLabel => 'Изображения (для подтверждения)';

  @override
  String get mealsAddImageAction => 'Добавить фото';

  @override
  String get mealsSystemImagesTitle => 'Изображения в системе';

  @override
  String get mealsSaveAction => 'Сохранить отчет';

  @override
  String get mealsGroupLabel => 'Группа';

  @override
  String get mealsTimeLabel => 'Время';

  @override
  String get mealsLoadingTitle => 'Загрузка отчетов по питанию';

  @override
  String get mealsLoadingSubtitle => 'Получаем группы и данные за сегодня';

  @override
  String get mealsLoadErrorTitle => 'Не удалось загрузить отчет по питанию';

  @override
  String get mealsNameRequired => 'Введите название блюда!';

  @override
  String get mealsSavedSuccess => 'Отчет сохранен!';

  @override
  String get langUz => 'Узбекский';

  @override
  String get langRu => 'Русский';

  @override
  String get langEn => 'Английский';

  @override
  String get paymentSuccessTitle => 'Оплата успешна!';

  @override
  String get paymentSuccessMessage =>
      'Платеж полностью принят и отражен в системе.';

  @override
  String get backToHome => 'Вернуться на главную';

  @override
  String get classJournalTitle => 'Классный журнал';

  @override
  String get classJournalSelectDate => 'Выберите дату';

  @override
  String get classJournalEmpty => 'Нет данных журнала на эту дату';

  @override
  String get classJournalLoadFailed => 'Не удалось загрузить журнал';

  @override
  String classJournalStudentCount(int count) => '$count учеников';

  @override
  String get classStoryTitle => 'Новости класса';

  @override
  String get classStoryEmpty => 'Пока нет новостей';

  @override
  String get classStoryLoadFailed => 'Не удалось загрузить новости';

  @override
  String get classStoryCommentHint => 'Напишите комментарий...';

  @override
  String get classStoryDelete => 'Удалить';

  @override
  String get classStoryCreateTitle => 'Создать новость';

  @override
  String get classStoryPublish => 'Опубликовать';

  @override
  String get classStoryTitleHint => 'Заголовок (необязательно)';

  @override
  String get classStoryBodyHint => 'Текст новости...';

  @override
  String get classStoryPinLabel => 'Закрепить сверху';

  @override
  String get classStoryCreateFailed => 'Не удалось создать новость';

  @override
  String get quizTitle => 'Тесты';
  @override
  String get quizEmpty => 'Пока нет тестов';
  @override
  String get quizLoadFailed => 'Не удалось загрузить тесты';
  @override
  String get quizAttempts => 'попыток';
  @override
  String get quizPoints => 'баллов';
  @override
  String get quizCreateTitle => 'Создать тест';
  @override
  String get quizSave => 'Сохранить';
  @override
  String get quizTitleHint => 'Название теста';
  @override
  String get quizDescHint => 'Описание (необязательно)';
  @override
  String get quizTimeLimitHint => 'Ограничение по времени';
  @override
  String get quizQuestions => 'Вопросы';
  @override
  String get quizQuestionN => 'Вопрос';
  @override
  String get quizQuestionHint => 'Введите текст вопроса';
  @override
  String get quizOptionHint => 'Вариант';
  @override
  String get quizAddQuestion => 'Добавить вопрос';
  @override
  String get quizResultsTitle => 'Результаты теста';
  @override
  String get quizAvgScore => 'Ср. балл';
  @override
  String get quizAvgPercent => 'Ср. %';
  @override
  String get quizStudentResults => 'Результаты учеников';
  @override
  String get galleryTitle => 'Фотогалерея';
  @override
  String get galleryEmpty => 'Альбомов пока нет';
  @override
  String get galleryLoadFailed => 'Не удалось загрузить галерею';
  @override
  String get galleryPhotos => 'фото';
  @override
  String get galleryNoPhotos => 'В этом альбоме нет фотографий';
  @override
  String get galleryCreateAlbum => 'Создать альбом';
  @override
  String get galleryAlbumTitleHint => 'Название альбома';
  @override
  String get galleryAlbumDescHint => 'Описание (необязательно)';
  @override
  String get galleryCreate => 'Создать';
  @override
  String get galleryCreateFailed => 'Не удалось создать альбом';
  @override
  String get galleryDeleteAlbum => 'Удалить альбом';
  @override
  String get galleryDelete => 'Удалить';
  @override
  String get galleryUploadFailed => 'Не удалось загрузить фотографии';
  @override
  String get behaviorTitle => 'Поведение';
  @override
  String get behaviorLoadFailed => 'Не удалось загрузить данные';
  @override
  String get behaviorEmpty => 'Записей нет';
  @override
  String get behaviorAll => 'Все';
  @override
  String get behaviorPositive => 'Положительные';
  @override
  String get behaviorNegative => 'Отрицательные';
  @override
  String get behaviorCreateTitle => 'Новая запись';
  @override
  String get behaviorSave => 'Сохранить';
  @override
  String get behaviorType => 'Тип';
  @override
  String get behaviorStudentId => 'ID ученика';
  @override
  String get behaviorCategory => 'Категория';
  @override
  String get behaviorDescription => 'Описание';
  @override
  String get behaviorPoints => 'Баллы (0-100)';
  @override
  String get behaviorDate => 'Дата';
  @override
  String get behaviorCreateFailed => 'Не удалось создать запись';
}
