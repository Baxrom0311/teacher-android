import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import 'package:teacher_school_app/l10n/app_localizations.dart';
import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import '../../../core/network/api_error_handler.dart';
import '../../providers/attendance_provider.dart';
import '../../widgets/app_feedback.dart';

class AttendanceCreateScreen extends ConsumerStatefulWidget {
  const AttendanceCreateScreen({super.key});

  @override
  ConsumerState<AttendanceCreateScreen> createState() =>
      _AttendanceCreateScreenState();
}

class _AttendanceCreateScreenState
    extends ConsumerState<AttendanceCreateScreen> {
  // In a real flow, a user would pick a Date and TimetableEntry first
  // Here we assume it's pre-populated or they select it via dialogs

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final optionsAsync = ref.watch(attendanceOptionsProvider);
    final attendanceState = ref.watch(attendanceControllerProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.attendanceCreateTitle),
        backgroundColor:
            theme.appBarTheme.backgroundColor ?? colorScheme.surface,
        foregroundColor:
            theme.appBarTheme.foregroundColor ?? colorScheme.onSurface,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: attendanceState.isLoading
                ? null
                : () {
                    // Mock save for UI demonstration
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.attendanceCreateSavePendingMessage),
                      ),
                    );
                    context.pop();
                  },
            child: attendanceState.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    l10n.saveAction,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
          ),
        ],
      ),
      body: optionsAsync.when(
        data: (options) {
          // If we had fetched rows, we would map them here. Currently just placeholder UI.
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: 5, // Mock 5 students
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return _buildStudentRow(
                l10n.attendanceMockStudentLabel(index + 1),
                options,
                'present', // Mock status
              );
            },
          );
        },
        loading: () => AppLoadingView(
          title: l10n.attendanceOptionsLoadingTitle,
          subtitle: l10n.attendanceOptionsLoadingSubtitle,
        ),
        error: (err, stack) => AppErrorView(
          title: l10n.attendanceOptionsLoadErrorTitle,
          message: ApiErrorHandler.readableMessage(err),
          icon: Icons.fact_check_outlined,
          onRetry: () => ref.invalidate(attendanceOptionsProvider),
        ),
      ),
    );
  }

  Widget _buildStudentRow(
    String name,
    List<dynamic> options,
    String currentStatus,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: options.map((opt) {
              // Use proper color mapping based on status
              Color statusColor = TeacherAppColors.textSecondary;
              if (opt.value == 'present') {
                statusColor = TeacherAppColors.present;
              }
              if (opt.value == 'absent') statusColor = TeacherAppColors.absent;
              if (opt.value == 'late') statusColor = TeacherAppColors.late;
              if (opt.value == 'excused') {
                statusColor = TeacherAppColors.excused;
              }

              final isSelected = currentStatus == opt.value;

              return ChoiceChip(
                label: Text(opt.label),
                selected: isSelected,
                selectedColor: statusColor.withValues(alpha: 0.2),
                labelStyle: TextStyle(
                  color: isSelected
                      ? statusColor
                      : colorScheme.onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                onSelected: (selected) {
                  // Connect to controller updateRow logic in prod
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
