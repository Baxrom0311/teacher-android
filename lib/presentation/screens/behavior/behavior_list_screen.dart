import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teacher_school_app/core/constants/app_colors.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../data/models/behavior_model.dart';
import '../../providers/behavior_provider.dart';

class BehaviorListScreen extends ConsumerStatefulWidget {
  const BehaviorListScreen({super.key});

  @override
  ConsumerState<BehaviorListScreen> createState() => _BehaviorListScreenState();
}

class _BehaviorListScreenState extends ConsumerState<BehaviorListScreen> {
  String? _typeFilter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(behaviorListProvider.notifier).loadIncidents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsRegistry.instance;
    final theme = Theme.of(context);
    final state = ref.watch(behaviorListProvider);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.behaviorTitle), centerTitle: true),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(TeacherRoutes.behaviorCreate),
        child: const Icon(Icons.add_rounded),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
                      const SizedBox(height: 12),
                      Text(l10n.behaviorLoadFailed, style: theme.textTheme.bodyLarge),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: () => ref.read(behaviorListProvider.notifier).loadIncidents(),
                        icon: const Icon(Icons.refresh, size: 18),
                        label: Text(l10n.retry),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // Filter chips
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          _FilterChip(
                            label: l10n.behaviorAll,
                            selected: _typeFilter == null,
                            onTap: () {
                              setState(() => _typeFilter = null);
                              ref.read(behaviorListProvider.notifier).loadIncidents();
                            },
                          ),
                          const SizedBox(width: 8),
                          _FilterChip(
                            label: l10n.behaviorPositive,
                            selected: _typeFilter == 'positive',
                            color: Colors.green,
                            onTap: () {
                              setState(() => _typeFilter = 'positive');
                              ref.read(behaviorListProvider.notifier).loadIncidents(type: 'positive');
                            },
                          ),
                          const SizedBox(width: 8),
                          _FilterChip(
                            label: l10n.behaviorNegative,
                            selected: _typeFilter == 'negative',
                            color: Colors.red,
                            onTap: () {
                              setState(() => _typeFilter = 'negative');
                              ref.read(behaviorListProvider.notifier).loadIncidents(type: 'negative');
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: state.incidents.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.sentiment_satisfied_alt_rounded,
                                      size: 56, color: TeacherAppColors.slate400),
                                  const SizedBox(height: 12),
                                  Text(l10n.behaviorEmpty,
                                      style: theme.textTheme.bodyLarge
                                          ?.copyWith(color: TeacherAppColors.slate500)),
                                ],
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: () async =>
                                  ref.read(behaviorListProvider.notifier).loadIncidents(type: _typeFilter),
                              child: ListView.separated(
                                padding: const EdgeInsets.all(16),
                                itemCount: state.incidents.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 10),
                                itemBuilder: (context, index) => _IncidentCard(
                                  incident: state.incidents[index],
                                  isDark: isDark,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color? color;
  final VoidCallback onTap;

  const _FilterChip({required this.label, required this.selected, this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chipColor = color ?? theme.colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? chipColor.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? chipColor : TeacherAppColors.slate300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? chipColor : TeacherAppColors.slate500,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _IncidentCard extends StatelessWidget {
  final BehaviorIncidentModel incident;
  final bool isDark;

  const _IncidentCard({required this.incident, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPositive = incident.isPositive;
    final color = isPositive ? Colors.green : Colors.red;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isPositive ? Icons.star_rounded : Icons.warning_rounded,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        incident.category,
                        style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${isPositive ? '+' : ''}${incident.points}',
                        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
                if (incident.studentName != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    incident.studentName!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: TeacherAppColors.slate500,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                if (incident.description != null && incident.description!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    incident.description!,
                    style: theme.textTheme.bodySmall?.copyWith(color: TeacherAppColors.slate500),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 6),
                if (incident.incidentDate != null)
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 14, color: TeacherAppColors.slate400),
                      const SizedBox(width: 4),
                      Text(
                        incident.incidentDate!,
                        style: theme.textTheme.labelSmall?.copyWith(color: TeacherAppColors.slate400),
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
