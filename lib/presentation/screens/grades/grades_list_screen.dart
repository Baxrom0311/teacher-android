import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import 'package:teacher_school_app/l10n/app_localizations.dart';
import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import '../../../core/network/api_error_handler.dart';
import '../../../data/models/grades_model.dart';
import '../../providers/grades_provider.dart';
import '../../widgets/app_feedback.dart';

class GradesListScreen extends ConsumerStatefulWidget {
  const GradesListScreen({super.key});

  @override
  ConsumerState<GradesListScreen> createState() => _GradesListScreenState();
}

class _GradesListScreenState extends ConsumerState<GradesListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.gradesListTitle),
        backgroundColor:
            theme.appBarTheme.backgroundColor ?? colorScheme.surface,
        foregroundColor:
            theme.appBarTheme.foregroundColor ?? colorScheme.onSurface,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: colorScheme.primary,
          unselectedLabelColor: colorScheme.onSurfaceVariant,
          indicatorColor: colorScheme.primary,
          tabs: [
            Tab(text: l10n.gradesQuarterTab),
            Tab(text: l10n.gradesYearTab),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [_QuarterGradesTab(), _YearGradesTab()],
      ),
    );
  }
}

class _QuarterGradesTab extends ConsumerWidget {
  const _QuarterGradesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gradesAsync = ref.watch(quarterGradesProvider);

    return Column(
      children: [
        _buildFilterBar(context, ref),
        Expanded(
          child: gradesAsync.when(
            data: (response) {
              if (response.items.isEmpty) {
                return AppEmptyView(
                  message: context.l10n.gradesEmptyMessage,
                  icon: Icons.fact_check_outlined,
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: response.items.length,
                itemBuilder: (context, index) {
                  return _buildGradeCard(context, response.items[index], true);
                },
              );
            },
            loading: () => AppLoadingView(
              title: context.l10n.gradesLoadingTitle,
              subtitle: context.l10n.gradesLoadingSubtitle,
            ),
            error: (err, stack) => AppErrorView(
              title: context.l10n.gradesLoadErrorTitle,
              message: ApiErrorHandler.readableMessage(err),
              icon: Icons.fact_check_outlined,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterBar(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      color: theme.cardColor,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: context.l10n.gradesSearchHint,
                prefixIcon: const Icon(Icons.search, size: 20),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              onSubmitted: (value) {
                ref.read(quarterGradesFilterProvider.notifier).update((state) {
                  return {...state, 'search': value, 'page': 1};
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _YearGradesTab extends ConsumerWidget {
  const _YearGradesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gradesAsync = ref.watch(yearGradesProvider);

    return Column(
      children: [
        _buildFilterBar(context, ref),
        Expanded(
          child: gradesAsync.when(
            data: (response) {
              if (response.items.isEmpty) {
                return AppEmptyView(
                  message: context.l10n.gradesEmptyMessage,
                  icon: Icons.fact_check_outlined,
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: response.items.length,
                itemBuilder: (context, index) {
                  return _buildGradeCard(context, response.items[index], false);
                },
              );
            },
            loading: () => AppLoadingView(
              title: context.l10n.gradesLoadingTitle,
              subtitle: context.l10n.gradesLoadingSubtitle,
            ),
            error: (err, stack) => AppErrorView(
              title: context.l10n.gradesLoadErrorTitle,
              message: ApiErrorHandler.readableMessage(err),
              icon: Icons.fact_check_outlined,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterBar(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      color: theme.cardColor,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: context.l10n.gradesSearchHint,
                prefixIcon: const Icon(Icons.search, size: 20),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              onSubmitted: (value) {
                ref.read(yearGradesFilterProvider.notifier).update((state) {
                  return {...state, 'search': value, 'page': 1};
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildGradeCard(BuildContext context, GradeItem item, bool showQuarter) {
  final l10n = context.l10n;
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  final studentName = item.studentName.isNotEmpty
      ? item.studentName
      : l10n.unknownStudentFallback;
  final subjectName = item.subjectName.isNotEmpty && item.subjectName != '-'
      ? item.subjectName
      : l10n.unknownSubjectFallback;
  final groupName = item.groupName.isNotEmpty && item.groupName != '-'
      ? item.groupName
      : l10n.unknownGroupFallback;

  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: theme.cardColor,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: colorScheme.outline),
    ),
    child: Row(
      children: [
        CircleAvatar(
          backgroundColor: colorScheme.primary.withValues(alpha: 0.12),
          child: Text(
            studentName.isNotEmpty
                ? studentName.substring(0, 1).toUpperCase()
                : '?',
            style: TextStyle(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                studentName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$subjectName | $groupName',
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
              if (showQuarter && item.quarterName != null) ...[
                const SizedBox(height: 4),
                Text(
                  l10n.gradesQuarterLabel(item.quarterName!),
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
              ],
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: TeacherAppColors.success.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '${item.score}',
            style: const TextStyle(
              color: TeacherAppColors.success,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ],
    ),
  );
}
