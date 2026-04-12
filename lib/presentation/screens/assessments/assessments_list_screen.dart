import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:teacher_school_app/core/localization/l10n_extension.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/network/api_error_handler.dart';
import '../../providers/assessment_provider.dart';
import '../../widgets/app_feedback.dart';
import '../../widgets/common/page_background.dart';
import '../../widgets/common/premium_card.dart';

class AssessmentsListScreen extends ConsumerStatefulWidget {
  const AssessmentsListScreen({super.key});

  @override
  ConsumerState<AssessmentsListScreen> createState() =>
      _AssessmentsListScreenState();
}

class _AssessmentsListScreenState extends ConsumerState<AssessmentsListScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final assessmentsAsync = ref.watch(assessmentsListProvider({}));

    return PageBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: assessmentsAsync.when(
          data: (data) {
            final items = (data['items'] as List?) ?? const [];

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  floating: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  centerTitle: true,
                  title: Text(
                    l10n.assessmentsListTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add_rounded,
                          color: colorScheme.primary,
                        ),
                      ),
                      onPressed: () => context.push('/assessments/create'),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
                if (items.isEmpty)
                  SliverFillRemaining(
                    child: AppEmptyView(
                      title: l10n.assessmentsListEmpty,
                      message: l10n.emptyTitle,
                      icon: Icons.assignment_outlined,
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final assessment = items[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _AssessmentListItem(assessment: assessment),
                        );
                      }, childCount: items.length),
                    ),
                  ),
              ],
            );
          },
          loading: () => const Center(child: AppLoadingView()),
          error: (err, stack) => Center(
            child: AppErrorView(message: ApiErrorHandler.readableMessage(err)),
          ),
        ),
      ),
    );
  }
}

class _AssessmentListItem extends StatelessWidget {
  final dynamic assessment;

  const _AssessmentListItem({required this.assessment});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final title = (assessment.title as String?)?.trim();
    final subjectName = (assessment.subjectName as String?)?.trim();
    final type = assessment.type?.toString() ?? 'quiz';

    return InkWell(
      onTap: () {
        context.push(
          '/assessments/${assessment.id}/results',
          extra: title?.isNotEmpty == true
              ? title
              : l10n.assessmentFallbackTitle,
        );
      },
      borderRadius: BorderRadius.circular(32),
      child: PremiumCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StatusChip(
                  label: l10n.assessmentTypeLabelText(type),
                  color: _getTypeColor(type),
                ),
                Text(
                  _formatDate(assessment.heldAt, l10n.intlLocaleTag),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface.withValues(alpha: 0.45),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              title?.isNotEmpty == true ? title! : l10n.assessmentFallbackTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _InfoRow(
                  icon: Icons.group_rounded,
                  label: assessment.groupName?.toString() ?? '-',
                ),
                _InfoRow(
                  icon: Icons.auto_stories_rounded,
                  label: subjectName?.isNotEmpty == true
                      ? subjectName!
                      : l10n.unknownSubjectFallback,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _ScoreTag(
                  label: l10n.assessmentMaxScoreText(
                    assessment.maxScore as num?,
                  ),
                  color: TeacherAppColors.success,
                ),
                const SizedBox(width: 8),
                _ScoreTag(
                  label: l10n.assessmentWeightText(assessment.weight as num?),
                  color: TeacherAppColors.warning,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(dynamic rawDate, String localeTag) {
    if (rawDate == null) return '-';
    final parsed = DateTime.tryParse(rawDate.toString());
    if (parsed == null) return rawDate.toString();
    return DateFormat('dd.MM.yyyy', localeTag).format(parsed);
  }

  Color _getTypeColor(String type) {
    return switch (type.toLowerCase()) {
      'exam' => TeacherAppColors.error,
      'quiz' => TeacherAppColors.warning,
      'project' => TeacherAppColors.info,
      _ => TeacherAppColors.primaryPurple,
    };
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: colorScheme.onSurface.withValues(alpha: 0.45),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface.withValues(alpha: 0.65),
          ),
        ),
      ],
    );
  }
}

class _ScoreTag extends StatelessWidget {
  final String label;
  final Color color;

  const _ScoreTag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 13,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
