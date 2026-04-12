import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:teacher_school_app/core/localization/l10n_extension.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/network/api_error_handler.dart';
import '../../providers/lesson_provider.dart';
import '../../../data/models/lesson_model.dart';
import '../../widgets/app_feedback.dart';
import '../../widgets/common/page_background.dart';
import '../../widgets/common/premium_card.dart';
import '../../widgets/common/animated_pressable.dart';

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

    return PageBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Column(
            children: [
              Text(
                l10n.todayLessonsTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
              Text(
                DateFormat('EEEE, d MMMM').format(DateTime.now()),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
        ),
        body: lessonsAsync.when(
          data: (data) {
            if (data.entries.isEmpty) {
              return AppEmptyView(
                title: l10n.noLessonsTodayTitle,
                message: l10n.noLessonsTodayMessage,
                icon: Icons.celebration_rounded,
              );
            }

            return Stack(
              children: [
                ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
                  physics: const BouncingScrollPhysics(),
                  itemCount: data.entries.length,
                  itemBuilder: (context, index) {
                    final entry = data.entries[index];
                    final isCurrent = data.currentEntryId == entry.id;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildLessonCard(entry, data.quarterId, isCurrent),
                    );
                  },
                ),
                if (_isStartingLesson) const AppLoadingView(),
              ],
            );
          },
          loading: () => const AppLoadingView(),
          error: (err, stack) => AppErrorView(
            message: ApiErrorHandler.readableMessage(err),
            icon: Icons.event_busy_rounded,
            onRetry: () => ref.invalidate(todayLessonsProvider),
          ),
        ),
      ),
    );
  }

  Widget _buildLessonCard(TimetableEntry entry, int quarterId, bool isCurrent) {
    final colorScheme = Theme.of(context).colorScheme;

    return PremiumCard(
      padding: const EdgeInsets.all(20),
      border: isCurrent
          ? Border.all(
              color: colorScheme.primary.withValues(alpha: 0.5),
              width: 2,
            )
          : null,
      color: isCurrent ? colorScheme.primary.withValues(alpha: 0.05) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: (isCurrent ? colorScheme.primary : Colors.white)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: (isCurrent ? colorScheme.primary : Colors.white)
                        .withValues(alpha: 0.1),
                  ),
                ),
                child: Text(
                  '#${entry.orderNumber}',
                  style: TextStyle(
                    color: isCurrent
                        ? colorScheme.primary
                        : colorScheme.onSurface.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w900,
                    fontSize: 11,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${entry.startTime.substring(0, 5)} - ${entry.endTime.substring(0, 5)}',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  color: colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ),
              const Spacer(),
              if (isCurrent) const _LivePulse(),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            entry.subjectName,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _InfoTag(
                icon: Icons.people_outline_rounded,
                label: entry.groupName,
              ),
              const SizedBox(width: 12),
              _InfoTag(icon: Icons.room_rounded, label: entry.room),
            ],
          ),
          const SizedBox(height: 24),
          AnimatedPressable(
            onTap: () => _startLesson(entry, quarterId),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                gradient: isCurrent
                    ? LinearGradient(
                        colors: [colorScheme.primary, colorScheme.secondary],
                      )
                    : null,
                color: isCurrent
                    ? null
                    : colorScheme.onSurface.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
                boxShadow: isCurrent
                    ? [
                        BoxShadow(
                          color: colorScheme.primary.withValues(alpha: 0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                context.l10n.startLessonButton,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isCurrent ? Colors.white : colorScheme.onSurface,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTag extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoTag({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: colorScheme.onSurface.withValues(alpha: 0.4),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class _LivePulse extends StatefulWidget {
  const _LivePulse();

  @override
  State<_LivePulse> createState() => _LivePulseState();
}

class _LivePulseState extends State<_LivePulse>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller.drive(CurveTween(curve: Curves.easeInOut)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: TeacherAppColors.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Row(
          children: [
            CircleAvatar(radius: 3, backgroundColor: TeacherAppColors.error),
            SizedBox(width: 6),
            Text(
              'LIVE',
              style: TextStyle(
                color: TeacherAppColors.error,
                fontSize: 10,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
