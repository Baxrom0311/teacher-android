import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:teacher_school_app/core/localization/l10n_extension.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/network/api_error_handler.dart';
import '../../providers/homework_provider.dart';
import '../../providers/lesson_provider.dart';
import '../../widgets/app_feedback.dart';
import '../../widgets/common/page_background.dart';
import '../../widgets/common/premium_card.dart';

class HomeworkListScreen extends ConsumerWidget {
  const HomeworkListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final lessonsAsync = ref.watch(todayLessonsProvider);

    return PageBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            l10n.homeworkListTitle,
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        body: lessonsAsync.when(
          data: (lessons) {
            final homeworksAsync = ref.watch(
              lessonHomeworksProvider({'quarter_id': lessons.quarterId}),
            );

            return homeworksAsync.when(
              data: (homeworks) {
                if (homeworks.isEmpty) {
                  return AppEmptyView(
                    message: l10n.noAssignedHomeworks,
                    icon: Icons.assignment_rounded,
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                  physics: const BouncingScrollPhysics(),
                  itemCount: homeworks.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _HomeworkCard(hw: homeworks[index]),
                    );
                  },
                );
              },
              loading: () => const AppLoadingView(),
              error: (err, stack) => AppErrorView(
                message: ApiErrorHandler.readableMessage(err),
                icon: Icons.assignment_rounded,
                onRetry: () => ref.invalidate(todayLessonsProvider),
              ),
            );
          },
          loading: () => const AppLoadingView(),
          error: (err, stack) => AppErrorView(
            message: ApiErrorHandler.readableMessage(err),
            icon: Icons.assignment_rounded,
            onRetry: () => ref.invalidate(todayLessonsProvider),
          ),
        ),
      ),
    );
  }
}

class _HomeworkCard extends StatelessWidget {
  final dynamic hw;

  const _HomeworkCard({required this.hw});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => context.push('/homework/check/${hw.id}', extra: hw.title),
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
                  label: hw.groupName?.toString() ?? l10n.homeworkGroupFallback,
                  color: colorScheme.primary,
                ),
                Text(
                  hw.date?.toString() ?? '-',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onSurface.withValues(alpha: 0.35),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              hw.title?.toString() ?? l10n.homeworkListTitle,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              hw.description?.toString() ?? l10n.homeworkDescriptionFallback,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
            if (hw.dueDate != null) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: TeacherAppColors.warning.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: TeacherAppColors.warning.withValues(alpha: 0.15),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.timer_rounded,
                      size: 16,
                      color: TeacherAppColors.warning,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.homeworkDueDateText(hw.dueDate),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: TeacherAppColors.warning,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
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
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 10,
          color: color,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
