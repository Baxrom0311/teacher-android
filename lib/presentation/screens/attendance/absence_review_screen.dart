import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:teacher_school_app/l10n/app_localizations.dart';
import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import '../../../core/network/api_error_handler.dart';
import '../../providers/attendance_provider.dart';
import '../../widgets/app_feedback.dart';

class AbsenceReviewScreen extends ConsumerStatefulWidget {
  const AbsenceReviewScreen({super.key});

  @override
  ConsumerState<AbsenceReviewScreen> createState() =>
      _AbsenceReviewScreenState();
}

class _AbsenceReviewScreenState extends ConsumerState<AbsenceReviewScreen> {
  String? _selectedStatus = 'pending';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final excusesAsync = ref.watch(absenceExcusesProvider(_selectedStatus));

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.absenceReviewTitle),
        backgroundColor:
            theme.appBarTheme.backgroundColor ?? colorScheme.surface,
        foregroundColor:
            theme.appBarTheme.foregroundColor ?? colorScheme.onSurface,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SegmentedButton<String?>(
              segments: [
                ButtonSegment(
                  value: 'pending',
                  label: Text(l10n.absenceStatusLabel('pending')),
                ),
                ButtonSegment(
                  value: 'approved',
                  label: Text(l10n.absenceStatusLabel('approved')),
                ),
                ButtonSegment(
                  value: 'rejected',
                  label: Text(l10n.absenceStatusLabel('rejected')),
                ),
              ],
              selected: {_selectedStatus},
              onSelectionChanged: (set) =>
                  setState(() => _selectedStatus = set.first),
            ),
          ),
          Expanded(
            child: excusesAsync.when(
              data: (excuses) => excuses.isEmpty
                  ? AppEmptyView(
                      message: l10n.absenceReviewEmptyMessage,
                      icon: Icons.fact_check_outlined,
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: excuses.length,
                      itemBuilder: (context, index) {
                        final excuse = excuses[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          color: theme.cardColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: colorScheme.outline.withValues(alpha: 0.7),
                            ),
                          ),
                          child: ExpansionTile(
                            title: Text(excuse['student']['name']),
                            subtitle: Text(
                              l10n.absenceDateLabel(excuse['excuse_date']),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.absenceReasonLabel(excuse['reason']),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    if (_selectedStatus == 'pending')
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            onPressed: () => _review(
                                              excuse['id'],
                                              'rejected',
                                            ),
                                            style: TextButton.styleFrom(
                                              foregroundColor: Colors.red,
                                            ),
                                            child: Text(l10n.rejectAction),
                                          ),
                                          const SizedBox(width: 8),
                                          ElevatedButton(
                                            onPressed: () => _review(
                                              excuse['id'],
                                              'approved',
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green,
                                              foregroundColor: Colors.white,
                                            ),
                                            child: Text(l10n.approveAction),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
              loading: () => AppLoadingView(
                title: l10n.absenceReviewLoadingTitle,
                subtitle: l10n.absenceReviewLoadingSubtitle,
              ),
              error: (err, stack) => AppErrorView(
                title: l10n.absenceReviewLoadErrorTitle,
                message: ApiErrorHandler.readableMessage(err),
                icon: Icons.fact_check_outlined,
                onRetry: () =>
                    ref.invalidate(absenceExcusesProvider(_selectedStatus)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _review(int id, String status) async {
    final l10n = context.l10n;
    final success = await ref
        .read(absenceReviewControllerProvider.notifier)
        .review(id, status);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            status == 'approved'
                ? l10n.absenceApprovedSuccess
                : l10n.absenceRejectedSuccess,
          ),
        ),
      );
    }
  }
}
