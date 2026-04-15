import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:teacher_school_app/core/localization/l10n_extension.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../common/premium_card.dart';
import '../common/animated_pressable.dart';

class BentoGrid extends StatelessWidget {
  const BentoGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      children: [
        // ─── Row 1: Large Feature + Small ───
        Row(
          children: [
            Expanded(
              flex: 2,
              child: _BentoItem(
                title: l10n.dashboardAttendanceAction,
                subtitle: 'Bugungi davomat',
                icon: Icons.assignment_turned_in,
                color: TeacherAppColors.bentoSky,
                onTap: () => context.push(TeacherRoutes.attendanceCreate),
                isLarge: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 1,
              child: _BentoItem(
                title: l10n.dashboardExcusesAction,
                subtitle: 'Sababli',
                icon: Icons.fact_check_outlined,
                color: TeacherAppColors.bentoRose,
                onTap: () => context.push(TeacherRoutes.absenceReview),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // ─── Row 2: Three Small Icons ───
        Row(
          children: [
            Expanded(
              child: _BentoItem(
                title: l10n.dashboardHomeworkAction,
                icon: Icons.home_work_outlined,
                color: TeacherAppColors.bentoEmerald,
                onTap: () => context.push(TeacherRoutes.homeworkList),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _BentoItem(
                title: l10n.dashboardConferencesAction,
                icon: Icons.people_alt_outlined,
                color: TeacherAppColors.bentoBlue,
                onTap: () => context.push(TeacherRoutes.conferencesManage),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // ─── Row 3: Small + Large Feature ───
        Row(
          children: [
            Expanded(
              flex: 1,
              child: _BentoItem(
                title: l10n.dashboardSubjectsAction,
                icon: Icons.auto_stories_outlined,
                color: TeacherAppColors.bentoAmber,
                onTap: () => context.push(TeacherRoutes.subjectsList),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: _BentoItem(
                title: l10n.dashboardAssessmentsAction,
                subtitle: 'Baholash sistemasi',
                icon: Icons.fact_check_outlined,
                color: TeacherAppColors.bentoPrimary,
                onTap: () => context.push(TeacherRoutes.assessmentsList),
                isHorizontal: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BentoItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool isLarge;
  final bool isHorizontal;

  const _BentoItem({
    required this.title,
    this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
    this.isLarge = false,
    this.isHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedPressable(
      onTap: onTap,
      child: PremiumCard(
        padding: EdgeInsets.zero,
        borderRadius: 24,
        color: isDark
            ? color.withValues(alpha: 0.1)
            : color.withValues(alpha: 0.05),
        border: Border.all(
          color: color.withValues(alpha: isDark ? 0.2 : 0.1),
          width: 1.5,
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          height: isLarge ? 180 : 136,
          child: isHorizontal
              ? Row(
                  children: [
                    _IconBox(icon: icon, color: color),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _TextColumn(
                        title: title,
                        subtitle: subtitle,
                        color: color,
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _IconBox(icon: icon, color: color),
                    _TextColumn(title: title, subtitle: subtitle, color: color),
                  ],
                ),
        ),
      ),
    );
  }
}

class _IconBox extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _IconBox({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }
}

class _TextColumn extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Color color;

  const _TextColumn({required this.title, this.subtitle, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.2,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(
            subtitle!,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ],
    );
  }
}
