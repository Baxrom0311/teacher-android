import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import '../../../core/network/api_error_handler.dart';
import '../../providers/assessment_provider.dart';
import '../../widgets/app_feedback.dart';

class AssessmentResultsScreen extends ConsumerStatefulWidget {
  final int assessmentId;
  final String title;

  const AssessmentResultsScreen({
    super.key,
    required this.assessmentId,
    required this.title,
  });

  @override
  ConsumerState<AssessmentResultsScreen> createState() =>
      _AssessmentResultsScreenState();
}

class _AssessmentResultsScreenState
    extends ConsumerState<AssessmentResultsScreen> {
  final Map<String, num?> _scores = {};
  final Map<String, String?> _comments = {};

  void _saveResults() async {
    final l10n = context.l10n;
    final success = await ref
        .read(assessmentControllerProvider.notifier)
        .saveResults(widget.assessmentId, _scores, _comments);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.assessmentResultsSaved),
          backgroundColor: TeacherAppColors.success,
        ),
      );
      ref.invalidate(assessmentResultsProvider(widget.assessmentId));
    } else if (mounted) {
      final state = ref.read(assessmentControllerProvider);
      final errorMsg = ApiErrorHandler.readableMessage(state.error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg),
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
    final resultsAsync = ref.watch(
      assessmentResultsProvider(widget.assessmentId),
    );
    final state = ref.watch(assessmentControllerProvider);
    final isLoading = state.isLoading;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor:
            theme.appBarTheme.backgroundColor ?? colorScheme.surface,
        foregroundColor:
            theme.appBarTheme.foregroundColor ?? colorScheme.onSurface,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: isLoading ? null : _saveResults,
            child: isLoading
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
      body: resultsAsync.when(
        data: (data) {
          final results = data['results'] as List;

          if (results.isEmpty) {
            return Center(
              child: Text(
                l10n.assessmentNoStudents,
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: results.length,
            itemBuilder: (context, index) {
              final res = results[index];
              final sId = res.studentId.toString();

              // Initialize map values from API if not edited yet
              if (!_scores.containsKey(sId)) {
                _scores[sId] = res.score;
                _comments[sId] = res.comment;
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colorScheme.outline),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      res.studentName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                          l10n.assessmentScoreLabel,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            initialValue: _scores[sId]?.toString() ?? '',
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: l10n.assessmentScoreHint,
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            onChanged: (val) {
                              _scores[sId] = num.tryParse(val);
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          l10n.assessmentCommentLabel,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            initialValue: _comments[sId] ?? '',
                            decoration: InputDecoration(
                              hintText: l10n.assessmentCommentHintEmpty,
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            onChanged: (val) {
                              _comments[sId] = val.trim().isEmpty
                                  ? null
                                  : val.trim();
                            },
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
        error: (err, stack) => AppErrorView(
          message: ApiErrorHandler.readableMessage(err),
          icon: Icons.assignment_outlined,
        ),
      ),
    );
  }
}
