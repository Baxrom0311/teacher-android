import 'package:flutter_test/flutter_test.dart';
import 'package:teacher_school_app/data/models/library_model.dart';
import 'package:teacher_school_app/presentation/providers/library_provider.dart';
import 'package:teacher_school_app/presentation/screens/library/library_screen.dart';

import '../../helpers/test_app.dart';

void main() {
  testWidgets('library screen shows loans and available books', (tester) async {
    const algebraBook = BookData(
      id: 1,
      title: 'Algebra',
      author: 'A. Karimov',
      category: 'Matematika',
      totalCopies: 4,
      availableCopies: 2,
      isActive: true,
    );

    const overview = LibraryOverview(
      booksResponse: LibraryBooksResponse(
        books: [
          algebraBook,
          BookData(
            id: 2,
            title: 'Fizika 101',
            author: 'N. Qodirov',
            totalCopies: 3,
            availableCopies: 1,
            isActive: true,
          ),
        ],
        currentPage: 1,
        lastPage: 1,
        total: 2,
      ),
      loansResponse: LibraryLoansResponse(
        loans: [
          BookLoanData(
            id: 9,
            status: 'borrowed',
            borrowedAt: '2026-04-01',
            dueAt: '2026-04-15',
            book: algebraBook,
          ),
        ],
      ),
    );

    await tester.pumpWidget(
      buildTestApp(
        const LibraryScreen(),
        overrides: [libraryOverviewProvider.overrideWith((ref) => overview)],
      ),
    );
    await tester.pump();

    expect(find.text('Mening kitoblarim'), findsOneWidget);
    expect(find.text('Katalog'), findsOneWidget);
    expect(find.text('Algebra'), findsWidgets);
    expect(find.text('Qo‘lingizda'), findsWidgets);
    expect(find.text('Kutubxona'), findsOneWidget);
  });

  testWidgets('library screen falls back when book title is empty', (
    tester,
  ) async {
    const overview = LibraryOverview(
      booksResponse: LibraryBooksResponse(
        books: [
          BookData(
            id: 5,
            title: '',
            author: null,
            totalCopies: 2,
            availableCopies: 1,
            isActive: true,
          ),
        ],
        currentPage: 1,
        lastPage: 1,
        total: 1,
      ),
      loansResponse: LibraryLoansResponse(loans: []),
    );

    await tester.pumpWidget(
      buildTestApp(
        const LibraryScreen(),
        overrides: [libraryOverviewProvider.overrideWith((ref) => overview)],
      ),
    );
    await tester.pump();

    expect(find.text('Kitob'), findsOneWidget);
  });
}
