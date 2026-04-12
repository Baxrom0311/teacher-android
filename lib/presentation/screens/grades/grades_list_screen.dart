import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/liquid_glass.dart';
import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import '../../../core/network/api_error_handler.dart';
import '../../../data/models/grades_model.dart';
import '../../providers/grades_provider.dart';
import '../../widgets/app_feedback.dart';
import '../../common/page_background.dart';
import '../../common/premium_card.dart';
import '../../common/animated_pressable.dart';

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

    return PageBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(l10n.gradesListTitle, style: const TextStyle(fontWeight: FontWeight.w900)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: colorScheme.primary.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))
                  ],
                ),
                labelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 0.5),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                labelColor: Colors.white,
                unselectedLabelColor: colorScheme.onSurface.withValues(alpha: 0.4),
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: [
                  Tab(text: l10n.gradesQuarterTab),
                  Tab(text: l10n.gradesYearTab),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          physics: const BouncingScrollPhysics(),
          children: const [_QuarterGradesTab(), _YearGradesTab()],
        ),
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
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: TextField(
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        decoration: InputDecoration(
          hintText: context.l10n.gradesSearchHint,
          hintStyle: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.3)),
          prefixIcon: Icon(Icons.search_rounded, color: colorScheme.primary.withValues(alpha: 0.5)),
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.05),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onSubmitted: (value) {
          ref.read(quarterGradesFilterProvider.notifier).update((state) {
            return {...state, 'search': value, 'page': 1};
          });
        },
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
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: TextField(
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        decoration: InputDecoration(
          hintText: context.l10n.gradesSearchHint,
          hintStyle: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.3)),
          prefixIcon: Icon(Icons.search_rounded, color: colorScheme.primary.withValues(alpha: 0.5)),
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.05),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onSubmitted: (value) {
          ref.read(yearGradesFilterProvider.notifier).update((state) {
            return {...state, 'search': value, 'page': 1};
          });
        },
      ),
    );
  }
}

Widget _buildGradeCard(BuildContext context, GradeItem item, bool showQuarter) {
  final l10n = context.l10n;
  final colorScheme = Theme.of(context).colorScheme;
  final studentName = item.studentName.isNotEmpty ? item.studentName : l10n.unknownStudentFallback;
  final subjectName = item.subjectName.isNotEmpty && item.subjectName != '-' ? item.subjectName : l10n.unknownSubjectFallback;
  final groupName = item.groupName.isNotEmpty && item.groupName != '-' ? item.groupName : l10n.unknownGroupFallback;

  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: PremiumCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _AvatarSmall(name: studentName),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  studentName,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  '$subjectName • $groupName',
                  style: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.4),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (showQuarter && item.quarterName != null) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      l10n.gradesQuarterLabel(item.quarterName!),
                      style: TextStyle(color: colorScheme.primary, fontSize: 10, fontWeight: FontWeight.w900),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: TeacherAppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: TeacherAppColors.success.withValues(alpha: 0.2)),
            ),
            child: Text(
              '${item.score}',
              style: const TextStyle(
                color: TeacherAppColors.success,
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _AvatarSmall extends StatelessWidget {
  final String name;
  const _AvatarSmall({required this.name});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.1),
        shape: BoxShape.circle,
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.2)),
      ),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.w900, fontSize: 18),
        ),
      ),
    );
  }
}
