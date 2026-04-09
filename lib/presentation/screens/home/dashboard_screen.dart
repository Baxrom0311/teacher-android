import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_routes.dart';
import 'package:teacher_school_app/l10n/app_localizations.dart';
import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import '../../../core/network/api_error_handler.dart';
import '../../../data/models/dashboard_model.dart';
import '../../providers/app_theme_mode_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../widgets/app_feedback.dart';
import '../../widgets/animations/staggered_fade_in.dart';
import '../../widgets/sync_status_banner.dart';
import '../../widgets/shared/stat_card.dart';
import '../../widgets/shared/action_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  Future<void> _refresh(WidgetRef ref) async {
    ref.invalidate(dashboardProvider);
    await ref.read(dashboardProvider.future);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final user = ref.watch(authControllerProvider).user;
    final userName = user?.name ?? l10n.teacherFallbackName;
    final dashboardAsync = ref.watch(dashboardProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentThemeMode = ref.watch(appThemeModeProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          l10n.dashboardAppBarGreeting(userName),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor:
            theme.appBarTheme.backgroundColor ?? colorScheme.surface,
        foregroundColor:
            theme.appBarTheme.foregroundColor ?? colorScheme.onSurface,
        elevation: 0,
        actions: [
          PopupMenuButton<ThemeMode>(
            tooltip: l10n.changeTheme,
            initialValue: currentThemeMode,
            onSelected: (themeMode) {
              ref.read(appThemeModeProvider.notifier).setThemeMode(themeMode);
            },
            itemBuilder: (context) => ThemeMode.values
                .map(
                  (themeMode) => PopupMenuItem<ThemeMode>(
                    value: themeMode,
                    child: Row(
                      children: [
                        Icon(_themeModeIcon(themeMode), size: 18),
                        const SizedBox(width: 10),
                        Text(_themeModeLabel(themeMode, l10n)),
                      ],
                    ),
                  ),
                )
                .toList(),
            icon: Icon(
              _themeModeIcon(currentThemeMode),
              color: colorScheme.onSurface,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () => context.push(TeacherRoutes.notifications),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(dashboardProvider),
          ),
        ],
      ),
      body: dashboardAsync.when(
        data: (dashboard) => SafeArea(
          child: RefreshIndicator(
            onRefresh: () => _refresh(ref),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                const SyncStatusBanner(),
                const SizedBox(height: 8),
                _DashboardHero(userName: userName, dashboard: dashboard),
                const SizedBox(height: 20),
                _PendingTasks(dashboard),
                const SizedBox(height: 20),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.45,
                  children: [
                    StaggeredFadeIn(
                      index: 0,
                      child: TeacherStatCard(
                        icon: Icons.groups_2_outlined,
                        label: l10n.dashboardGroupsLabel,
                        value: dashboard.overview.groupsCount.toString(),
                        color: colorScheme.primary,
                      ),
                    ),
                    StaggeredFadeIn(
                      index: 1,
                      child: TeacherStatCard(
                        icon: Icons.menu_book_outlined,
                        label: l10n.dashboardSubjectsLabel,
                        value: dashboard.overview.subjectsCount.toString(),
                        color: colorScheme.secondary,
                      ),
                    ),
                    StaggeredFadeIn(
                      index: 2,
                      child: TeacherStatCard(
                        icon: Icons.school_outlined,
                        label: l10n.dashboardStudentsLabel,
                        value: dashboard.overview.studentsCount.toString(),
                        color: colorScheme.tertiary,
                      ),
                    ),
                    StaggeredFadeIn(
                      index: 3,
                      child: TeacherStatCard(
                        icon: Icons.person_off_outlined,
                        label: l10n.dashboardAbsentLabel,
                        value: dashboard.today.absentCount.toString(),
                        color: colorScheme.error,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildWeeklyInsights(context, dashboard),
                const SizedBox(height: 24),
                _buildAttendanceChart(context, dashboard),
                const SizedBox(height: 24),
                Text(
                  l10n.dashboardQuickActionsTitle,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.08,
                  children: [
                    TeacherActionCard(
                      icon: Icons.assignment_turned_in,
                      title: l10n.dashboardAttendanceAction,
                      color: colorScheme.tertiary,
                      onTap: () => context.push(TeacherRoutes.attendanceCreate),
                    ),
                    TeacherActionCard(
                      icon: Icons.fact_check_outlined,
                      title: l10n.dashboardExcusesAction,
                      color: colorScheme.error,
                      onTap: () => context.push(TeacherRoutes.absenceReview),
                    ),
                    TeacherActionCard(
                      icon: Icons.people_alt_outlined,
                      title: l10n.dashboardConferencesAction,
                      color: colorScheme.primary,
                      onTap: () =>
                          context.push(TeacherRoutes.conferencesManage),
                    ),
                    TeacherActionCard(
                      icon: Icons.home_work_outlined,
                      title: l10n.dashboardHomeworkAction,
                      color: colorScheme.secondary,
                      onTap: () => context.push(TeacherRoutes.homeworkList),
                    ),
                    TeacherActionCard(
                      icon: Icons.fact_check_outlined,
                      title: l10n.dashboardAssessmentsAction,
                      color: colorScheme.primary,
                      onTap: () => context.push(TeacherRoutes.assessmentsList),
                    ),
                    TeacherActionCard(
                      icon: Icons.auto_stories_outlined,
                      title: l10n.dashboardSubjectsAction,
                      color: colorScheme.tertiary,
                      onTap: () => context.push(TeacherRoutes.subjectsList),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.dashboardRecentAssessmentsTitle,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                if (dashboard.recentAssessments.isEmpty)
                  SizedBox(
                    height: 180,
                    child: AppEmptyView(
                      title: l10n.dashboardRecentAssessmentsEmptyTitle,
                      message: l10n.dashboardRecentAssessmentsEmptyMessage,
                      icon: Icons.fact_check_outlined,
                    ),
                  )
                else
                  ...dashboard.recentAssessments.map(
                    (assessment) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _RecentAssessmentCard(assessment: assessment),
                    ),
                  ),
              ],
            ),
          ),
        ),
        loading: () => AppLoadingView(
          title: l10n.dashboardLoadingTitle,
          subtitle: l10n.dashboardLoadingSubtitle,
        ),
        error: (error, stack) => AppErrorView(
          title: l10n.dashboardLoadErrorTitle,
          message: ApiErrorHandler.readableMessage(error),
          icon: Icons.space_dashboard_outlined,
          onRetry: () => ref.invalidate(dashboardProvider),
        ),
      ),
    );
  }

  int _attendanceRate(TeacherDashboardResponse dashboard) {
    final totalStudents = dashboard.overview.studentsCount;
    if (totalStudents <= 0) {
      return 0;
    }

    final presentStudents = (totalStudents - dashboard.today.absentCount).clamp(
      0,
      totalStudents,
    );

    return ((presentStudents / totalStudents) * 100).round();
  }

  String _themeModeLabel(ThemeMode themeMode, AppLocalizations l10n) {
    return switch (themeMode) {
      ThemeMode.system => l10n.themeSystem,
      ThemeMode.light => l10n.themeLight,
      ThemeMode.dark => l10n.themeDark,
    };
  }

  IconData _themeModeIcon(ThemeMode themeMode) {
    return switch (themeMode) {
      ThemeMode.system => Icons.brightness_auto_rounded,
      ThemeMode.light => Icons.light_mode_rounded,
      ThemeMode.dark => Icons.dark_mode_rounded,
    };
  }

  Widget _buildWeeklyInsights(
    BuildContext context,
    TeacherDashboardResponse dashboard,
  ) {
    final l10n = context.l10n;
    final attendanceRate = _attendanceRate(dashboard);
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.dashboardWeeklyInsightsTitle,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: colorScheme.secondaryContainer.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: colorScheme.secondary.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.insights, color: colorScheme.secondary, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.dashboardAttendanceRateLabel(attendanceRate),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: attendanceRate / 100,
                      backgroundColor: colorScheme.secondary.withValues(
                        alpha: 0.12,
                      ),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        colorScheme.secondary,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceChart(
    BuildContext context,
    TeacherDashboardResponse dashboard,
  ) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.dashboardAttendanceChartTitle,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 180,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.7),
            ),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(7, (index) {
              final barHeight = 40.0 + (index * 12.0) % 90.0;
              final isToday = index == DateTime.now().weekday - 1;

              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 32,
                    height: barHeight,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isToday
                            ? [colorScheme.primary, colorScheme.secondary]
                            : [
                                colorScheme.primary.withValues(alpha: 0.1),
                                colorScheme.primary.withValues(alpha: 0.2),
                              ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.dashboardWeekdayShort(index),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                      color: isToday
                          ? colorScheme.onSurface
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _DashboardHero extends StatelessWidget {
  final String userName;
  final TeacherDashboardResponse dashboard;

  const _DashboardHero({required this.userName, required this.dashboard});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final todayText = _formatDate(
      dashboard.today.date,
      l10n.intlLocaleTag,
      l10n.dashboardTodayDateUnavailable,
    );
    final theme = Theme.of(context);
    final onHeroColor = colorScheme.onPrimary;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorScheme.primary, colorScheme.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.16),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.dashboardHeroGreeting(userName),
            style: TextStyle(
              color: onHeroColor,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            todayText,
            style: TextStyle(color: onHeroColor.withValues(alpha: 0.78)),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _HeroBadge(
                label:
                    dashboard.currentYear?.name ??
                    l10n.dashboardYearFallbackBadge,
              ),
              _HeroBadge(
                label:
                    dashboard.currentQuarter?.name ??
                    l10n.dashboardQuarterFallbackBadge,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _HeroStat(
                  label: l10n.dashboardLessonsLabel,
                  value: dashboard.today.lessonsTotal.toString(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _HeroStat(
                  label: l10n.dashboardOpenSessionsLabel,
                  value: dashboard.today.sessionsOpen.toString(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _HeroStat(
                  label: l10n.dashboardClosedSessionsLabel,
                  value: dashboard.today.sessionsClosed.toString(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(String? rawDate, String localeTag, String emptyFallback) {
    if (rawDate == null || rawDate.isEmpty) {
      return emptyFallback;
    }
    try {
      return DateFormat(
        'dd.MM.yyyy',
        localeTag,
      ).format(DateTime.parse(rawDate));
    } catch (_) {
      return rawDate;
    }
  }
}

class _HeroBadge extends StatelessWidget {
  final String label;

  const _HeroBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    final onHeroColor = Theme.of(context).colorScheme.onPrimary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: onHeroColor.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: onHeroColor.withValues(alpha: 0.18)),
      ),
      child: Text(
        label,
        style: TextStyle(color: onHeroColor, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  final String label;
  final String value;

  const _HeroStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final onHeroColor = Theme.of(context).colorScheme.onPrimary;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: onHeroColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              color: onHeroColor,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: onHeroColor.withValues(alpha: 0.78),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentAssessmentCard extends StatelessWidget {
  final RecentAssessmentData assessment;

  const _RecentAssessmentCard({required this.assessment});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.7),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            assessment.title.isNotEmpty
                ? assessment.title
                : context.l10n.assessmentFallbackTitle,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (assessment.subjectName != null)
                _AssessmentChip(label: assessment.subjectName!),
              if (assessment.groupName != null)
                _AssessmentChip(label: assessment.groupName!),
              _AssessmentChip(
                label: l10n.dashboardAssessmentMaxScoreLabel(
                  assessment.maxScore,
                ),
              ),
              if (assessment.date != null)
                _AssessmentChip(
                  label: _formatDate(assessment.date!, l10n.intlLocaleTag),
                ),
            ],
          ),
        ],
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
}

class _AssessmentChip extends StatelessWidget {
  final String label;

  const _AssessmentChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _PendingTasks extends StatelessWidget {
  final TeacherDashboardResponse dashboard;

  const _PendingTasks(this.dashboard);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final pendingExcuses = dashboard.today.pendingExcusesCount;
    final activeConferences = dashboard.today.activeConferencesCount;
    final colorScheme = Theme.of(context).colorScheme;

    if (pendingExcuses == 0 && activeConferences == 0) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.dashboardPendingTasksTitle,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              if (pendingExcuses > 0)
                _TaskItem(
                  title: l10n.dashboardExcusesAction,
                  subtitle: l10n.dashboardPendingExcusesSubtitle(
                    pendingExcuses,
                  ),
                  icon: Icons.assignment_late_outlined,
                  color: colorScheme.error,
                  onTap: () =>
                      GoRouter.of(context).push(TeacherRoutes.absenceReview),
                ),
              if (activeConferences > 0)
                _TaskItem(
                  title: l10n.dashboardConferencesAction,
                  subtitle: l10n.dashboardOpenConferenceSlotsSubtitle(
                    activeConferences,
                  ),
                  icon: Icons.people_outline,
                  color: colorScheme.primary,
                  onTap: () => GoRouter.of(
                    context,
                  ).push(TeacherRoutes.conferencesManage),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TaskItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _TaskItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentFill = color.withValues(
      alpha: theme.brightness == Brightness.dark ? 0.18 : 0.1,
    );
    final accentBorder = color.withValues(
      alpha: theme.brightness == Brightness.dark ? 0.28 : 0.2,
    );
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 220,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: accentFill,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: accentBorder),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: accentBorder,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: color.withValues(alpha: 0.9),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: color.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
