import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:teacher_school_app/core/localization/l10n_extension.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/network/api_error_handler.dart';
import '../../providers/assessment_provider.dart';
import '../../widgets/app_feedback.dart';
import '../../widgets/common/page_background.dart';
import '../../widgets/common/premium_card.dart';

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

  Future<void> _saveResults() async {
    final l10n = context.l10n;
    final success = await ref
        .read(assessmentControllerProvider.notifier)
        .saveResults(widget.assessmentId, _scores, _comments);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.assessmentResultsSaved),
          backgroundColor: TeacherAppColors.success,
        ),
      );
      ref.invalidate(assessmentResultsProvider(widget.assessmentId));
    } else {
      final state = ref.read(assessmentControllerProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ApiErrorHandler.readableMessage(state.error)),
          backgroundColor: TeacherAppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final resultsAsync = ref.watch(
      assessmentResultsProvider(widget.assessmentId),
    );
    final controllerState = ref.watch(assessmentControllerProvider);

    return PageBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => context.pop(),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                onTap: controllerState.isLoading ? null : _saveResults,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: controllerState.isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: colorScheme.primary,
                          ),
                        )
                      : Text(
                          l10n.saveAction,
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: colorScheme.primary,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
        body: resultsAsync.when(
          data: (data) {
            final results = (data['results'] as List?) ?? const [];

            if (results.isEmpty) {
              return Center(
                child: AppEmptyView(
                  title: l10n.assessmentNoStudents,
                  message: l10n.assessmentNoStudents,
                  icon: Icons.group_off_rounded,
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
              itemCount: results.length,
              itemBuilder: (context, index) {
                final res = results[index];
                final key = res.studentId.toString();
                _scores.putIfAbsent(key, () => res.score as num?);
                _comments.putIfAbsent(key, () => res.comment as String?);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: PremiumCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: colorScheme.secondary.withValues(
                                  alpha: 0.1,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  res.studentName.toString().isNotEmpty
                                      ? res.studentName
                                            .toString()[0]
                                            .toUpperCase()
                                      : 'S',
                                  style: TextStyle(
                                    color: colorScheme.secondary,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                res.studentName.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: _InputField(
                                label: l10n.assessmentScoreLabel,
                                initialValue: _scores[key]?.toString() ?? '',
                                hint: l10n.assessmentScoreHint,
                                keyboardType: TextInputType.number,
                                onChanged: (val) {
                                  _scores[key] = num.tryParse(val);
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 5,
                              child: _InputField(
                                label: l10n.assessmentCommentLabel,
                                initialValue: _comments[key] ?? '',
                                hint: l10n.assessmentCommentHintEmpty,
                                onChanged: (val) {
                                  _comments[key] = val.trim().isEmpty
                                      ? null
                                      : val.trim();
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final String initialValue;
  final String hint;
  final TextInputType? keyboardType;
  final ValueChanged<String> onChanged;

  const _InputField({
    required this.label,
    required this.initialValue,
    required this.hint,
    this.keyboardType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.45),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: initialValue,
          keyboardType: keyboardType,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
