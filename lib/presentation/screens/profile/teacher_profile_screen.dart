import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import 'package:teacher_school_app/l10n/app_localizations.dart';
import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import '../../../core/network/api_error_handler.dart';
import '../../../data/models/profile_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/app_feedback.dart';
import '../../providers/app_locale_provider.dart';
import '../../providers/app_theme_mode_provider.dart';
import '../../../core/localization/app_locale.dart';

class TeacherProfileScreen extends ConsumerStatefulWidget {
  const TeacherProfileScreen({super.key});

  @override
  ConsumerState<TeacherProfileScreen> createState() =>
      _TeacherProfileScreenState();
}

class _TeacherProfileScreenState extends ConsumerState<TeacherProfileScreen> {
  Future<void> _refresh() async {
    ref.invalidate(profileProvider);
    await ref.read(profileProvider.future);
  }

  Future<void> _deleteWork(ScientificWorkData work) async {
    final l10n = context.l10n;
    final success = await ref
        .read(profileControllerProvider.notifier)
        .deleteWork(work.id);
    if (!mounted) return;

    if (success) {
      ref.invalidate(profileProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.scientificWorkDeleted),
          backgroundColor: TeacherAppColors.success,
        ),
      );
    } else {
      final error = ref.read(profileControllerProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ApiErrorHandler.readableMessage(error)),
          backgroundColor: TeacherAppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.profileSettingsTitle),
        backgroundColor:
            theme.appBarTheme.backgroundColor ?? colorScheme.surface,
        foregroundColor:
            theme.appBarTheme.foregroundColor ?? colorScheme.onSurface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              profileAsync.whenData((profile) {
                if (profile.canEdit) {
                  context.push('/profile/edit', extra: profile);
                }
              });
            },
          ),
        ],
      ),
      body: profileAsync.when(
        data: (profile) {
          final teacher = profile.teacher;
          final pData = profile.profile;
          final displayTeacherName = teacher.name.isNotEmpty
              ? teacher.name
              : l10n.teacherFallbackName;
          final teacherInitial = displayTeacherName
              .substring(0, 1)
              .toUpperCase();

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 32),
              children: [
                const SizedBox(height: 24),
                Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: colorScheme.primary.withValues(
                      alpha: 0.12,
                    ),
                    backgroundImage: pData?.photoUrl != null
                        ? NetworkImage(pData!.photoUrl!)
                        : null,
                    child: pData?.photoUrl == null
                        ? Text(
                            teacherInitial,
                            style: TextStyle(
                              fontSize: 48,
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  displayTeacherName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  teacher.email.isNotEmpty
                      ? teacher.email
                      : l10n.teacherEmailFallback,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                if (teacher.phone != null || teacher.passportNo != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    [
                      if (teacher.phone != null) teacher.phone,
                      if (teacher.passportNo != null) teacher.passportNo,
                    ].whereType<String>().join('  •  '),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
                const SizedBox(height: 32),
                if (pData != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.infoSectionTitle,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (pData.university != null)
                          _buildInfoRow(
                            Icons.school_outlined,
                            l10n.universityLabel,
                            pData.university!,
                          ),
                        if (pData.specialization != null)
                          _buildInfoRow(
                            Icons.work_outline,
                            l10n.specializationLabel,
                            pData.specialization!,
                          ),
                        if (pData.category != null)
                          _buildInfoRow(
                            Icons.workspace_premium_outlined,
                            l10n.categoryLabel,
                            pData.category!,
                          ),
                        if (pData.graduationDate != null)
                          _buildInfoRow(
                            Icons.calendar_today_outlined,
                            l10n.graduationDateLabel,
                            _formatDate(
                              pData.graduationDate!,
                              l10n.intlLocaleTag,
                            ),
                          ),
                        if (pData.address != null)
                          _buildInfoRow(
                            Icons.location_on_outlined,
                            l10n.addressLabel,
                            pData.address!,
                          ),
                        if (pData.gender != null)
                          _buildInfoRow(
                            Icons.badge_outlined,
                            l10n.genderLabel,
                            l10n.genderLabelText(pData.gender!),
                          ),
                        if (pData.achievements != null)
                          _buildInfoRow(
                            Icons.emoji_events_outlined,
                            l10n.achievementsLabel,
                            pData.achievements!,
                          ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.documentsTitle,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildDocumentRow(
                          context: context,
                          icon: Icons.workspace_premium_outlined,
                          title: l10n.diplomaTitle,
                          isUploaded: pData.diplomaUrl != null,
                        ),
                        _buildDocumentRow(
                          context: context,
                          icon: Icons.contact_page_outlined,
                          title: l10n.passportCopyTitle,
                          isUploaded: pData.passportUrl != null,
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.portfolioTitle,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                          if (profile.canEdit)
                            IconButton(
                              icon: Icon(
                                Icons.add_circle,
                                color: colorScheme.primary,
                              ),
                              onPressed: () =>
                                  context.push('/profile/works/create'),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (profile.works.isEmpty)
                        SizedBox(
                          height: 180,
                          child: AppEmptyView(
                            title: l10n.portfolioEmptyTitle,
                            message: l10n.portfolioEmptyMessage,
                            icon: Icons.description_outlined,
                          ),
                        )
                      else
                        ...profile.works.map(
                          (work) => Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: colorScheme.outline.withValues(
                                  alpha: 0.7,
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.description_outlined,
                                      color: colorScheme.primary,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            work.title.isNotEmpty
                                                ? work.title
                                                : l10n.portfolioWorkFallbackTitle,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: colorScheme.onSurface,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            [
                                              if (work.publishedPlace != null)
                                                work.publishedPlace,
                                              if (work.publishedAt != null)
                                                _formatDate(
                                                  work.publishedAt!,
                                                  l10n.intlLocaleTag,
                                                ),
                                            ].whereType<String>().join(' • '),
                                            style: TextStyle(
                                              color:
                                                  colorScheme.onSurfaceVariant,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (profile.canEdit &&
                                        work.createdBy == teacher.id)
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          color: TeacherAppColors.error,
                                        ),
                                        onPressed: () => _deleteWork(work),
                                      ),
                                  ],
                                ),
                                if (work.fileUrl != null) ...[
                                  const SizedBox(height: 12),
                                  _buildWorkMetaChip(
                                    icon: Icons.picture_as_pdf_outlined,
                                    label: l10n.pdfUploadedLabel,
                                  ),
                                ],
                                if (work.authors.isNotEmpty) ...[
                                  const SizedBox(height: 12),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: work.authors
                                        .map(
                                          (author) => _buildWorkMetaChip(
                                            icon: Icons.person_outline,
                                            label: author.name.isNotEmpty
                                                ? author.name
                                                : l10n.teacherFallbackName,
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(),
                _buildSettingsItem(
                  context,
                  icon: Icons.notifications_active_outlined,
                  title: l10n.notificationsCenterTitle,
                  subtitle: l10n.notificationsCenterSubtitle,
                  onTap: () => context.push('/notifications'),
                ),
                _buildSettingsItem(
                  context,
                  icon: Icons.menu_book_outlined,
                  title: l10n.libraryMenuTitle,
                  subtitle: l10n.libraryMenuSubtitle,
                  onTap: () => context.push('/library'),
                ),
                _buildSettingsItem(
                  context,
                  icon: Icons.event_note_outlined,
                  title: l10n.eventsMenuTitle,
                  subtitle: l10n.eventsMenuSubtitle,
                  onTap: () => context.push('/events'),
                ),
                _buildSettingsItem(
                  context,
                  icon: Icons.language_rounded,
                  title: l10n.changeLanguage,
                  subtitle: ref.watch(appLocaleProvider).code.toUpperCase(),
                  onTap: () => _showLanguagePicker(context, ref),
                ),
                _buildSettingsItem(
                  context,
                  icon: theme.brightness == Brightness.dark
                      ? Icons.dark_mode_rounded
                      : Icons.light_mode_rounded,
                  title: l10n.changeTheme,
                  subtitle: _getThemeName(
                    context,
                    ref.watch(appThemeModeProvider),
                  ),
                  onTap: () => _showThemePicker(context, ref),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: TeacherAppColors.error.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.logout,
                      color: TeacherAppColors.error,
                    ),
                  ),
                  title: Text(
                    l10n.logoutTitle,
                    style: const TextStyle(
                      color: TeacherAppColors.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () => _showLogoutDialog(context),
                ),
              ],
            ),
          );
        },
        loading: () => AppLoadingView(
          title: l10n.profileLoadingTitle,
          subtitle: l10n.profileLoadingSubtitle,
        ),
        error: (error, stack) => AppErrorView(
          title: l10n.profileLoadErrorTitle,
          message: ApiErrorHandler.readableMessage(error),
          icon: Icons.person_off_outlined,
          onRetry: _refresh,
        ),
      ),
    );
  }

  String _formatDate(String rawDate, String localeTag) {
    try {
      return DateFormat(
        'dd.MM.yyyy',
        localeTag,
      ).format(DateTime.parse(rawDate));
    } catch (_) {
      return rawDate;
    }
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(fontSize: 16, color: colorScheme.onSurface),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentRow({
    required BuildContext context,
    required IconData icon,
    required String title,
    required bool isUploaded,
  }) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: colorScheme.primary),
      title: Text(title),
      subtitle: Text(
        isUploaded ? l10n.uploadedStatus : l10n.notUploadedStatus,
        style: TextStyle(
          color: isUploaded
              ? TeacherAppColors.success
              : colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: Icon(
        isUploaded ? Icons.check_circle_outline : Icons.info_outline,
        color: isUploaded
            ? TeacherAppColors.success
            : colorScheme.onSurfaceVariant,
      ),
    );
  }

  Widget _buildWorkMetaChip({required IconData icon, required String label}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colorScheme.primary.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: colorScheme.primary),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: colorScheme.onSurfaceVariant),
      ),
      trailing: Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.logoutTitle),
        content: Text(l10n.logoutConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(authControllerProvider.notifier).logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TeacherAppColors.error,
            ),
            child: Text(
              l10n.logoutAction,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  String _getThemeName(BuildContext context, ThemeMode mode) {
    final l10n = context.l10n;
    switch (mode) {
      case ThemeMode.system:
        return l10n.themeSystem;
      case ThemeMode.light:
        return l10n.themeLight;
      case ThemeMode.dark:
        return l10n.themeDark;
    }
  }

  void _showLanguagePicker(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  l10n.changeLanguage,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                title: Text(l10n.langUz),
                trailing: ref.read(appLocaleProvider) == AppLocale.uz
                    ? Icon(Icons.check, color: colorScheme.primary)
                    : null,
                onTap: () {
                  ref.read(appLocaleProvider.notifier).setLocale(AppLocale.uz);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(l10n.langRu),
                trailing: ref.read(appLocaleProvider) == AppLocale.ru
                    ? Icon(Icons.check, color: colorScheme.primary)
                    : null,
                onTap: () {
                  ref.read(appLocaleProvider.notifier).setLocale(AppLocale.ru);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(l10n.langEn),
                trailing: ref.read(appLocaleProvider) == AppLocale.en
                    ? Icon(Icons.check, color: colorScheme.primary)
                    : null,
                onTap: () {
                  ref.read(appLocaleProvider.notifier).setLocale(AppLocale.en);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showThemePicker(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  l10n.changeTheme,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.brightness_auto_rounded),
                title: Text(l10n.themeSystem),
                trailing: ref.read(appThemeModeProvider) == ThemeMode.system
                    ? Icon(Icons.check, color: colorScheme.primary)
                    : null,
                onTap: () {
                  ref
                      .read(appThemeModeProvider.notifier)
                      .setThemeMode(ThemeMode.system);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.light_mode_rounded),
                title: Text(l10n.themeLight),
                trailing: ref.read(appThemeModeProvider) == ThemeMode.light
                    ? Icon(Icons.check, color: colorScheme.primary)
                    : null,
                onTap: () {
                  ref
                      .read(appThemeModeProvider.notifier)
                      .setThemeMode(ThemeMode.light);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.dark_mode_rounded),
                title: Text(l10n.themeDark),
                trailing: ref.read(appThemeModeProvider) == ThemeMode.dark
                    ? Icon(Icons.check, color: colorScheme.primary)
                    : null,
                onTap: () {
                  ref
                      .read(appThemeModeProvider.notifier)
                      .setThemeMode(ThemeMode.dark);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
