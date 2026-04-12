import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'dart:ui';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/liquid_glass.dart';
import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import '../../../core/network/api_error_handler.dart';
import '../../providers/payment_provider.dart';
import '../../common/page_background.dart';
import '../../common/premium_card.dart';
import '../../common/animated_pressable.dart';
import '../../widgets/app_feedback.dart';

class PaymentDetailScreen extends ConsumerStatefulWidget {
  final int studentId;
  const PaymentDetailScreen({super.key, required this.studentId});

  @override
  ConsumerState<PaymentDetailScreen> createState() => _PaymentDetailScreenState();
}

class _PaymentDetailScreenState extends ConsumerState<PaymentDetailScreen> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  String _payType = 'monthly';
  String _paymentMethod = 'cash';
  int? _periodYear;
  int? _periodMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _periodYear = now.year;
    _periodMonth = now.month;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  NumberFormat _currencyFormat(BuildContext context) {
    final l10n = context.l10n;
    return NumberFormat.currency(
      locale: l10n.intlLocaleTag,
      symbol: l10n.currencySymbol,
      decimalDigits: 0,
    );
  }

  Future<void> _submitPayment() async {
    final l10n = context.l10n;
    final amountText = _amountController.text.trim().replaceAll(',', '').replaceAll(' ', '');
    final amount = num.tryParse(amountText);

    if (amount == null || amount <= 0) {
      AppFeedback.showError(context, l10n.paymentAmountRequired);
      return;
    }

    final success = await ref.read(paymentControllerProvider.notifier).storePayment(
          widget.studentId,
          payType: _payType,
          paymentMethod: _paymentMethod,
          amount: amount,
          paidAt: DateFormat('yyyy-MM-dd').format(DateTime.now()),
          periodYear: _payType == 'monthly' ? _periodYear : null,
          periodMonth: _payType == 'monthly' ? _periodMonth : null,
          note: _noteController.text.trim(),
        );

    if (success && mounted) {
      AppFeedback.showSuccess(context, l10n.paymentAccepted);
      ref.invalidate(studentPaymentDetailProvider(widget.studentId));
      ref.invalidate(paymentsIndexProvider);
      context.pop();
    } else if (mounted) {
      final error = ref.read(paymentControllerProvider).error;
      AppFeedback.showError(context, ApiErrorHandler.readableMessage(error));
    }
  }

  void _showAddPaymentModal(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 24,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: 0.95),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 20, offset: const Offset(0, -10)),
                ],
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 24),
                          decoration: BoxDecoration(
                            color: colorScheme.onSurface.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      Text(
                        l10n.newPaymentTitle,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 24),
                      
                      _FormLabel(label: l10n.paymentTypeLabel),
                      _DropdownField<String>(
                        value: _payType,
                        items: [
                          DropdownMenuItem(value: 'monthly', child: Text(l10n.monthlyPaymentType)),
                          DropdownMenuItem(value: 'yearly', child: Text(l10n.yearlyPaymentType)),
                        ],
                        onChanged: (v) => setStateModal(() => _payType = v!),
                      ),
                      const SizedBox(height: 16),

                      if (_payType == 'monthly') ...[
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _FormLabel(label: l10n.yearLabel),
                                  _DropdownField<int>(
                                    value: _periodYear,
                                    items: List.generate(5, (i) => DateTime.now().year - 2 + i)
                                        .map((y) => DropdownMenuItem(value: y, child: Text(y.toString())))
                                        .toList(),
                                    onChanged: (v) => setStateModal(() => _periodYear = v),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _FormLabel(label: l10n.monthLabel),
                                  _DropdownField<int>(
                                    value: _periodMonth,
                                    items: List.generate(12, (i) => i + 1)
                                        .map((m) => DropdownMenuItem(value: m, child: Text(m.toString().padLeft(2, '0'))))
                                        .toList(),
                                    onChanged: (v) => setStateModal(() => _periodMonth = v),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],

                      _FormLabel(label: l10n.paymentMethodLabel),
                      _DropdownField<String>(
                        value: _paymentMethod,
                        items: [
                          DropdownMenuItem(value: 'cash', child: Text(l10n.paymentMethodCash)),
                          DropdownMenuItem(value: 'card', child: Text(l10n.paymentMethodCard)),
                          DropdownMenuItem(value: 'p2p', child: Text(l10n.paymentMethodTransfer)),
                          DropdownMenuItem(value: 'terminal', child: Text(l10n.paymentMethodTerminal)),
                        ],
                        onChanged: (v) => setStateModal(() => _paymentMethod = v!),
                      ),
                      const SizedBox(height: 16),

                      _FormLabel(label: l10n.amountCurrencyLabel),
                      _InputField(
                        controller: _amountController,
                        hintText: '0',
                        keyboardType: TextInputType.number,
                        prefixIcon: Icons.attach_money_rounded,
                      ),
                      const SizedBox(height: 16),

                      _FormLabel(label: l10n.noteOptional),
                      _InputField(
                        controller: _noteController,
                        hintText: l10n.noteOptional,
                        prefixIcon: Icons.sticky_note_2_rounded,
                      ),
                      const SizedBox(height: 32),

                      AnimatedPressable(
                        onTap: () {
                          Navigator.pop(context);
                          _submitPayment();
                        },
                        child: Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [colorScheme.primary, colorScheme.secondary]),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: colorScheme.primary.withValues(alpha: 0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              l10n.confirmAction.toUpperCase(),
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 1.0),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency = _currencyFormat(context);
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final detailAsync = ref.watch(studentPaymentDetailProvider(widget.studentId));

    return PageBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: detailAsync.when(
          data: (data) {
            final student = data.student;
            final group = data.group;
            final payments = data.payments;

            return CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              slivers: [
                SliverAppBar(
                  expandedHeight: 280,
                  pinned: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Padding(
                      padding: const EdgeInsets.only(top: 80),
                      child: Column(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [colorScheme.primary.withValues(alpha: 0.2), colorScheme.secondary.withValues(alpha: 0.2)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(color: colorScheme.primary.withValues(alpha: 0.2)),
                            ),
                            child: Center(
                              child: Text(
                                student['name'].toString().isNotEmpty ? student['name'][0].toUpperCase() : 'S',
                                style: TextStyle(
                                  fontSize: 40,
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            student['name'] ?? '',
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, height: 1.2),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            group['name'] ?? '',
                            style: TextStyle(
                              color: colorScheme.onSurface.withValues(alpha: 0.4),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: _SummaryCard(
                            title: l10n.monthlyFeeLabel,
                            value: formatCurrency.format(data.monthlyFee),
                            icon: Icons.payments_rounded,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _SummaryCard(
                            title: l10n.discountLabel,
                            value: formatCurrency.format(data.discountAmount),
                            icon: Icons.card_giftcard_rounded,
                            color: TeacherAppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.paymentHistoryTitle,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                        ),
                        if (payments.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              payments.length.toString(),
                              style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.w900, fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                if (payments.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: AppEmptyView(
                        message: l10n.noPaymentsForStudent,
                        icon: Icons.history_rounded,
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final p = payments[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _HistoryCard(p: p, formatCurrency: formatCurrency),
                          );
                        },
                        childCount: payments.length,
                      ),
                    ),
                  ),
              ],
            );
          },
          loading: () => const Center(child: AppLoadingView()),
          error: (err, st) => Center(
            child: AppErrorView(
              message: ApiErrorHandler.readableMessage(err),
              onRetry: () => ref.invalidate(studentPaymentDetailProvider(widget.studentId)),
            ),
          ),
        ),
        floatingActionButton: AnimatedPressable(
          onTap: () => _showAddPaymentModal(context),
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [colorScheme.primary, colorScheme.secondary]),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(Icons.add_rounded, color: Colors.white, size: 32),
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final PaymentData p;
  final NumberFormat formatCurrency;

  const _HistoryCard({required this.p, required this.formatCurrency});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    return PremiumCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: TeacherAppColors.success.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_circle_rounded, color: TeacherAppColors.success, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formatCurrency.format(p.amount),
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.paymentPeriodLabel(
                    payType: p.payType,
                    periodYear: p.periodYear,
                    periodMonth: p.periodMonth,
                    paymentMethod: p.paymentMethod,
                  ),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ),
          Text(
            p.paidAt,
            style: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.4),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _FormLabel extends StatelessWidget {
  final String label;
  const _FormLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.0,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final IconData prefixIcon;

  const _InputField({
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    required this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.onSurface.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.08)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.3)),
          prefixIcon: Icon(prefixIcon, color: colorScheme.onSurface.withValues(alpha: 0.3), size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}

class _DropdownField<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const _DropdownField({required this.value, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.onSurface.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.08)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: colorScheme.primary, size: 20),
          dropdownColor: theme.cardColor,
          isExpanded: true,
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: colorScheme.onSurface),
        ),
      ),
    );
  }
}
