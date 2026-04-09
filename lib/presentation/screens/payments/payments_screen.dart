import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import '../../../core/network/api_error_handler.dart';
import '../../../data/models/payment_model.dart';
import 'dart:async';
import '../../providers/payment_provider.dart';

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
      ref
          .read(paymentIndexParamsProvider.notifier)
          .update((state) => {...state, 'search': query.trim()});
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final paymentsAsync = ref.watch(paymentsIndexProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.paymentsTitle),
        backgroundColor:
            theme.appBarTheme.backgroundColor ?? colorScheme.surface,
        foregroundColor:
            theme.appBarTheme.foregroundColor ?? colorScheme.onSurface,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: paymentsAsync.when(
              data: (data) {
                if (data.students.isEmpty) {
                  return Center(child: Text(l10n.noStudentsFound));
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: data.students.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final student = data.students[index];
                    return _buildStudentCard(student);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, st) =>
                  Center(child: Text(ApiErrorHandler.readableMessage(err))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final paymentsAsync = ref.watch(paymentsIndexProvider);

    return Container(
      color: theme.cardColor,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          paymentsAsync.maybeWhen(
            data: (data) {
              if (data.groups.isEmpty) return const SizedBox.shrink();
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.outline.withValues(alpha: 0.7),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    isExpanded: true,
                    value: data.groupId == 0 ? null : data.groupId,
                    hint: Text(l10n.allGroups),
                    items: [
                      DropdownMenuItem<int>(
                        value: null,
                        child: Text(l10n.allGroups),
                      ),
                      ...data.groups.map(
                        (g) => DropdownMenuItem<int>(
                          value: g.id,
                          child: Text(g.name),
                        ),
                      ),
                    ],
                    onChanged: (val) {
                      ref
                          .read(paymentIndexParamsProvider.notifier)
                          .update((state) => {...state, 'group_id': val});
                    },
                  ),
                ),
              );
            },
            orElse: () => const SizedBox.shrink(),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: l10n.searchStudentHint,
              prefixIcon: Icon(
                Icons.search,
                color: colorScheme.onSurfaceVariant,
              ),
              filled: true,
              fillColor: colorScheme.surface,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentCard(StudentData student) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return InkWell(
      onTap: () {
        context.push('/payments/${student.studentId}');
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.outline.withValues(alpha: 0.7)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: colorScheme.primaryContainer,
              child: Text(
                student.studentName.isNotEmpty
                    ? student.studentName[0].toUpperCase()
                    : 'S',
                style: TextStyle(
                  color: colorScheme.onPrimaryContainer,
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
                    student.studentName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    student.groupName,
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: student.isPaid
                    ? colorScheme.secondaryContainer
                    : colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                student.isPaid ? l10n.paidStatus : l10n.debtorStatus,
                style: TextStyle(
                  color: student.isPaid
                      ? colorScheme.onSecondaryContainer
                      : colorScheme.onErrorContainer,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
