import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/localization/l10n_extension.dart';
import '../../../data/models/class_journal_model.dart';
import '../../providers/class_journal_provider.dart';

/// Sinf Jurnali — o'qituvchi uchun kundalik ko'rinishi
class ClassJournalScreen extends ConsumerStatefulWidget {
  final int groupId;
  final String? groupName;

  const ClassJournalScreen({
    super.key,
    required this.groupId,
    this.groupName,
  });

  @override
  ConsumerState<ClassJournalScreen> createState() =>
      _ClassJournalScreenState();
}

class _ClassJournalScreenState extends ConsumerState<ClassJournalScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(classJournalProvider.notifier)
          .loadJournal(widget.groupId);
    });
  }

  Future<void> _pickDate() async {
    final state = ref.read(classJournalProvider);
    final current = DateTime.tryParse(state.selectedDate) ?? DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(2024),
      lastDate: DateTime.now().add(const Duration(days: 7)),
    );

    if (picked != null) {
      final dateStr =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      ref
          .read(classJournalProvider.notifier)
          .changeDate(widget.groupId, dateStr);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(classJournalProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(widget.groupName ?? l10n.classJournalTitle),
        backgroundColor:
            theme.appBarTheme.backgroundColor ?? colorScheme.surface,
        foregroundColor:
            theme.appBarTheme.foregroundColor ?? colorScheme.onSurface,
        elevation: 0,
        actions: [
          // Date picker button
          IconButton(
            onPressed: _pickDate,
            icon: const Icon(Icons.calendar_today_rounded),
            tooltip: l10n.classJournalSelectDate,
          ),
        ],
      ),
      body: Column(
        children: [
          // Date header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            color: colorScheme.primary.withValues(alpha: 0.06),
            child: Row(
              children: [
                Icon(Icons.calendar_month_rounded,
                    size: 18, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  _formatDisplayDate(state.selectedDate, l10n),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.primary,
                    fontSize: 15,
                  ),
                ),
                const Spacer(),
                if (state.journal != null)
                  Text(
                    l10n.classJournalStudentCount(
                        state.journal!.students.length),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                      fontSize: 13,
                    ),
                  ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: _buildBody(state, theme, colorScheme, l10n),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(
    ClassJournalState state,
    ThemeData theme,
    ColorScheme colorScheme,
    dynamic l10n,
  ) {
    if (state.isLoading && state.journal == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.journal == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline,
                color: TeacherAppColors.danger, size: 48),
            const SizedBox(height: 12),
            Text(state.error!,
                style: TextStyle(color: colorScheme.onSurface),
                textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () => ref
                  .read(classJournalProvider.notifier)
                  .loadJournal(widget.groupId),
              icon: const Icon(Icons.refresh, size: 18),
              label: Text(l10n.retry),
            ),
          ],
        ),
      );
    }

    final students = state.journal?.students ?? [];
    if (students.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.people_outline_rounded,
                size: 64,
                color: colorScheme.primary.withValues(alpha: 0.3)),
            const SizedBox(height: 16),
            Text(l10n.classJournalEmpty,
                style: TextStyle(
                    fontSize: 16,
                    color: colorScheme.onSurface.withValues(alpha: 0.6))),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: students.length,
      itemBuilder: (context, index) {
        return _StudentJournalCard(student: students[index]);
      },
    );
  }

  String _formatDisplayDate(String dateStr, dynamic l10n) {
    final parsed = DateTime.tryParse(dateStr);
    if (parsed == null) return dateStr;
    return DateFormat('d MMMM, EEEE', l10n.intlLocaleTag).format(parsed);
  }
}

// ═══════════════════════════════════════════════════════════════
// Student Journal Card
// ═══════════════════════════════════════════════════════════════

class _StudentJournalCard extends StatelessWidget {
  final ClassJournalStudent student;

  const _StudentJournalCard({required this.student});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Student header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor:
                      colorScheme.primary.withValues(alpha: 0.1),
                  child: Text(
                    student.studentName.isNotEmpty
                        ? student.studentName[0].toUpperCase()
                        : '?',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: colorScheme.primary,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    student.studentName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
                // Summary chips
                ..._buildSummaryChips(student.lessons),
              ],
            ),
          ),

          // Lessons
          if (student.lessons.isNotEmpty) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Column(
                children: student.lessons
                    .map((lesson) => _JournalLessonRow(lesson: lesson))
                    .toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildSummaryChips(List<ClassJournalLesson> lessons) {
    final grades = lessons.where((l) => l.grade != null).toList();
    final absent =
        lessons.where((l) => l.attStatus == 'A').length;

    final chips = <Widget>[];

    if (grades.isNotEmpty) {
      final avg = grades.map((g) => g.grade!).reduce((a, b) => a + b) /
          grades.length;
      chips.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: _gradeColor(avg).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            avg.toStringAsFixed(1),
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 13,
              color: _gradeColor(avg),
            ),
          ),
        ),
      );
    }

    if (absent > 0) {
      chips.add(const SizedBox(width: 6));
      chips.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: TeacherAppColors.danger.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cancel_outlined,
                  size: 12, color: TeacherAppColors.danger),
              const SizedBox(width: 3),
              Text(
                '$absent',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                  color: TeacherAppColors.danger,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return chips;
  }

  Color _gradeColor(double grade) {
    if (grade >= 4.5) return TeacherAppColors.success;
    if (grade >= 3.5) return TeacherAppColors.skyBlue500;
    if (grade >= 2.5) return TeacherAppColors.warning;
    return TeacherAppColors.danger;
  }
}

class _JournalLessonRow extends StatelessWidget {
  final ClassJournalLesson lesson;

  const _JournalLessonRow({required this.lesson});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          // Subject
          Expanded(
            flex: 3,
            child: Text(
              lesson.subject ?? '—',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ),

          // Attendance
          if (lesson.attStatus != null)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: _attColor(lesson.attStatus!).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                _attIcon(lesson.attStatus!),
                size: 14,
                color: _attColor(lesson.attStatus!),
              ),
            ),

          const SizedBox(width: 8),

          // Grade
          SizedBox(
            width: 32,
            child: lesson.grade != null
                ? Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: _gradeColor(lesson.grade!)
                          .withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        lesson.grade!.toInt().toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                          color: _gradeColor(lesson.grade!),
                        ),
                      ),
                    ),
                  )
                : const Text('—',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: TeacherAppColors.slate400)),
          ),
        ],
      ),
    );
  }

  Color _attColor(String status) => switch (status) {
        'P' => TeacherAppColors.success,
        'A' => TeacherAppColors.danger,
        'L' => TeacherAppColors.amber,
        'E' => TeacherAppColors.skyBlue500,
        _ => TeacherAppColors.slate400,
      };

  IconData _attIcon(String status) => switch (status) {
        'P' => Icons.check_circle_outline_rounded,
        'A' => Icons.cancel_outlined,
        'L' => Icons.access_time_rounded,
        'E' => Icons.verified_outlined,
        _ => Icons.help_outline_rounded,
      };

  Color _gradeColor(double grade) {
    if (grade >= 4.5) return TeacherAppColors.success;
    if (grade >= 3.5) return TeacherAppColors.skyBlue500;
    if (grade >= 2.5) return TeacherAppColors.warning;
    return TeacherAppColors.danger;
  }
}
