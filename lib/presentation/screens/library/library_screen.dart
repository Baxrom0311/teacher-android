import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/liquid_glass.dart';
import 'package:teacher_school_app/l10n/app_localizations.dart';
import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import '../../../core/network/api_error_handler.dart';
import '../../../data/models/library_model.dart';
import '../../providers/library_provider.dart';
import '../../common/page_background.dart';
import '../../common/premium_card.dart';
import '../../common/animated_pressable.dart';
import '../../widgets/app_feedback.dart';
import 'dart:ui';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      ref.read(libraryQueryProvider.notifier).state = value.trim();
    });
  }

  Future<void> _refresh() async {
    ref.invalidate(libraryOverviewProvider);
    await ref.read(libraryOverviewProvider.future);
  }

  Future<void> _borrowBook(int bookId) async {
    final l10n = context.l10n;
    try {
      await ref.read(libraryActionControllerProvider.notifier).borrowBook(bookId);
      if (!mounted) return;
      ref.invalidate(libraryOverviewProvider);
      AppFeedback.showSuccess(context, l10n.libraryBorrowedSuccess);
    } catch (error) {
      if (!mounted) return;
      AppFeedback.showError(context, ApiErrorHandler.readableMessage(error));
    }
  }

  Future<void> _returnLoan(int loanId) async {
    final l10n = context.l10n;
    try {
      await ref.read(libraryActionControllerProvider.notifier).returnLoan(loanId);
      if (!mounted) return;
      ref.invalidate(libraryOverviewProvider);
      AppFeedback.showSuccess(context, l10n.libraryReturnedSuccess);
    } catch (error) {
      if (!mounted) return;
      AppFeedback.showError(context, ApiErrorHandler.readableMessage(error));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final overviewAsync = ref.watch(libraryOverviewProvider);

    return PageBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(l10n.libraryMenuTitle, style: const TextStyle(fontWeight: FontWeight.w900)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
              child: _SearchBar(
                controller: _searchController,
                onChanged: _onSearchChanged,
                hintText: l10n.librarySearchHint,
              ),
            ),
            Expanded(
              child: overviewAsync.when(
                data: (overview) {
                  final borrowedBookIds = overview.loansResponse.loans
                      .where((loan) => loan.isBorrowed)
                      .map((loan) => loan.book?.id)
                      .whereType<int>()
                      .toSet();

                  return RefreshIndicator(
                    onRefresh: _refresh,
                    displacement: 20,
                    color: theme.colorScheme.primary,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                      children: [
                        _SectionHeader(
                          title: l10n.libraryMyBooksTitle,
                          count: overview.loansResponse.loans.length,
                          totalLabel: l10n.libraryLoanRecordsCount(overview.loansResponse.loans.length),
                        ),
                        const SizedBox(height: 12),
                        if (overview.loansResponse.loans.isEmpty)
                          _EmptyCard(
                            icon: Icons.menu_book_rounded,
                            message: l10n.libraryNoLoansMessage,
                          )
                        else
                          ...overview.loansResponse.loans.map(
                            (loan) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _LoanCard(
                                loan: loan,
                                onReturn: loan.isBorrowed ? () => _returnLoan(loan.id) : null,
                              ),
                            ),
                          ),
                        const SizedBox(height: 32),
                        _SectionHeader(
                          title: l10n.libraryCatalogTitle,
                          count: overview.booksResponse.total,
                          totalLabel: l10n.libraryAvailableBooksCount(overview.booksResponse.total),
                        ),
                        const SizedBox(height: 12),
                        if (overview.booksResponse.books.isEmpty)
                          _EmptyCard(
                            icon: Icons.search_off_rounded,
                            message: l10n.libraryNoBooksMessage,
                          )
                        else
                          ...overview.booksResponse.books.map(
                            (book) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _BookCard(
                                book: book,
                                isBorrowed: borrowedBookIds.contains(book.id),
                                onBorrow: book.canBorrow && !borrowedBookIds.contains(book.id)
                                    ? () => _borrowBook(book.id)
                                    : null,
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
                    onRetry: () => ref.invalidate(libraryOverviewProvider),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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

class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;
  final String totalLabel;

  const _SectionHeader({required this.title, required this.count, required this.totalLabel});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 2),
              Text(
                totalLabel,
                style: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.4),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          if (count > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  final IconData icon;
  final String message;

  const _EmptyCard({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return PremiumCard(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Center(
        child: Column(
          children: [
            Icon(icon, size: 40, color: colorScheme.onSurface.withValues(alpha: 0.15)),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.3),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoanCard extends StatelessWidget {
  final BookLoanData loan;
  final VoidCallback? onReturn;

  const _LoanCard({required this.loan, required this.onReturn});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final book = loan.book;
    final colorScheme = Theme.of(context).colorScheme;
    final statusColor = loan.isBorrowed ? TeacherAppColors.warning : TeacherAppColors.success;

    return PremiumCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book?.title ?? l10n.libraryBookFallback,
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, height: 1.2),
                    ),
                    if (book?.author != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        book!.author!,
                        style: TextStyle(
                          color: colorScheme.onSurface.withValues(alpha: 0.4),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: statusColor.withValues(alpha: 0.2)),
                ),
                child: Text(
                  (loan.isBorrowed ? l10n.libraryBorrowedStatus : l10n.libraryReturnedStatus).toUpperCase(),
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 10,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _DateRow(
            icon: Icons.outbond_rounded,
            label: l10n.libraryBorrowedDateLabel('').trim(),
            date: _formatDate(loan.borrowedAt, l10n),
          ),
          const SizedBox(height: 8),
          _DateRow(
            icon: loan.isBorrowed ? Icons.event_available_rounded : Icons.move_to_inbox_rounded,
            label: (loan.isBorrowed ? l10n.libraryDueDateLabel('') : l10n.libraryReturnedDateLabel('')).trim(),
            date: loan.isBorrowed ? _formatDate(loan.dueAt, l10n) : _formatDate(loan.returnedAt, l10n),
            isHighlight: loan.isBorrowed,
          ),
          if (onReturn != null) ...[
            const SizedBox(height: 20),
            AnimatedPressable(
              onTap: onReturn,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colorScheme.primary.withValues(alpha: 0.2)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.assignment_return_rounded, size: 18, color: colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      l10n.libraryReturnAction,
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(String? rawDate, AppLocalizations l10n) {
    if (rawDate == null || rawDate.isEmpty) return '-';
    try {
      return DateFormat('dd.MM.yyyy', l10n.intlLocaleTag).format(DateTime.parse(rawDate));
    } catch (_) {
      return rawDate;
    }
  }
}

class _BookCard extends StatelessWidget {
  final BookData book;
  final bool isBorrowed;
  final VoidCallback? onBorrow;

  const _BookCard({required this.book, required this.isBorrowed, required this.onBorrow});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    return PremiumCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.book_rounded, color: colorScheme.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title.isNotEmpty ? book.title : l10n.libraryBookFallback,
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, height: 1.2),
                    ),
                    if (book.author != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        book.author!,
                        style: TextStyle(
                          color: colorScheme.onSurface.withValues(alpha: 0.4),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _InfoChip(
                icon: Icons.copy_rounded,
                label: l10n.libraryCopiesLabel(book.availableCopies, book.totalCopies),
                color: book.availableCopies > 0 ? TeacherAppColors.success : TeacherAppColors.error,
              ),
              if (book.category != null) _InfoChip(icon: Icons.category_rounded, label: book.category!),
              if (book.isbn != null) _InfoChip(icon: Icons.qr_code_rounded, label: 'ISBN: ${book.isbn}'),
            ],
          ),
          if (book.description != null && book.description!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              book.description!,
              style: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
                height: 1.5,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 24),
          AnimatedPressable(
            onTap: onBorrow,
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: (onBorrow == null || isBorrowed)
                      ? [colorScheme.surfaceVariant, colorScheme.surfaceVariant]
                      : [colorScheme.primary, colorScheme.secondary],
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  if (onBorrow != null && !isBorrowed)
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                ],
              ),
              child: Center(
                child: Text(
                  isBorrowed
                      ? l10n.libraryBorrowedStatus.toUpperCase()
                      : book.canBorrow
                          ? l10n.libraryBorrowAction.toUpperCase()
                          : l10n.libraryUnavailableAction.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DateRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String date;
  final bool isHighlight;

  const _DateRow({
    required this.icon,
    required this.label,
    required this.date,
    this.isHighlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final primaryColor = isHighlight ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.4);

    return Row(
      children: [
        Icon(icon, size: 16, color: primaryColor),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: TextStyle(
            color: colorScheme.onSurface.withValues(alpha: 0.4),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          date,
          style: TextStyle(
            color: isHighlight ? colorScheme.primary : colorScheme.onSurface,
            fontSize: 13,
            fontWeight: isHighlight ? FontWeight.w800 : FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const _InfoChip({required this.icon, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final activeColor = color ?? colorScheme.onSurface.withValues(alpha: 0.5);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: activeColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: activeColor.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: activeColor),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                color: activeColor,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
