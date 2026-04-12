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
import '../../widgets/common/page_background.dart';
import '../../widgets/home/dashboard_stats_header.dart';
import '../../widgets/home/bento_grid.dart';
import '../../widgets/shared/app_empty_view.dart';
import '../../widgets/shared/app_error_view.dart';
import '../assessments/assessment_details_screen.dart'; // Just in case, but keep it clean

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

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: PageBackground(
        child: dashboardAsync.when(
          data: (dashboard) => RefreshIndicator(
            onRefresh: () => _refresh(ref),
            displacement: 100,
            color: colorScheme.primary,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // ─── Premium Header ───
                SliverToBoxAdapter(
                  child: DashboardStatsHeader(
                    userName: userName,
                    dashboard: dashboard,
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const SyncStatusBanner(),
                      const SizedBox(height: 16),

                      // ─── Upcoming Section ───
                      if (dashboard.today.pendingExcusesCount > 0 || dashboard.today.activeConferencesCount > 0) ...[
                        _SectionHeader(title: l10n.dashboardPendingTasksTitle),
                        const SizedBox(height: 12),
                        _PendingTasks(dashboard: dashboard),
                        const SizedBox(height: 32),
                      ],

                      // ─── Bento Grid ───
                      _SectionHeader(title: l10n.dashboardQuickActionsTitle),
                      const SizedBox(height: 16),
                      const BentoGrid(),
                      const SizedBox(height: 32),

                      // ─── Insights Section ───
                      _SectionHeader(title: l10n.dashboardWeeklyInsightsTitle),
                      const SizedBox(height: 16),
                      _WeeklyInsights(dashboard: dashboard),
                      const SizedBox(height: 32),

                      // ─── Recent Assessments ───
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _SectionHeader(title: l10n.dashboardRecentAssessmentsTitle),
                          TextButton(
                            onPressed: () => context.push(TeacherRoutes.assessmentsList),
                            child: Text(
                              l10n.viewAll,
                              style: TextStyle(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (dashboard.recentAssessments.isEmpty)
                        AppEmptyView(
                          title: l10n.dashboardRecentAssessmentsEmptyTitle,
                          message: l10n.dashboardRecentAssessmentsEmptyMessage,
                          icon: Icons.fact_check_outlined,
                        )
                      else
                        ...dashboard.recentAssessments.take(3).map(
                          (assessment) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _RecentAssessmentCard(assessment: assessment),
                          ),
                        ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => AppErrorView(
            title: l10n.dashboardLoadErrorTitle,
            message: ApiErrorHandler.readableMessage(error),
            icon: Icons.space_dashboard_outlined,
            onRetry: () => ref.invalidate(dashboardProvider),
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
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.2,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
      ),
    );
  }
}


class _WeeklyInsights extends StatelessWidget {
  final TeacherDashboardResponse dashboard;
  const _WeeklyInsights({required this.dashboard});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Calculate attendance rate
    final totalStudents = dashboard.overview.studentsCount;
    final absentCount = dashboard.today.absentCount;
    final attendanceRate = totalStudents > 0 
        ? ((totalStudents - absentCount) / totalStudents * 100).round() 
        : 0;

    return PremiumCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.insights_rounded, color: colorScheme.secondary, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.dashboardAttendanceRateLabel(attendanceRate),
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                    ),
                    Text(
                      '$attendanceRate%',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        color: colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: attendanceRate / 100,
                    minHeight: 6,
                    backgroundColor: colorScheme.secondary.withValues(alpha: 0.05),
                    valueColor: AlwaysStoppedAnimation<Color>(colorScheme.secondary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
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
    final colorScheme = Theme.of(context).colorScheme;

    return PremiumCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  assessment.title.isNotEmpty ? assessment.title : l10n.assessmentFallbackTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  l10n.dashboardAssessmentMaxScoreLabel(assessment.maxScore),
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w900,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (assessment.subjectName != null)
                _AssessmentChip(label: assessment.subjectName!, icon: Icons.book_outlined),
              if (assessment.groupName != null)
                _AssessmentChip(label: assessment.groupName!, icon: Icons.group_outlined),
              if (assessment.date != null)
                _AssessmentChip(
                  label: _formatDate(assessment.date!, l10n.intlLocaleTag),
                  icon: Icons.calendar_today_outlined,
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(String rawDate, String localeTag) {
    try {
      return DateFormat('dd.MM.yyyy', localeTag).format(DateTime.parse(rawDate));
    } catch (_) {
      return rawDate;
    }
  }
}

class _AssessmentChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _AssessmentChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: colorScheme.onSurface.withValues(alpha: 0.4)),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _PendingTasks extends StatelessWidget {
  final TeacherDashboardResponse dashboard;
  const _PendingTasks({required this.dashboard});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final pendingExcuses = dashboard.today.pendingExcusesCount;
    final activeConferences = dashboard.today.activeConferencesCount;
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Colors.transparent == null ? Clip.hardEdge : Clip.none,
        children: [
          if (pendingExcuses > 0)
            _TaskItem(
              title: l10n.dashboardExcusesAction,
              subtitle: l10n.dashboardPendingExcusesSubtitle(pendingExcuses),
              icon: Icons.assignment_late_rounded,
              color: TeacherAppColors.error,
              onTap: () => context.push(TeacherRoutes.absenceReview),
            ),
          if (activeConferences > 0)
            _TaskItem(
              title: l10n.dashboardConferencesAction,
              subtitle: l10n.dashboardOpenConferenceSlotsSubtitle(activeConferences),
              icon: Icons.people_rounded,
              color: colorScheme.primary,
              onTap: () => context.push(TeacherRoutes.conferencesManage),
            ),
        ],
      ),
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
    return AnimatedPressable(
      onTap: onTap,
      child: Container(
        width: 240,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.15), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: color,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: color.withValues(alpha: 0.6),
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
