import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import 'package:teacher_school_app/l10n/app_localizations.dart';
import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import '../../../core/network/api_error_handler.dart';
import '../../providers/lesson_provider.dart';
import '../../widgets/app_feedback.dart';

class LessonSessionScreen extends ConsumerStatefulWidget {
  final int sessionId;

  const LessonSessionScreen({super.key, required this.sessionId});

  @override
  ConsumerState<LessonSessionScreen> createState() =>
      _LessonSessionScreenState();
}

class _LessonSessionScreenState extends ConsumerState<LessonSessionScreen> {
  final _topicController = TextEditingController();
  bool _isInit = false;

  @override
  void dispose() {
    _topicController.dispose();
    super.dispose();
  }

  void _handleSave(WidgetRef ref) async {
    final l10n = context.l10n;
    final success = await ref
        .read(lessonSessionControllerProvider(widget.sessionId).notifier)
        .saveSession(_topicController.text);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.lessonSessionSavedSuccess),
          backgroundColor: TeacherAppColors.success,
        ),
      );
      context.pop();
    } else if (mounted) {
      final error = ref
          .read(lessonSessionControllerProvider(widget.sessionId))
          .error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ApiErrorHandler.readableMessage(
              error,
              fallback: l10n.lessonSessionSaveErrorFallback,
            ),
          ),
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
    final sessionState = ref.watch(
      lessonSessionControllerProvider(widget.sessionId),
    );

    // Initialize controller text once data is loaded
    if (sessionState.detail != null && !_isInit) {
      _topicController.text = sessionState.detail!.session.topic ?? '';
      _isInit = true;
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.lessonSessionTitle),
        backgroundColor:
            theme.appBarTheme.backgroundColor ?? colorScheme.surface,
        foregroundColor:
            theme.appBarTheme.foregroundColor ?? colorScheme.onSurface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.assignment_add),
            tooltip: l10n.addHomeworkTooltip,
            onPressed: () {
              context.push('/homework/create/${widget.sessionId}');
            },
          ),
          TextButton(
            onPressed: sessionState.isLoading ? null : () => _handleSave(ref),
            child: sessionState.isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colorScheme.primary,
                    ),
                  )
                : Text(
                    l10n.saveAction,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: colorScheme.primary,
                    ),
                  ),
          ),
        ],
      ),
      body: sessionState.isLoading && sessionState.detail == null
          ? AppLoadingView(
              title: l10n.lessonSessionLoadingTitle,
              subtitle: l10n.lessonSessionLoadingSubtitle,
            )
          : sessionState.error != null && sessionState.detail == null
          ? AppErrorView(
              title: l10n.lessonSessionLoadErrorTitle,
              message: ApiErrorHandler.readableMessage(sessionState.error),
              onRetry: () => ref
                  .read(
                    lessonSessionControllerProvider(widget.sessionId).notifier,
                  )
                  .loadSession(),
            )
          : _buildContent(context, ref, sessionState),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    LessonSessionState state,
  ) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final detail = state.detail!;
    final rows = detail.rows;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.lessonSessionTopicLabel,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _topicController,
                  decoration: InputDecoration(
                    hintText: l10n.lessonSessionTopicHint,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.lessonSessionStudentsTitle,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final row = rows[index];
            return _buildStudentRow(context, ref, row, detail.gradingMode);
          }, childCount: rows.length),
        ),
      ],
    );
  }

  Widget _buildStudentRow(
    BuildContext context,
    WidgetRef ref,
    dynamic row,
    String gradingMode,
  ) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
              Expanded(
                child: Text(
                  row.studentName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              if (!row.isPresent)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: TeacherAppColors.absent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    l10n.absentStatusShort,
                    style: const TextStyle(
                      color: TeacherAppColors.absent,
                      fontSize: 12,
                    ),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: TeacherAppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    l10n.presentStatusShort,
                    style: const TextStyle(
                      color: TeacherAppColors.success,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (gradingMode == 'grade')
            _buildGradeSelector(ref, row)
          else
            _buildCoinSelector(ref, row),
        ],
      ),
    );
  }

  Widget _buildGradeSelector(WidgetRef ref, dynamic row) {
    final colorScheme = Theme.of(context).colorScheme;
    final chipBackground = colorScheme.surfaceContainerHighest;
    return Wrap(
      spacing: 8,
      children: [5, 4, 3, 2, 1].map((grade) {
        final isSelected = row.grade == grade;
        return ChoiceChip(
          label: Text(grade.toString()),
          selected: isSelected,
          backgroundColor: chipBackground,
          selectedColor: _getGradeColor(grade).withValues(alpha: 0.2),
          labelStyle: TextStyle(
            color: isSelected
                ? _getGradeColor(grade)
                : colorScheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
          onSelected: (selected) {
            ref
                .read(
                  lessonSessionControllerProvider(widget.sessionId).notifier,
                )
                .updateRowGrade(row.studentId, selected ? grade : null);
          },
        );
      }).toList(),
    );
  }

  Widget _buildCoinSelector(WidgetRef ref, dynamic row) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final coinValues = [5, 10, 20, 50, 100];
    final chipBackground = colorScheme.surfaceContainerHighest;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          children: coinValues.map((coin) {
            final isSelected = row.coin == coin;
            return ChoiceChip(
              avatar: Icon(
                Icons.stars,
                size: 14,
                color: isSelected
                    ? colorScheme.onPrimary
                    : TeacherAppColors.warning,
              ),
              label: Text('$coin'),
              selected: isSelected,
              backgroundColor: chipBackground,
              selectedColor: TeacherAppColors.warning,
              labelStyle: TextStyle(
                color: isSelected
                    ? colorScheme.onPrimary
                    : colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              onSelected: (selected) {
                ref
                    .read(
                      lessonSessionControllerProvider(
                        widget.sessionId,
                      ).notifier,
                    )
                    .updateRowCoin(row.studentId, selected ? coin : null);
              },
            );
          }).toList(),
        ),
        if (row.coin != null && row.coin > 0)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(
              l10n.lessonCoinsSaved(row.coin),
              style: const TextStyle(
                fontSize: 12,
                color: TeacherAppColors.warning,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Color _getGradeColor(int grade) {
    switch (grade) {
      case 5:
        return TeacherAppColors.grade5;
      case 4:
        return TeacherAppColors.grade4;
      case 3:
        return TeacherAppColors.grade3;
      case 2:
        return TeacherAppColors.grade2;
      case 1:
        return TeacherAppColors.grade1;
      default:
        return TeacherAppColors.textSecondary;
    }
  }
}
