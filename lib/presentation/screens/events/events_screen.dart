import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import 'package:teacher_school_app/l10n/app_localizations.dart';
import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import '../../../core/network/api_error_handler.dart';
import '../../../data/models/event_model.dart';
import '../../providers/event_provider.dart';
import '../../widgets/app_feedback.dart';

class EventsScreen extends ConsumerWidget {
  const EventsScreen({super.key});

  Future<void> _refresh(WidgetRef ref) async {
    ref.invalidate(eventsProvider);
    await ref.read(eventsProvider.future);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final eventsAsync = ref.watch(eventsProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.eventsMenuTitle),
        backgroundColor:
            theme.appBarTheme.backgroundColor ?? colorScheme.surface,
        foregroundColor:
            theme.appBarTheme.foregroundColor ?? colorScheme.onSurface,
        elevation: 0,
      ),
      body: eventsAsync.when(
        data: (data) {
          return RefreshIndicator(
            onRefresh: () => _refresh(ref),
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: data.events.isEmpty ? 1 : data.events.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                if (data.events.isEmpty) {
                  return SizedBox(
                    height: 360,
                    child: AppEmptyView(
                      title: l10n.eventsEmptyTitle,
                      message: l10n.eventsEmptyMessage,
                      icon: Icons.event_busy_outlined,
                    ),
                  );
                }

                return _EventCard(event: data.events[index]);
              },
            ),
          );
        },
        loading: () => AppLoadingView(
          title: l10n.eventsLoadingTitle,
          subtitle: l10n.eventsLoadingSubtitle,
        ),
        error: (error, stack) => AppErrorView(
          title: l10n.eventsLoadErrorTitle,
          message: ApiErrorHandler.readableMessage(error),
          icon: Icons.event_busy_outlined,
          onRetry: () => ref.invalidate(eventsProvider),
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final SchoolEventData event;

  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final chipColor = _typeColor(event.type);
    final rangeText = _formatDateRange(event, l10n);
    final timeText = _formatTimeRange(event);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  event.title.isNotEmpty
                      ? event.title
                      : l10n.eventFallbackTitle,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: chipColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  l10n.eventsTypeLabel(event.type),
                  style: TextStyle(
                    color: chipColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _MetaRow(icon: Icons.calendar_today_outlined, value: rangeText),
          if (timeText != null) ...[
            const SizedBox(height: 8),
            _MetaRow(icon: Icons.access_time_outlined, value: timeText),
          ],
          if (event.location != null) ...[
            const SizedBox(height: 8),
            _MetaRow(icon: Icons.location_on_outlined, value: event.location!),
          ],
          if (event.description != null) ...[
            const SizedBox(height: 12),
            Text(
              event.description!,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                height: 1.45,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDateRange(SchoolEventData event, AppLocalizations l10n) {
    final start = _formatDate(event.startDate, l10n);
    final end = _formatDate(event.endDate, l10n);

    if (start == null && end == null) {
      return l10n.eventDateUnavailable;
    }
    if (start != null && end != null && start != end) {
      return '$start - $end';
    }
    return start ?? end!;
  }

  String? _formatTimeRange(SchoolEventData event) {
    final startTime = event.startTime;
    final endTime = event.endTime;
    if (startTime == null && endTime == null) {
      return null;
    }
    if (startTime != null && endTime != null) {
      return '$startTime - $endTime';
    }
    return startTime ?? endTime;
  }

  String? _formatDate(String? rawDate, AppLocalizations l10n) {
    if (rawDate == null || rawDate.isEmpty) {
      return null;
    }
    try {
      return DateFormat(
        'dd.MM.yyyy',
        l10n.intlLocaleTag,
      ).format(DateTime.parse(rawDate));
    } catch (_) {
      return rawDate;
    }
  }

  Color _typeColor(String type) {
    switch (type) {
      case 'holiday':
        return TeacherAppColors.success;
      case 'exam':
        return TeacherAppColors.warning;
      case 'meeting':
        return TeacherAppColors.info;
      case 'sport':
        return TeacherAppColors.warning;
      default:
        return TeacherAppColors.primaryPurple;
    }
  }
}

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String value;

  const _MetaRow({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(icon, size: 18, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
        ),
      ],
    );
  }
}
