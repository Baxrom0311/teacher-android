import '../../../core/constants/app_colors.dart';
import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_error_handler.dart';
import '../../providers/homework_provider.dart';
import '../../widgets/app_feedback.dart';
import '../../widgets/common/page_background.dart';
import '../../widgets/common/premium_card.dart';
import '../../widgets/common/animated_pressable.dart';

class HomeworkCheckScreen extends ConsumerWidget {
  final int lessonHomeworkId;
  final String title;

  const HomeworkCheckScreen({
    super.key,
    required this.lessonHomeworkId,
    required this.title,
  });

  void _showGradeDialog(
    BuildContext context,
    WidgetRef ref,
    int studentHomeworkId,
  ) {
    final l10n = context.l10n;
    int selectedGrade = 5;
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            final colorScheme = Theme.of(context).colorScheme;
            return AlertDialog(
              backgroundColor: TeacherAppColors.slate800,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
                side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
              ),
              title: Text(
                l10n.homeworkCheckDialogTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n
                        .homeworkGradeLabel(0)
                        .replaceAll(': 0', '')
                        .trim()
                        .toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 11,
                      letterSpacing: 1,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [5, 4, 3, 2, 1].map((g) {
                      final isSelected = selectedGrade == g;
                      return AnimatedPressable(
                        onTap: () => setState(() => selectedGrade = g),
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? colorScheme.primary
                                : Colors.white.withValues(alpha: 0.05),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? colorScheme.primary
                                  : Colors.white.withValues(alpha: 0.1),
                              width: 2,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: colorScheme.primary.withValues(
                                        alpha: 0.4,
                                      ),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : [],
                          ),
                          child: Center(
                            child: Text(
                              g.toString(),
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : colorScheme.onSurface,
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.homeworkCommentHint.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 11,
                      letterSpacing: 1,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: commentController,
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      hintText: l10n.homeworkCommentHint,
                      hintStyle: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.3),
                      ),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.05),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(
                    l10n.cancel,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                AnimatedPressable(
                  onTap: () async {
                    Navigator.pop(ctx);
                    final success = await ref
                        .read(homeworkControllerProvider.notifier)
                        .gradeSubmission(
                          studentHomeworkId,
                          selectedGrade,
                          commentController.text.trim().isEmpty
                              ? null
                              : commentController.text.trim(),
                        );
                    if (success) {
                      ref.invalidate(
                        homeworkSubmissionsProvider(lessonHomeworkId),
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [colorScheme.primary, colorScheme.secondary],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      l10n.saveAction.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    ).then((_) => commentController.dispose());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final submissionsAsync = ref.watch(
      homeworkSubmissionsProvider(lessonHomeworkId),
    );

    return PageBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        body: submissionsAsync.when(
          data: (submissions) {
            if (submissions.isEmpty) {
              return AppEmptyView(
                message: l10n.homeworkNoSubmissions,
                icon: Icons.assignment_rounded,
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
              physics: const BouncingScrollPhysics(),
              itemCount: submissions.length,
              itemBuilder: (context, index) {
                final sub = submissions[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _SubmissionCard(
                    submission: sub,
                    onGrade: () => _showGradeDialog(context, ref, sub.id),
                  ),
                );
              },
            );
          },
          loading: () => const AppLoadingView(),
          error: (err, st) => AppErrorView(
            message: ApiErrorHandler.readableMessage(err),
            icon: Icons.assignment_late_rounded,
            onRetry: () =>
                ref.invalidate(homeworkSubmissionsProvider(lessonHomeworkId)),
          ),
        ),
      ),
    );
  }
}

class _SubmissionCard extends StatelessWidget {
  final dynamic submission;
  final VoidCallback onGrade;

  const _SubmissionCard({required this.submission, required this.onGrade});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final isGraded = submission.status == 'graded';

    return PremiumCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _AvatarSmall(name: submission.studentName),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      submission.studentName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      (isGraded
                              ? l10n.homeworkStatusLabel('graded')
                              : l10n.homeworkStatusLabel('pending'))
                          .toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                        color: isGraded
                            ? TeacherAppColors.success
                            : TeacherAppColors.late,
                      ),
                    ),
                  ],
                ),
              ),
              if (isGraded && submission.grade != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getGradeColor(
                      submission.grade!,
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    submission.grade.toString(),
                    style: TextStyle(
                      color: _getGradeColor(submission.grade!),
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                ),
            ],
          ),
          if (submission.fileUrl != null) ...[
            const SizedBox(height: 20),
            AnimatedPressable(
              onTap: () {
                // Launch URL logic would go here
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.description_rounded,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.homeworkViewFileAction,
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.open_in_new_rounded,
                      color: colorScheme.primary.withValues(alpha: 0.5),
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 20),
          AnimatedPressable(
            onTap: onGrade,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isGraded
                    ? Colors.white.withValues(alpha: 0.03)
                    : colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
                border: isGraded
                    ? Border.all(color: Colors.white.withValues(alpha: 0.1))
                    : null,
              ),
              child: Text(
                (isGraded ? l10n.editAction : l10n.gradeAction).toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isGraded ? colorScheme.onSurface : Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
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

class _AvatarSmall extends StatelessWidget {
  final String name;
  const _AvatarSmall({required this.name});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.1),
        shape: BoxShape.circle,
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.2)),
      ),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : 'S',
          style: TextStyle(
            color: colorScheme.primary,
            fontWeight: FontWeight.w900,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
