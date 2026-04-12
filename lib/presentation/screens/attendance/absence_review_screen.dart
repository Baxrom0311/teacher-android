import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import '../../../core/network/api_error_handler.dart';
import '../../providers/attendance_provider.dart';
import '../../widgets/app_feedback.dart';
import '../../widgets/common/page_background.dart';
import '../../widgets/common/premium_card.dart';
import '../../widgets/common/animated_pressable.dart';

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
    final excusesAsync = ref.watch(absenceExcusesProvider(_selectedStatus));

    return PageBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            l10n.absenceReviewTitle,
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  _StatusSegment(
                    label: l10n.absenceStatusLabel('pending'),
                    isSelected: _selectedStatus == 'pending',
                    onTap: () => setState(() => _selectedStatus = 'pending'),
                    color: TeacherAppColors.late,
                  ),
                  const SizedBox(width: 8),
                  _StatusSegment(
                    label: l10n.absenceStatusLabel('approved'),
                    isSelected: _selectedStatus == 'approved',
                    onTap: () => setState(() => _selectedStatus = 'approved'),
                    color: TeacherAppColors.success,
                  ),
                  const SizedBox(width: 8),
                  _StatusSegment(
                    label: l10n.absenceStatusLabel('rejected'),
                    isSelected: _selectedStatus == 'rejected',
                    onTap: () => setState(() => _selectedStatus = 'rejected'),
                    color: TeacherAppColors.error,
                  ),
                ],
              ),
            ),
            Expanded(
              child: excusesAsync.when(
                data: (excuses) => excuses.isEmpty
                    ? AppEmptyView(
                        message: l10n.absenceReviewEmptyMessage,
                        icon: Icons.fact_check_rounded,
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                        physics: const BouncingScrollPhysics(),
                        itemCount: excuses.length,
                        itemBuilder: (context, index) {
                          final excuse = excuses[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _AbsenceExcuseCard(
                              excuse: excuse,
                              selectedStatus: _selectedStatus,
                              onReview: (status) =>
                                  _review(excuse['id'], status),
                            ),
                          );
                        },
                      ),
                loading: () => const AppLoadingView(),
                error: (err, stack) => AppErrorView(
                  message: ApiErrorHandler.readableMessage(err),
                  icon: Icons.fact_check_rounded,
                  onRetry: () =>
                      ref.invalidate(absenceExcusesProvider(_selectedStatus)),
                ),
              ),
            ),
          ],
        ),
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

class _StatusSegment extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color color;

  const _StatusSegment({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimatedPressable(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withValues(alpha: 0.15)
                : Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? color.withValues(alpha: 0.3)
                  : Colors.transparent,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? color : Colors.white.withValues(alpha: 0.4),
              fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}

class _AbsenceExcuseCard extends StatelessWidget {
  final dynamic excuse;
  final String? selectedStatus;
  final Function(String) onReview;

  const _AbsenceExcuseCard({
    required this.excuse,
    required this.selectedStatus,
    required this.onReview,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_search_rounded,
                  color: colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      excuse['student']['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      excuse['excuse_date'] ?? '',
                      style: TextStyle(
                        fontSize: 13,
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              excuse['reason'] ?? '',
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurface.withValues(alpha: 0.8),
                height: 1.4,
              ),
            ),
          ),
          if (selectedStatus == 'pending') ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: AnimatedPressable(
                    onTap: () => onReview('rejected'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: TeacherAppColors.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        l10n.rejectAction.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: TeacherAppColors.error,
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AnimatedPressable(
                    onTap: () => onReview('approved'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: TeacherAppColors.success.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: TeacherAppColors.success.withValues(
                            alpha: 0.2,
                          ),
                        ),
                      ),
                      child: Text(
                        l10n.approveAction.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: TeacherAppColors.success,
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
