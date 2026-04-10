import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import '../../../core/network/api_error_handler.dart';
import '../../providers/payment_provider.dart';

class PaymentDetailScreen extends ConsumerStatefulWidget {
  final int studentId;
  const PaymentDetailScreen({super.key, required this.studentId});

  @override
  ConsumerState<PaymentDetailScreen> createState() =>
      _PaymentDetailScreenState();
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
    final amountText = _amountController.text
        .trim()
        .replaceAll(',', '')
        .replaceAll(' ', '');
    final amount = num.tryParse(amountText);

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.paymentAmountRequired)));
      return;
    }

    final success = await ref
        .read(paymentControllerProvider.notifier)
        .storePayment(
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.paymentAccepted),
          backgroundColor: TeacherAppColors.success,
        ),
      );
      ref.invalidate(studentPaymentDetailProvider(widget.studentId));
      ref.invalidate(paymentsIndexProvider);
      context.pop();
    } else if (mounted) {
      final error = ref.read(paymentControllerProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ApiErrorHandler.readableMessage(error)),
          backgroundColor: TeacherAppColors.error,
        ),
      );
    }
  }

  void _showAddPaymentModal(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor:
          theme.bottomSheetTheme.backgroundColor ??
          theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.newPaymentTitle,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: _payType,
                      decoration: InputDecoration(
                        labelText: l10n.paymentTypeLabel,
                        border: const OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'monthly',
                          child: Text(l10n.monthlyPaymentType),
                        ),
                        DropdownMenuItem(
                          value: 'yearly',
                          child: Text(l10n.yearlyPaymentType),
                        ),
                      ],
                      onChanged: (v) => setStateModal(() => _payType = v!),
                    ),
                    const SizedBox(height: 16),
                    if (_payType == 'monthly') ...[
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              initialValue: _periodYear,
                              decoration: InputDecoration(
                                labelText: l10n.yearLabel,
                                border: const OutlineInputBorder(),
                              ),
                              items:
                                  List.generate(
                                        5,
                                        (i) => DateTime.now().year - 2 + i,
                                      )
                                      .map(
                                        (y) => DropdownMenuItem(
                                          value: y,
                                          child: Text(y.toString()),
                                        ),
                                      )
                                      .toList(),
                              onChanged: (v) =>
                                  setStateModal(() => _periodYear = v),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              initialValue: _periodMonth,
                              decoration: InputDecoration(
                                labelText: l10n.monthLabel,
                                border: const OutlineInputBorder(),
                              ),
                              items: List.generate(12, (i) => i + 1)
                                  .map(
                                    (m) => DropdownMenuItem(
                                      value: m,
                                      child: Text(m.toString().padLeft(2, '0')),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (v) =>
                                  setStateModal(() => _periodMonth = v),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                    DropdownButtonFormField<String>(
                      initialValue: _paymentMethod,
                      decoration: InputDecoration(
                        labelText: l10n.paymentMethodLabel,
                        border: const OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'cash',
                          child: Text(l10n.paymentMethodCash),
                        ),
                        DropdownMenuItem(
                          value: 'card',
                          child: Text(l10n.paymentMethodCard),
                        ),
                        DropdownMenuItem(
                          value: 'p2p',
                          child: Text(l10n.paymentMethodTransfer),
                        ),
                        DropdownMenuItem(
                          value: 'terminal',
                          child: Text(l10n.paymentMethodTerminal),
                        ),
                      ],
                      onChanged: (v) =>
                          setStateModal(() => _paymentMethod = v!),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: l10n.amountCurrencyLabel,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.attach_money),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _noteController,
                      decoration: InputDecoration(
                        labelText: l10n.noteOptional,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.note),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _submitPayment();
                        },
                        child: Text(
                          l10n.confirmAction,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
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
    final detailAsync = ref.watch(
      studentPaymentDetailProvider(widget.studentId),
    );

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.studentPaymentsTitle),
        backgroundColor:
            theme.appBarTheme.backgroundColor ?? colorScheme.surface,
        foregroundColor:
            theme.appBarTheme.foregroundColor ?? colorScheme.onSurface,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        child: const Icon(Icons.add_card),
        onPressed: () => _showAddPaymentModal(context),
      ),
      body: detailAsync.when(
        data: (data) {
          final student = data.student;
          final group = data.group;
          final payments = data.payments;

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  color: theme.cardColor,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: colorScheme.primary.withValues(
                          alpha: 0.1,
                        ),
                        child: Text(
                          student['name'].toString().isNotEmpty
                              ? student['name'][0].toUpperCase()
                              : 'S',
                          style: TextStyle(
                            fontSize: 32,
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        student['name'] ?? '',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        group['name'] ?? '',
                        style: TextStyle(color: colorScheme.onSurfaceVariant),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoCard(
                              l10n.monthlyFeeLabel,
                              formatCurrency.format(data.monthlyFee),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildInfoCard(
                              l10n.discountLabel,
                              formatCurrency.format(data.discountAmount),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                  child: Text(
                    l10n.paymentHistoryTitle,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              if (payments.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Center(
                      child: Text(
                        l10n.noPaymentsForStudent,
                        style: TextStyle(color: colorScheme.onSurfaceVariant),
                      ),
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final p = payments[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: colorScheme.outline),
                      ),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: colorScheme.secondaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check_circle,
                            color: colorScheme.onSecondaryContainer,
                          ),
                        ),
                        title: Text(
                          formatCurrency.format(p.amount),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        subtitle: Text(
                          l10n.paymentPeriodLabel(
                            payType: p.payType,
                            periodYear: p.periodYear,
                            periodMonth: p.periodMonth,
                            paymentMethod: p.paymentMethod,
                          ),
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        trailing: Text(
                          p.paidAt,
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  }, childCount: payments.length),
                ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) =>
            Center(child: Text(ApiErrorHandler.readableMessage(err))),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
