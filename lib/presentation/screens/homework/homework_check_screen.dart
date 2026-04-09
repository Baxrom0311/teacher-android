import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import 'package:teacher_school_app/l10n/app_localizations.dart';
import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import '../../../core/network/api_error_handler.dart';
import '../../providers/homework_provider.dart';
import '../../widgets/app_feedback.dart';

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
    final l10n = AppLocalizations.of(context)!;
    int selectedGrade = 5;
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(l10n.homeworkCheckDialogTitle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Wrap(
                    spacing: 8,
                    children: [5, 4, 3, 2, 1].map((g) {
                      return ChoiceChip(
                        label: Text(g.toString()),
                        selected: selectedGrade == g,
                        onSelected: (val) {
                          if (val) setState(() => selectedGrade = g);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      hintText: l10n.homeworkCommentHint,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(l10n.cancel),
                ),
                ElevatedButton(
                  onPressed: () async {
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
                  child: Text(l10n.saveAction),
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final submissionsAsync = ref.watch(
      homeworkSubmissionsProvider(lessonHomeworkId),
    );

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(title),
        backgroundColor:
            theme.appBarTheme.backgroundColor ?? colorScheme.surface,
        foregroundColor:
            theme.appBarTheme.foregroundColor ?? colorScheme.onSurface,
        elevation: 0,
      ),
      body: submissionsAsync.when(
        data: (submissions) {
          if (submissions.isEmpty) {
            return Center(
              child: Text(
                l10n.homeworkNoSubmissions,
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: submissions.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final sub = submissions[index];
              return Container(
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
                        Text(
                          sub.studentName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: sub.status == 'graded'
                                ? TeacherAppColors.success.withValues(
                                    alpha: 0.1,
                                  )
                                : TeacherAppColors.warning.withValues(
                                    alpha: 0.1,
                                  ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            l10n.homeworkStatusLabel(sub.status),
                            style: TextStyle(
                              color: sub.status == 'graded'
                                  ? TeacherAppColors.success
                                  : TeacherAppColors.warning,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (sub.fileUrl != null) ...[
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () {
                          // Launch URL
                        },
                        child: Text(
                          l10n.homeworkViewFileAction,
                          style: TextStyle(
                            color: colorScheme.primary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        if (sub.grade != null)
                          Text(
                            l10n.homeworkGradeLabel(sub.grade!),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        const Spacer(),
                        OutlinedButton(
                          onPressed: () =>
                              _showGradeDialog(context, ref, sub.id),
                          child: Text(
                            sub.grade == null
                                ? l10n.gradeAction
                                : l10n.editAction,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const AppLoadingView(),
        error: (err, st) => AppErrorView(
          message: ApiErrorHandler.readableMessage(err),
          icon: Icons.assignment_late_outlined,
        ),
      ),
    );
  }
}
