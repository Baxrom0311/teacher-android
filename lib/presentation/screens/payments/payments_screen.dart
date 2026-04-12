import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import 'dart:ui';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/liquid_glass.dart';
import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import '../../../core/network/api_error_handler.dart';
import '../../../data/models/payment_model.dart';
import '../../providers/payment_provider.dart';
import '../../common/page_background.dart';
import '../../common/premium_card.dart';
import '../../common/animated_pressable.dart';
import '../../widgets/app_feedback.dart';

class PaymentsScreen extends ConsumerStatefulWidget {
  const PaymentsScreen({super.key});

  @override
  ConsumerState<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends ConsumerState<PaymentsScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(paymentIndexParamsProvider.notifier).update((state) => {...state, 'search': query.trim()});
    });
  }

  Future<void> _refresh() async {
    ref.invalidate(paymentsIndexProvider);
    await ref.read(paymentsIndexProvider.future);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final paymentsAsync = ref.watch(paymentsIndexProvider);

    return PageBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: RefreshIndicator(
          onRefresh: _refresh,
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
                  l10n.paymentsTitle,
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 24),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                  child: Column(
                    children: [
                      _buildFilters(theme),
                      const SizedBox(height: 12),
                      _SearchBar(
                        controller: _searchController,
                        onChanged: _onSearchChanged,
                        hintText: l10n.searchStudentHint,
                      ),
                    ],
                  ),
                ),
              ),
              paymentsAsync.when(
                data: (data) {
                  if (data.students.isEmpty) {
                    return SliverFillRemaining(
                      child: Center(
                        child: AppEmptyView(
                          message: l10n.noStudentsFound,
                          icon: Icons.person_search_rounded,
                        ),
                      ),
                    );
                  }
                  return SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _StudentCard(student: data.students[index]),
                        ),
                        childCount: data.students.length,
                      ),
                    ),
                  );
                },
                loading: () => const SliverFillRemaining(
                  child: Center(child: AppLoadingView()),
                ),
                error: (err, st) => SliverFillRemaining(
                  child: Center(
                    child: AppErrorView(
                      message: ApiErrorHandler.readableMessage(err),
                      onRetry: () => ref.invalidate(paymentsIndexProvider),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilters(ThemeData theme) {
    final l10n = context.l10n;
    final colorScheme = theme.colorScheme;
    final paymentsAsync = ref.watch(paymentsIndexProvider);

    return paymentsAsync.maybeWhen(
      data: (data) {
        if (data.groups.isEmpty) return const SizedBox.shrink();
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              isExpanded: true,
              value: data.groupId == 0 ? null : data.groupId,
              hint: Text(l10n.allGroups, style: const TextStyle(fontWeight: FontWeight.w600)),
              dropdownColor: theme.cardColor,
              icon: Icon(Icons.keyboard_arrow_down_rounded, color: colorScheme.primary),
              items: [
                DropdownMenuItem<int>(
                  value: null,
                  child: Text(l10n.allGroups, style: const TextStyle(fontWeight: FontWeight.w700)),
                ),
                ...data.groups.map(
                  (g) => DropdownMenuItem<int>(
                    value: g.id,
                    child: Text(g.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
              onChanged: (val) {
                ref.read(paymentIndexParamsProvider.notifier).update((state) => {...state, 'group_id': val});
              },
            ),
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hintText;

  const _SearchBar({required this.controller, required this.onChanged, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
          prefixIcon: Icon(Icons.search_rounded, color: Colors.white.withValues(alpha: 0.3)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}

class _StudentCard extends StatelessWidget {
  final StudentData student;

  const _StudentCard({required this.student});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final statusColor = student.isPaid ? TeacherAppColors.success : TeacherAppColors.error;

    return AnimatedPressable(
      onTap: () => context.push('/payments/${student.studentId}'),
      child: PremiumCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colorScheme.primary.withValues(alpha: 0.2), colorScheme.secondary.withValues(alpha: 0.2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colorScheme.primary.withValues(alpha: 0.2)),
              ),
              child: Center(
                child: Text(
                  student.studentName.isNotEmpty ? student.studentName[0].toUpperCase() : 'S',
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
                    student.studentName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 17,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.groups_rounded, size: 14, color: colorScheme.onSurface.withValues(alpha: 0.4)),
                      const SizedBox(width: 6),
                      Text(
                        student.groupName,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface.withValues(alpha: 0.4),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: statusColor.withValues(alpha: 0.2)),
              ),
              child: Text(
                (student.isPaid ? l10n.paidStatus : l10n.debtorStatus).toUpperCase(),
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 10,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.arrow_forward_ios_rounded, size: 14, color: colorScheme.onSurface.withValues(alpha: 0.2)),
          ],
        ),
      ),
    );
  }
}
