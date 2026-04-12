import '../../../core/constants/app_colors.dart';
import '../../../core/constants/liquid_glass.dart';
import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import '../../../core/network/api_error_handler.dart';
import '../../../data/models/timetable_model.dart';
import '../../providers/timetable_provider.dart';
import '../../common/page_background.dart';
import '../../common/premium_card.dart';
import '../../common/animated_pressable.dart';
import '../../widgets/app_feedback.dart';

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Only fetch 1 day for the detailed view of the selected date
    final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDay);
    final timetableAsync = ref.watch(
      timetableProvider({'date': dateStr, 'days': 1}),
    );

    return PageBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(l10n.timetableTitle, style: const TextStyle(fontWeight: FontWeight.w900)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        body: Column(
          children: [
            _buildCalendarSection(colorScheme, l10n),
            const SizedBox(height: 20),
            Expanded(
              child: timetableAsync.when(
                data: (data) {
                  final schedule = data['schedule_by_date'] as Map<String, List<TimetableEntry>>;
                  final entries = schedule[dateStr] ?? [];

                  if (entries.isEmpty) {
                    return Center(
                      child: AppEmptyView(
                        title: l10n.noLessonsOnSelectedDate,
                        icon: Icons.event_busy_rounded,
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    physics: const BouncingScrollPhysics(),
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      final entry = entries[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _TimetableEntryCard(entry: entry),
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

  Widget _buildCalendarSection(ColorScheme colorScheme, dynamic l10n) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: TableCalendar(
        firstDay: DateTime.now().subtract(const Duration(days: 365)),
        lastDay: DateTime.now().add(const Duration(days: 365)),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        calendarFormat: _calendarFormat,
        locale: l10n.intlLocaleTag,
        onFormatChanged: (format) => setState(() => _calendarFormat = format),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        startingDayOfWeek: StartingDayOfWeek.monday,
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
          leftChevronIcon: Icon(Icons.chevron_left_rounded, color: colorScheme.primary),
          rightChevronIcon: Icon(Icons.chevron_right_rounded, color: colorScheme.primary),
        ),
        calendarStyle: CalendarStyle(
          selectedDecoration: BoxDecoration(
            gradient: LinearGradient(colors: [colorScheme.primary, colorScheme.secondary]),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            ],
          ),
          todayDecoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(color: colorScheme.primary.withValues(alpha: 0.4)),
          ),
          todayTextStyle: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.w900),
          defaultTextStyle: const TextStyle(fontWeight: FontWeight.w600),
          weekendTextStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
          outsideDaysVisible: false,
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(
            color: Colors.white.withValues(alpha: 0.4),
            fontWeight: FontWeight.w900,
            fontSize: 12,
          ),
          weekendStyle: TextStyle(
            color: colorScheme.error.withValues(alpha: 0.4),
            fontWeight: FontWeight.w900,
            fontSize: 12,
          ),
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
              border: Border.all(color: colorScheme.primary.withValues(alpha: 0.2)),
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
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.groupLabelText(entry.groupNames ?? '-'),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _MetaBadge(
                      icon: Icons.access_time_filled_rounded,
                      label: '${entry.startsAt?.substring(0, 5) ?? '00:00'} - ${entry.endsAt?.substring(0, 5) ?? '00:00'}',
                    ),
                    const SizedBox(width: 12),
                    _MetaBadge(
                      icon: Icons.meeting_room_rounded,
                      label: entry.roomName != null && entry.roomName!.isNotEmpty
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
}
