import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import '../../../core/network/api_error_handler.dart';
import '../../providers/lesson_provider.dart';
import '../../../data/models/lesson_model.dart';
import '../../widgets/app_feedback.dart';

class TodayLessonsScreen extends ConsumerStatefulWidget {
  const TodayLessonsScreen({super.key});

  @override
  ConsumerState<TodayLessonsScreen> createState() => _TodayLessonsScreenState();
}

class _TodayLessonsScreenState extends ConsumerState<TodayLessonsScreen> {
  bool _isStartingLesson = false;

  Future<void> _startLesson(TimetableEntry entry, int quarterId) async {
    setState(() => _isStartingLesson = true);
    try {
      final date = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final repo = ref.read(lessonRepositoryProvider);
      final sessionId = await repo.startLesson(entry.id, quarterId, date);

      if (mounted) {
        context.push('/lessons/session/$sessionId');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ApiErrorHandler.readableMessage(e)),
            backgroundColor: TeacherAppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isStartingLesson = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final lessonsAsync = ref.watch(todayLessonsProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.todayLessonsTitle),
        backgroundColor:
            theme.appBarTheme.backgroundColor ?? colorScheme.surface,
        foregroundColor:
            theme.appBarTheme.foregroundColor ?? colorScheme.onSurface,
        elevation: 0,
      ),
      body: lessonsAsync.when(
        data: (data) {
          if (data.entries.isEmpty) {
            return AppEmptyView(
              title: l10n.noLessonsTodayTitle,
              message: l10n.noLessonsTodayMessage,
              icon: Icons.celebration_outlined,
            );
          }

          return Stack(
            children: [
              ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: data.entries.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final entry = data.entries[index];
                  final isCurrent = data.currentEntryId == entry.id;

                  return _buildLessonCard(entry, data.quarterId, isCurrent);
                },
              ),
              if (_isStartingLesson)
                Container(
                  color: theme.shadowColor.withValues(alpha: 0.18),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        },
        loading: () => AppLoadingView(
          title: l10n.lessonsLoadingTitle,
          subtitle: l10n.lessonsLoadingSubtitle,
        ),
        error: (err, stack) => AppErrorView(
          title: l10n.lessonsLoadErrorTitle,
          message: ApiErrorHandler.readableMessage(err),
          onRetry: () => ref.invalidate(todayLessonsProvider),
        ),
      ),
    );
  }

  Widget _buildLessonCard(TimetableEntry entry, int quarterId, bool isCurrent) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isCurrent ? colorScheme.primary : colorScheme.outline,
          width: isCurrent ? 2 : 1,
        ),
      ),
      color: isCurrent
          ? colorScheme.primary.withValues(alpha: 0.05)
          : theme.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: TeacherAppColors.info.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    AppLocalizationsRegistry.instance.lessonOrderLabel(
                      entry.orderNumber,
                    ),
                    style: const TextStyle(
                      color: TeacherAppColors.info,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '${entry.startTime.substring(0, 5)} - ${entry.endTime.substring(0, 5)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              entry.subjectName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.people_outline,
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  entry.groupName,
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.room_outlined,
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  entry.room,
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _startLesson(entry, quarterId),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isCurrent
                      ? colorScheme.primary
                      : colorScheme.surface,
                  foregroundColor: isCurrent
                      ? colorScheme.onPrimary
                      : colorScheme.onSurface,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  AppLocalizationsRegistry.instance.startLessonButton,
                  style: TextStyle(
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
