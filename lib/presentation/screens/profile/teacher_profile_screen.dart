import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import '../../../core/network/api_error_handler.dart';
import '../../../data/models/profile_model.dart';
import '../../../data/models/teacher_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/app_feedback.dart';
import '../../providers/app_locale_provider.dart';
import '../../providers/app_theme_mode_provider.dart';
import '../../../core/localization/app_locale.dart';
import '../../widgets/common/page_background.dart';
import '../../widgets/common/premium_card.dart';
import '../../widgets/common/animated_pressable.dart';

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
      body: PageBackground(
        child: profileAsync.when(
          data: (profile) {
            final teacher = profile.teacher;
            final pData = profile.profile;
            final displayTeacherName = teacher.name.isNotEmpty
                ? teacher.name
                : l10n.teacherFallbackName;

            return RefreshIndicator(
              onRefresh: _refresh,
              displacement: 100,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  // ─── Premium Profile Header ───
                  SliverToBoxAdapter(
                    child: _ProfileHeader(
                      displayTeacherName: displayTeacherName,
                      teacher: teacher,
                      pData: pData,
                      canEdit: profile.canEdit,
                    ),
                  ),

                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // ─── Personal Info Section ───
                        if (pData != null) ...[
                          _SectionHeader(title: l10n.infoSectionTitle),
                          const SizedBox(height: 12),
                          PremiumCard(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              children: [
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
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // ─── Documents Section ───
                          _SectionHeader(title: l10n.documentsTitle),
                          const SizedBox(height: 12),
                          PremiumCard(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Column(
                              children: [
                                _buildDocumentRow(
                                  context: context,
                                  icon: Icons.workspace_premium_rounded,
                                  title: l10n.diplomaTitle,
                                  isUploaded: pData.diplomaUrl != null,
                                ),
                                _buildDocumentRow(
                                  context: context,
                                  icon: Icons.contact_page_rounded,
                                  title: l10n.passportCopyTitle,
                                  isUploaded: pData.passportUrl != null,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],

                        // ─── Portfolio Section ───
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _SectionHeader(title: l10n.portfolioTitle),
                            if (profile.canEdit)
                              AnimatedPressable(
                                onTap: () =>
                                    context.push('/profile/works/create'),
                                child: Text(
                                  l10n.addAction,
                                  style: TextStyle(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (profile.works.isEmpty)
                          AppEmptyView(
                            title: l10n.portfolioEmptyTitle,
                            message: l10n.portfolioEmptyMessage,
                            icon: Icons.description_outlined,
                          )
                        else
                          ...profile.works.map(
                            (work) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _PortfolioWorkCard(
                                work: work,
                                teacherId: teacher.id,
                                canEdit: profile.canEdit,
                                onDelete: () => _deleteWork(work),
                              ),
                            ),
                          ),
                        const SizedBox(height: 24),

                        // ─── Settings Section ───
                        _SectionHeader(title: l10n.settingsTitle),
                        const SizedBox(height: 12),
                        PremiumCard(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Column(
                            children: [
                              _buildSettingsItem(
                                context,
                                icon: Icons.notifications_none_rounded,
                                title: l10n.notificationsCenterTitle,
                                subtitle: l10n.notificationsCenterSubtitle,
                                onTap: () => context.push('/notifications'),
                              ),
                              _buildSettingsItem(
                                context,
                                icon: Icons.translate_rounded,
                                title: l10n.changeLanguage,
                                subtitle: ref
                                    .watch(appLocaleProvider)
                                    .code
                                    .toUpperCase(),
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
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        // ─── Logout Button ───
                        AnimatedPressable(
                          onTap: () => _showLogoutDialog(context),
                          child: PremiumCard(
                            color: TeacherAppColors.error.withValues(
                              alpha: 0.05,
                            ),
                            border: Border.all(
                              color: TeacherAppColors.error.withValues(
                                alpha: 0.2,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.logout_rounded,
                                  color: TeacherAppColors.error,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  l10n.logoutTitle,
                                  style: const TextStyle(
                                    color: TeacherAppColors.error,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => AppErrorView(
            title: l10n.profileLoadErrorTitle,
            message: ApiErrorHandler.readableMessage(error),
            icon: Icons.person_off_outlined,
            onRetry: _refresh,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.1),
              ),
            ),
            child: Icon(icon, size: 20, color: colorScheme.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Icon(icon, color: colorScheme.primary.withValues(alpha: 0.7)),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
      subtitle: Text(
        isUploaded ? l10n.uploadedStatus : l10n.notUploadedStatus,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: isUploaded
              ? TeacherAppColors.success
              : colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
        ),
      ),
      trailing: Icon(
        isUploaded ? Icons.check_circle_rounded : Icons.info_outline_rounded,
        size: 20,
        color: isUploaded
            ? TeacherAppColors.success
            : colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
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
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: colorScheme.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: colorScheme.primary.withValues(alpha: 0.1)),
        ),
        child: Icon(icon, size: 22, color: colorScheme.primary),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 16,
          color: colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface.withValues(alpha: 0.4),
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: colorScheme.onSurface.withValues(alpha: 0.2),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: TeacherAppColors.slate800,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        title: Text(
          l10n.logoutTitle,
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        content: Text(
          l10n.logoutConfirmMessage,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l10n.cancel,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(authControllerProvider.notifier).logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TeacherAppColors.error,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              l10n.logoutAction,
              style: const TextStyle(fontWeight: FontWeight.w900),
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
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: TeacherAppColors.slate400.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                l10n.changeLanguage,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            _LanguageTile(
              label: l10n.langUz,
              code: 'uz',
              isSelected: ref.read(appLocaleProvider) == AppLocale.uz,
              onTap: () {
                ref.read(appLocaleProvider.notifier).setLocale(AppLocale.uz);
                Navigator.pop(context);
              },
            ),
            _LanguageTile(
              label: l10n.langRu,
              code: 'ru',
              isSelected: ref.read(appLocaleProvider) == AppLocale.ru,
              onTap: () {
                ref.read(appLocaleProvider.notifier).setLocale(AppLocale.ru);
                Navigator.pop(context);
              },
            ),
            _LanguageTile(
              label: l10n.langEn,
              code: 'en',
              isSelected: ref.read(appLocaleProvider) == AppLocale.en,
              onTap: () {
                ref.read(appLocaleProvider.notifier).setLocale(AppLocale.en);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showThemePicker(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: TeacherAppColors.slate400.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                l10n.changeTheme,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            _ThemeTile(
              label: l10n.themeSystem,
              icon: Icons.brightness_auto_rounded,
              isSelected: ref.read(appThemeModeProvider) == ThemeMode.system,
              onTap: () {
                ref
                    .read(appThemeModeProvider.notifier)
                    .setThemeMode(ThemeMode.system);
                Navigator.pop(context);
              },
            ),
            _ThemeTile(
              label: l10n.themeLight,
              icon: Icons.light_mode_rounded,
              isSelected: ref.read(appThemeModeProvider) == ThemeMode.light,
              onTap: () {
                ref
                    .read(appThemeModeProvider.notifier)
                    .setThemeMode(ThemeMode.light);
                Navigator.pop(context);
              },
            ),
            _ThemeTile(
              label: l10n.themeDark,
              icon: Icons.dark_mode_rounded,
              isSelected: ref.read(appThemeModeProvider) == ThemeMode.dark,
              onTap: () {
                ref
                    .read(appThemeModeProvider.notifier)
                    .setThemeMode(ThemeMode.dark);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final String displayTeacherName;
  final TeacherModel teacher;
  final TeacherProfileData? pData;
  final bool canEdit;

  const _ProfileHeader({
    required this.displayTeacherName,
    required this.teacher,
    this.pData,
    required this.canEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24, topPadding + 16, 24, 40),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(48)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AnimatedPressable(
                onTap: () => context.pop(),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
              if (canEdit)
                AnimatedPressable(
                  onTap: () => context.push('/profile/edit', extra: teacher),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          _AvatarCircle(pData: pData, displayTeacherName: displayTeacherName),
          const SizedBox(height: 20),
          Text(
            displayTeacherName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            teacher.email.isNotEmpty ? teacher.email : 'teacher@school.edu',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (teacher.phone != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text(
                teacher.phone!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AvatarCircle extends StatelessWidget {
  final TeacherProfileData? pData;
  final String displayTeacherName;

  const _AvatarCircle({this.pData, required this.displayTeacherName});

  @override
  Widget build(BuildContext context) {
    final initials = displayTeacherName.isNotEmpty
        ? displayTeacherName[0].toUpperCase()
        : 'T';
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 4,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(55),
        child: pData?.photoUrl != null
            ? Image.network(pData!.photoUrl!, fit: BoxFit.cover)
            : Container(
                color: Colors.white.withValues(alpha: 0.2),
                child: Center(
                  child: Text(
                    initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w900,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _PortfolioWorkCard extends StatelessWidget {
  final ScientificWorkData work;
  final int teacherId;
  final bool canEdit;
  final VoidCallback onDelete;

  const _PortfolioWorkCard({
    required this.work,
    required this.teacherId,
    required this.canEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                  ),
                ),
                child: Icon(
                  Icons.description_rounded,
                  color: colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      work.title.isNotEmpty
                          ? work.title
                          : context.l10n.scientificWorkTitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      work.publishedPlace ?? '',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ),
              ),
              if (canEdit && work.createdBy == teacherId)
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: TeacherAppColors.late,
                    size: 20,
                  ),
                ),
            ],
          ),
          if (work.authors.isNotEmpty) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: work.authors
                  .map((author) => _AuthorChip(name: author.name))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _AuthorChip extends StatelessWidget {
  final String name;
  const _AuthorChip({required this.name});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        name,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final String label;
  final String code;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.label,
    required this.code,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      onTap: onTap,
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          code.toUpperCase(),
          style: TextStyle(
            color: colorScheme.primary,
            fontSize: 12,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle_rounded, color: colorScheme.primary)
          : null,
    );
  }
}

class _ThemeTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeTile({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      onTap: onTap,
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
      leading: Icon(
        icon,
        color: isSelected
            ? colorScheme.primary
            : colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle_rounded, color: colorScheme.primary)
          : null,
    );
  }
}
