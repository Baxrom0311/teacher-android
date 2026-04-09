import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import 'package:teacher_school_app/l10n/app_localizations.dart';
import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import '../../../core/network/api_error_handler.dart';
import '../../providers/homework_provider.dart';
import '../../providers/lesson_provider.dart';

class HomeworkListScreen extends ConsumerStatefulWidget {
  const HomeworkListScreen({super.key});

  @override
  ConsumerState<HomeworkListScreen> createState() => _HomeworkListScreenState();
}

class _HomeworkListScreenState extends ConsumerState<HomeworkListScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final lessonsAsync = ref.watch(todayLessonsProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.homeworkListTitle),
        backgroundColor:
            theme.appBarTheme.backgroundColor ?? colorScheme.surface,
        foregroundColor:
            theme.appBarTheme.foregroundColor ?? colorScheme.onSurface,
        elevation: 0,
      ),
      body: lessonsAsync.when(
        data: (lessons) {
          final homeworksAsync = ref.watch(
            lessonHomeworksProvider({'quarter_id': lessons.quarterId}),
          );

          return homeworksAsync.when(
            data: (homeworks) {
              if (homeworks.isEmpty) {
                return Center(
                  child: Text(
                    l10n.noAssignedHomeworks,
                    style: TextStyle(
                      fontSize: 16,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: homeworks.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final hw = homeworks[index];
                  return _buildHomeworkCard(context, hw);
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) =>
                Center(child: Text(ApiErrorHandler.readableMessage(err))),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) =>
            Center(child: Text(ApiErrorHandler.readableMessage(err))),
      ),
    );
  }

  Widget _buildHomeworkCard(BuildContext context, dynamic hw) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: () {
        context.push('/homework/check/${hw.id}', extra: hw.title);
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
                Text(
                  hw.groupName ?? l10n.homeworkGroupFallback,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                Text(
                  hw.date,
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              hw.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              hw.description ?? l10n.homeworkDescriptionFallback,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
            if (hw.dueDate != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: TeacherAppColors.warning,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    l10n.homeworkDueDateText(hw.dueDate!),
                    style: const TextStyle(
                      fontSize: 12,
                      color: TeacherAppColors.warning,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
