import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../data/models/quiz_model.dart';
import '../../providers/quiz_provider.dart';

class TeacherQuizListScreen extends ConsumerStatefulWidget {
  const TeacherQuizListScreen({super.key});

  @override
  ConsumerState<TeacherQuizListScreen> createState() => _TeacherQuizListScreenState();
}

class _TeacherQuizListScreenState extends ConsumerState<TeacherQuizListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(teacherQuizProvider.notifier).loadQuizzes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizationsRegistry.instance;
    final state = ref.watch(teacherQuizProvider);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.quizTitle), centerTitle: true),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(TeacherRoutes.quizCreate),
        backgroundColor: TeacherAppColors.primary,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
                      const SizedBox(height: 12),
                      Text(l10n.quizLoadFailed, style: theme.textTheme.bodyLarge),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: () => ref.read(teacherQuizProvider.notifier).loadQuizzes(),
                        icon: const Icon(Icons.refresh, size: 18),
                        label: Text(l10n.retry),
                      ),
                    ],
                  ),
                )
              : state.quizzes.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.quiz_outlined, size: 56, color: TeacherAppColors.slate400),
                          const SizedBox(height: 12),
                          Text(l10n.quizEmpty, style: theme.textTheme.bodyLarge?.copyWith(color: TeacherAppColors.slate500)),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () async => ref.read(teacherQuizProvider.notifier).loadQuizzes(),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: state.quizzes.length,
                        itemBuilder: (context, index) => _TeacherQuizCard(
                          quiz: state.quizzes[index],
                          isDark: isDark,
                        ),
                      ),
                    ),
    );
  }
}

class _TeacherQuizCard extends ConsumerWidget {
  final TeacherQuizModel quiz;
  final bool isDark;

  const _TeacherQuizCard({required this.quiz, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizationsRegistry.instance;

    return GestureDetector(
      onTap: () => context.push(TeacherRoutes.quizResultsPath(quiz.id)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.06)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.04),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: quiz.isActive
                          ? [TeacherAppColors.skyBlue500, TeacherAppColors.skyBlue600]
                          : [TeacherAppColors.slate300, TeacherAppColors.slate400],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.quiz_rounded, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(quiz.title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                      if (quiz.subjectName != null)
                        Text(quiz.subjectName!, style: theme.textTheme.bodySmall?.copyWith(color: TeacherAppColors.slate500)),
                    ],
                  ),
                ),
                Switch(
                  value: quiz.isActive,
                  onChanged: (_) => ref.read(teacherQuizProvider.notifier).toggleActive(quiz.id),
                  activeColor: TeacherAppColors.success,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.people_outline_rounded, size: 14, color: TeacherAppColors.slate400),
                const SizedBox(width: 4),
                Text(
                  '${quiz.attemptsCount} ${l10n.quizAttempts}',
                  style: theme.textTheme.bodySmall?.copyWith(color: TeacherAppColors.slate500),
                ),
                if (quiz.timeLimitMinutes != null) ...[
                  const SizedBox(width: 16),
                  Icon(Icons.timer_outlined, size: 14, color: TeacherAppColors.slate400),
                  const SizedBox(width: 4),
                  Text(
                    '${quiz.timeLimitMinutes} min',
                    style: theme.textTheme.bodySmall?.copyWith(color: TeacherAppColors.slate500),
                  ),
                ],
                const SizedBox(width: 16),
                Icon(Icons.star_outline_rounded, size: 14, color: TeacherAppColors.slate400),
                const SizedBox(width: 4),
                Text(
                  '${quiz.maxScore} ${l10n.quizPoints}',
                  style: theme.textTheme.bodySmall?.copyWith(color: TeacherAppColors.slate500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
