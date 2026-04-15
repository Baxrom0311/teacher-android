import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../providers/quiz_provider.dart';

class QuizResultsScreen extends ConsumerStatefulWidget {
  final int quizId;

  const QuizResultsScreen({super.key, required this.quizId});

  @override
  ConsumerState<QuizResultsScreen> createState() => _QuizResultsScreenState();
}

class _QuizResultsScreenState extends ConsumerState<QuizResultsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(quizResultsProvider.notifier).loadResults(widget.quizId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizationsRegistry.instance;
    final state = ref.watch(quizResultsProvider);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.quizResultsTitle), centerTitle: true),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
              ? Center(child: Text(l10n.quizLoadFailed))
              : state.results == null
                  ? const SizedBox.shrink()
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        // Summary stats
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [TeacherAppColors.skyBlue500, TeacherAppColors.skyBlue600],
                            ),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _SummaryItem(
                                value: '${state.results!.totalAttempts}',
                                label: l10n.quizAttempts,
                              ),
                              _SummaryItem(
                                value: state.results!.avgScore.toStringAsFixed(1),
                                label: l10n.quizAvgScore,
                              ),
                              _SummaryItem(
                                value: '${state.results!.avgPercent.toStringAsFixed(0)}%',
                                label: l10n.quizAvgPercent,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          l10n.quizStudentResults,
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 12),
                        ...state.results!.attempts.map((a) => Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: theme.cardColor,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: theme.colorScheme.outline.withValues(alpha: 0.06),
                                ),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundColor: TeacherAppColors.skyBlue50,
                                    child: Text(
                                      (a.studentName ?? '?')[0].toUpperCase(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: TeacherAppColors.skyBlue600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          a.studentName ?? '',
                                          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          '${a.score}/${a.maxScore}',
                                          style: theme.textTheme.bodySmall?.copyWith(color: TeacherAppColors.slate500),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: _scoreColor(a.percent).withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      '${a.percent.toStringAsFixed(0)}%',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800,
                                        color: _scoreColor(a.percent),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
    );
  }

  Color _scoreColor(double percent) {
    if (percent >= 80) return TeacherAppColors.success;
    if (percent >= 60) return TeacherAppColors.skyBlue600;
    if (percent >= 40) return TeacherAppColors.warning;
    return TeacherAppColors.danger;
  }
}

class _SummaryItem extends StatelessWidget {
  final String value;
  final String label;

  const _SummaryItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.8)),
        ),
      ],
    );
  }
}
