import '../../../core/constants/app_colors.dart';
import '../../../core/constants/liquid_glass.dart';
import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/network/api_error_handler.dart';
import '../../providers/attendance_provider.dart';
import '../../widgets/app_feedback.dart';
import '../../common/page_background.dart';
import '../../common/premium_card.dart';
import '../../common/animated_pressable.dart';

class AttendanceCreateScreen extends ConsumerStatefulWidget {
  const AttendanceCreateScreen({super.key});

  @override
  ConsumerState<AttendanceCreateScreen> createState() =>
      _AttendanceCreateScreenState();
}

class _AttendanceCreateScreenState
    extends ConsumerState<AttendanceCreateScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final optionsAsync = ref.watch(attendanceOptionsProvider);
    final attendanceState = ref.watch(attendanceControllerProvider);
    final students = ref.watch(attendanceStudentsProvider);
    final isLoading = false;

    return PageBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(l10n.attendanceCreateTitle, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        body: optionsAsync.when(
          data: (options) => Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    _buildBulkAction(l10n.attendanceAllPresent, TeacherAppColors.present, () => _markAll('present')),
                    const SizedBox(width: 8),
                    _buildBulkAction(l10n.attendanceAllAbsent, TeacherAppColors.absent, () => _markAll('absent')),
                  ],
                ),
              ),
              Expanded(
                child: students.isEmpty
                    ? Center(child: AppEmptyView(message: l10n.attendanceNoStudents, icon: Icons.group_off_rounded))
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                        physics: const BouncingScrollPhysics(),
                        itemCount: students.length,
                        itemBuilder: (context, index) {
                          final student = students[index];
                          final currentStatus = attendanceState[student.id.toString()] ?? 'present';
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildStudentRow(student.name, options, currentStatus, student.id),
                          );
                        },
                      ),
              ),
            ],
          ),
          loading: () => const AppLoadingView(),
          error: (err, stack) => AppErrorView(message: ApiErrorHandler.readableMessage(err), icon: Icons.group_add_rounded),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: AnimatedPressable(
          onTap: isLoading ? null : _submit,
          child: Container(
            height: 56,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [colorScheme.primary, colorScheme.secondary]),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [BoxShadow(color: colorScheme.primary.withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 8))],
            ),
            child: Center(
              child: isLoading
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white))
                  : Text(l10n.saveAction.toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 1.5)),
            ),
          ),
        ),
      ),
    );
  }

  void _markAll(String status) {
    // Implementation for marking all students
  }

  void _submit() {
    // Implementation for submitting attendance
  }

  Widget _buildBulkAction(String label, Color color, VoidCallback onTap) {
    return Expanded(
      child: AnimatedPressable(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 12),
          ),
        ),
      ),
    );
  }


  Widget _buildStudentRow(
    String name,
    dynamic options,
    String currentStatus,
    int studentId,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final opts = options['options'] as List;

    return PremiumCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _AvatarSmall(name: name),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                ),
              ),
              if (currentStatus == 'excused')
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: TeacherAppColors.excused.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                  child: const Text('EXCUSED', style: TextStyle(color: TeacherAppColors.excused, fontSize: 10, fontWeight: FontWeight.w900)),
                ),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: opts.map((opt) {
                Color statusColor = colorScheme.onSurface.withValues(alpha: 0.4);
                if (opt.value == 'present') statusColor = TeacherAppColors.present;
                if (opt.value == 'absent') statusColor = TeacherAppColors.absent;
                if (opt.value == 'late') statusColor = TeacherAppColors.late;
                if (opt.value == 'excused') statusColor = TeacherAppColors.excused;

                final isSelected = currentStatus == opt.value;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: AnimatedPressable(
                    onTap: () {
                      // Status change logic
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? statusColor.withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: isSelected ? statusColor.withValues(alpha: 0.3) : Colors.transparent),
                      ),
                      child: Text(
                        opt.label,
                        style: TextStyle(color: isSelected ? statusColor : colorScheme.onSurface.withValues(alpha: 0.4), fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600, fontSize: 12),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarSmall extends StatelessWidget {
  final String name;
  const _AvatarSmall({required this.name});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : 'S',
          style: TextStyle(
            color: colorScheme.primary,
            fontWeight: FontWeight.w900,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
