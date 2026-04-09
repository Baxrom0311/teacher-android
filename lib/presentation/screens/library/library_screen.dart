import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import 'package:teacher_school_app/l10n/app_localizations.dart';
import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import '../../../core/network/api_error_handler.dart';
import '../../../data/models/library_model.dart';
import '../../providers/library_provider.dart';
import '../../widgets/app_feedback.dart';

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
      await ref
          .read(libraryActionControllerProvider.notifier)
          .borrowBook(bookId);
      if (!mounted) return;
      ref.invalidate(libraryOverviewProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.libraryBorrowedSuccess),
          backgroundColor: TeacherAppColors.success,
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ApiErrorHandler.readableMessage(error)),
          backgroundColor: TeacherAppColors.error,
        ),
      );
    }
  }

  Future<void> _returnLoan(int loanId) async {
    final l10n = context.l10n;

    try {
      await ref
          .read(libraryActionControllerProvider.notifier)
          .returnLoan(loanId);
      if (!mounted) return;
      ref.invalidate(libraryOverviewProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.libraryReturnedSuccess),
          backgroundColor: TeacherAppColors.success,
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ApiErrorHandler.readableMessage(error)),
          backgroundColor: TeacherAppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final overviewAsync = ref.watch(libraryOverviewProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.libraryMenuTitle),
        backgroundColor:
            theme.appBarTheme.backgroundColor ?? colorScheme.surface,
        foregroundColor:
            theme.appBarTheme.foregroundColor ?? colorScheme.onSurface,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: l10n.librarySearchHint,
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
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
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    children: [
                      _SectionHeader(
                        title: l10n.libraryMyBooksTitle,
                        subtitle: l10n.libraryLoanRecordsCount(
                          overview.loansResponse.loans.length,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (overview.loansResponse.loans.isEmpty)
                        _EmptyCard(
                          icon: Icons.menu_book_outlined,
                          message: l10n.libraryNoLoansMessage,
                        )
                      else
                        ...overview.loansResponse.loans.map(
                          (loan) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _LoanCard(
                              loan: loan,
                              onReturn: loan.isBorrowed
                                  ? () => _returnLoan(loan.id)
                                  : null,
                            ),
                          ),
                        ),
                      const SizedBox(height: 24),
                      _SectionHeader(
                        title: l10n.libraryCatalogTitle,
                        subtitle: l10n.libraryAvailableBooksCount(
                          overview.booksResponse.total,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (overview.booksResponse.books.isEmpty)
                        _EmptyCard(
                          icon: Icons.search_off_outlined,
                          message: l10n.libraryNoBooksMessage,
                        )
                      else
                        ...overview.booksResponse.books.map(
                          (book) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _BookCard(
                              book: book,
                              isBorrowed: borrowedBookIds.contains(book.id),
                              onBorrow:
                                  book.canBorrow &&
                                      !borrowedBookIds.contains(book.id)
                                  ? () => _borrowBook(book.id)
                                  : null,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
              loading: () => AppLoadingView(
                title: l10n.libraryLoadingTitle,
                subtitle: l10n.libraryLoadingSubtitle,
              ),
              error: (error, stack) => AppErrorView(
                title: l10n.libraryLoadErrorTitle,
                message: ApiErrorHandler.readableMessage(error),
                icon: Icons.menu_book_outlined,
                onRetry: () => ref.invalidate(libraryOverviewProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(subtitle, style: TextStyle(color: colorScheme.onSurfaceVariant)),
      ],
    );
  }
}

class _EmptyCard extends StatelessWidget {
  final IconData icon;
  final String message;

  const _EmptyCard({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.7)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: colorScheme.onSurfaceVariant),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
        ],
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  book?.title ?? l10n.libraryBookFallback,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: loan.isBorrowed
                      ? TeacherAppColors.warning.withValues(alpha: 0.12)
                      : TeacherAppColors.success.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  loan.isBorrowed
                      ? l10n.libraryBorrowedStatus
                      : l10n.libraryReturnedStatus,
                  style: TextStyle(
                    color: loan.isBorrowed
                        ? TeacherAppColors.warning
                        : TeacherAppColors.success,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          if (book?.author != null) ...[
            const SizedBox(height: 8),
            Text(
              l10n.libraryAuthorLabel(book!.author!),
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            l10n.libraryBorrowedDateLabel(_formatDate(loan.borrowedAt, l10n)),
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
          Text(
            loan.isBorrowed
                ? l10n.libraryDueDateLabel(_formatDate(loan.dueAt, l10n))
                : l10n.libraryReturnedDateLabel(
                    _formatDate(loan.returnedAt, l10n),
                  ),
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
          if (onReturn != null) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onReturn,
                icon: const Icon(Icons.assignment_return_outlined),
                label: Text(l10n.libraryReturnAction),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(String? rawDate, AppLocalizations l10n) {
    if (rawDate == null || rawDate.isEmpty) {
      return '-';
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
}

class _BookCard extends StatelessWidget {
  final BookData book;
  final bool isBorrowed;
  final VoidCallback? onBorrow;

  const _BookCard({
    required this.book,
    required this.isBorrowed,
    required this.onBorrow,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.menu_book_outlined,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title.isNotEmpty
                          ? book.title
                          : l10n.libraryBookFallback,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    if (book.author != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        book.author!,
                        style: TextStyle(color: colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _InfoChip(
                label: l10n.libraryCopiesLabel(
                  book.availableCopies,
                  book.totalCopies,
                ),
              ),
              if (book.category != null) _InfoChip(label: book.category!),
              if (book.isbn != null)
                _InfoChip(label: l10n.libraryIsbnLabel(book.isbn!)),
            ],
          ),
          if (book.description != null) ...[
            const SizedBox(height: 12),
            Text(
              book.description!,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: onBorrow,
              style: ElevatedButton.styleFrom(
                backgroundColor: isBorrowed
                    ? colorScheme.surfaceContainerHighest
                    : colorScheme.primary,
                foregroundColor: isBorrowed
                    ? colorScheme.onSurfaceVariant
                    : colorScheme.onPrimary,
              ),
              child: Text(
                isBorrowed
                    ? l10n.libraryBorrowedStatus
                    : book.canBorrow
                    ? l10n.libraryBorrowAction
                    : l10n.libraryUnavailableAction,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;

  const _InfoChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
