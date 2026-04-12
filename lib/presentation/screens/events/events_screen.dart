import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/liquid_glass.dart';
import 'package:teacher_school_app/l10n/app_localizations.dart';
import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import '../../../core/network/api_error_handler.dart';
import '../../../data/models/event_model.dart';
import '../../providers/event_provider.dart';
import '../../common/page_background.dart';
import '../../common/premium_card.dart';
import '../../common/animated_pressable.dart';
import '../../widgets/app_feedback.dart';
import 'dart:ui';

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
    final eventsAsync = ref.watch(eventsProvider);

    return PageBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: eventsAsync.when(
          data: (data) {
            return RefreshIndicator(
              onRefresh: () => _refresh(ref),
              displacement: 100,
              color: theme.colorScheme.primary,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                slivers: [
                  SliverAppBar(
                    floating: true,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    centerTitle: true,
                    title: Text(
                      l10n.eventsMenuTitle,
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 24),
                    ),
                  ),
                  if (data.events.isEmpty)
                    SliverFillRemaining(
                      child: AppEmptyView(
                        title: l10n.eventsEmptyTitle,
                        message: l10n.eventsEmptyMessage,
                        icon: Icons.event_busy_rounded,
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _EventCard(event: data.events[index]),
                            );
                          },
                          childCount: data.events.length,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
          loading: () => const Center(child: AppLoadingView()),
          error: (error, stack) => Center(
            child: AppErrorView(
              message: ApiErrorHandler.readableMessage(error),
              onRetry: () => ref.invalidate(eventsProvider),
            ),
          ),
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
    final typeColor = _typeColor(event.type);
    final rangeText = _formatDateRange(event, l10n);
    final timeText = _formatTimeRange(event);

    return PremiumCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  event.title.isNotEmpty ? event.title : l10n.eventFallbackTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: typeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: typeColor.withValues(alpha: 0.2)),
                ),
                child: Text(
                  l10n.eventsTypeLabel(event.type).toUpperCase(),
                  style: TextStyle(
                    color: typeColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 10,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _MetaRow(icon: Icons.calendar_today_rounded, value: rangeText),
          if (timeText != null) ...[
            const SizedBox(height: 10),
            _MetaRow(icon: Icons.access_time_rounded, value: timeText),
          ],
          if (event.location != null && event.location!.isNotEmpty) ...[
            const SizedBox(height: 10),
            _MetaRow(icon: Icons.location_on_rounded, value: event.location!),
          ],
          if (event.description != null && event.description!.isNotEmpty) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                event.description!,
                style: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                  height: 1.5,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
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

    if (start == null && end == null) return l10n.eventDateUnavailable;
    if (start != null && end != null && start != end) return '$start - $end';
    return start ?? end!;
  }

  String? _formatTimeRange(SchoolEventData event) {
    final startTime = event.startTime;
    final endTime = event.endTime;
    if (startTime == null && endTime == null) return null;
    if (startTime != null && endTime != null) return '$startTime - $endTime';
    return startTime ?? endTime;
  }

  String? _formatDate(String? rawDate, AppLocalizations l10n) {
    if (rawDate == null || rawDate.isEmpty) return null;
    try {
      return DateFormat('dd.MM.yyyy', l10n.intlLocaleTag).format(DateTime.parse(rawDate));
    } catch (_) {
      return rawDate;
    }
  }

  Color _typeColor(String type) {
    switch (type) {
      case 'holiday': return TeacherAppColors.success;
      case 'exam': return TeacherAppColors.error;
      case 'meeting': return TeacherAppColors.info;
      case 'sport': return TeacherAppColors.warning;
      default: return TeacherAppColors.primaryPurple;
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
        Icon(icon, size: 18, color: colorScheme.primary.withValues(alpha: 0.6)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
