import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:teacher_school_app/core/localization/l10n_extension.dart';

import '../../../core/network/api_error_handler.dart';
import '../../../data/models/timetable_model.dart';
import '../../providers/timetable_provider.dart';
import '../../widgets/app_feedback.dart';
import '../../widgets/common/page_background.dart';
import '../../widgets/common/premium_card.dart';

class TimetableScreen extends ConsumerStatefulWidget {
  const TimetableScreen({super.key});

  @override
  ConsumerState<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends ConsumerState<TimetableScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.week;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDay);
    final timetableAsync = ref.watch(
      timetableProvider({'date': dateStr, 'days': 1}),
    );

    return PageBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            l10n.timetableTitle,
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        body: Column(
          children: [
            _CalendarSection(
              focusedDay: _focusedDay,
              selectedDay: _selectedDay,
              calendarFormat: _calendarFormat,
              localeTag: l10n.intlLocaleTag,
              onFormatChanged: (format) {
                setState(() => _calendarFormat = format);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: timetableAsync.when(
                data: (data) {
                  final schedule =
                      data['schedule_by_date']
                          as Map<String, List<TimetableEntry>>;
                  final entries = schedule[dateStr] ?? const [];

                  if (entries.isEmpty) {
                    return Center(
                      child: AppEmptyView(
                        title: l10n.noLessonsOnSelectedDate,
                        message: l10n.noLessonsOnSelectedDate,
                        icon: Icons.event_busy_rounded,
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    physics: const BouncingScrollPhysics(),
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _TimetableEntryCard(entry: entries[index]),
                      );
                    },
                  );
                },
                loading: () => const AppLoadingView(),
                error: (err, stack) => AppErrorView(
                  message: ApiErrorHandler.readableMessage(err),
                  icon: Icons.event_note_rounded,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CalendarSection extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime selectedDay;
  final CalendarFormat calendarFormat;
  final String localeTag;
  final ValueChanged<CalendarFormat> onFormatChanged;
  final void Function(DateTime selectedDay, DateTime focusedDay) onDaySelected;

  const _CalendarSection({
    required this.focusedDay,
    required this.selectedDay,
    required this.calendarFormat,
    required this.localeTag,
    required this.onFormatChanged,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: TableCalendar(
        firstDay: DateTime.now().subtract(const Duration(days: 365)),
        lastDay: DateTime.now().add(const Duration(days: 365)),
        focusedDay: focusedDay,
        selectedDayPredicate: (day) => isSameDay(selectedDay, day),
        calendarFormat: calendarFormat,
        locale: localeTag,
        onFormatChanged: onFormatChanged,
        onDaySelected: onDaySelected,
        startingDayOfWeek: StartingDayOfWeek.monday,
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 16,
          ),
          leftChevronIcon: Icon(
            Icons.chevron_left_rounded,
            color: colorScheme.primary,
          ),
          rightChevronIcon: Icon(
            Icons.chevron_right_rounded,
            color: colorScheme.primary,
          ),
        ),
        calendarStyle: CalendarStyle(
          selectedDecoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colorScheme.primary, colorScheme.secondary],
            ),
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.4),
            ),
          ),
          todayTextStyle: TextStyle(
            color: colorScheme.primary,
            fontWeight: FontWeight.w900,
          ),
          defaultTextStyle: const TextStyle(fontWeight: FontWeight.w600),
          weekendTextStyle: TextStyle(
            color: colorScheme.error.withValues(alpha: 0.45),
          ),
          outsideDaysVisible: false,
        ),
      ),
    );
  }
}

class _TimetableEntryCard extends StatelessWidget {
  final TimetableEntry entry;

  const _TimetableEntryCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    return PremiumCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Center(
              child: Text(
                '${entry.lessonNo ?? '-'}',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.subjectName ?? l10n.unknownSubjectFallback,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.groupLabelText(entry.groupNames ?? '-'),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface.withValues(alpha: 0.45),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _MetaBadge(
                      icon: Icons.access_time_filled_rounded,
                      label:
                          '${entry.startsAt?.substring(0, 5) ?? '00:00'} - ${entry.endsAt?.substring(0, 5) ?? '00:00'}',
                    ),
                    const SizedBox(width: 12),
                    _MetaBadge(
                      icon: Icons.meeting_room_rounded,
                      label: entry.roomName?.isNotEmpty == true
                          ? entry.roomName!
                          : '-',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 14, color: colorScheme.primary.withValues(alpha: 0.6)),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}
