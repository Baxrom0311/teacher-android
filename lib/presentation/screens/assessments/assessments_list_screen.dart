import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import 'package:teacher_school_app/l10n/app_localizations.dart';
import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import '../../../core/network/api_error_handler.dart';
import '../../providers/assessment_provider.dart';

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final assessmentsAsync = ref.watch(assessmentsListProvider({}));

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.assessmentsListTitle),
        backgroundColor:
            theme.appBarTheme.backgroundColor ?? colorScheme.surface,
        foregroundColor:
            theme.appBarTheme.foregroundColor ?? colorScheme.onSurface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: l10n.addAssessmentTooltip,
            onPressed: () {
              context.push('/assessments/create');
            },
          ),
        ],
      ),
      body: assessmentsAsync.when(
        data: (data) {
          final items = data['items'] as List;
          if (items.isEmpty) {
            return Center(
              child: Text(
                l10n.assessmentsListEmpty,
                style: TextStyle(
                  fontSize: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final assessment = items[index];
              return _buildAssessmentCard(context, assessment);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) =>
            Center(child: Text(ApiErrorHandler.readableMessage(err))),
      ),
    );
  }

  Widget _buildAssessmentCard(BuildContext context, dynamic assessment) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final title = (assessment.title as String?)?.trim() ?? '';
    final subjectName = (assessment.subjectName as String?)?.trim() ?? '';

    return InkWell(
      onTap: () {
        context.push(
          '/assessments/${assessment.id}/results',
          extra: title.isNotEmpty ? title : l10n.assessmentFallbackTitle,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.outline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    l10n.assessmentTypeLabelText(assessment.type),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                Text(
                  assessment.heldAt ?? '-',
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title.isNotEmpty ? title : l10n.assessmentFallbackTitle,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.people,
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  assessment.groupName ?? l10n.assessmentUnknownGroup,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.book, size: 16, color: colorScheme.onSurfaceVariant),
                const SizedBox(width: 4),
                Text(
                  subjectName.isNotEmpty
                      ? subjectName
                      : l10n.unknownSubjectFallback,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.assessmentMaxScoreText(assessment.maxScore),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: TeacherAppColors.success,
                  ),
                ),
                Text(
                  l10n.assessmentWeightText(assessment.weight),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: TeacherAppColors.warning,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
