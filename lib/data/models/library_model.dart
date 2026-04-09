int _libraryInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

String? _libraryString(dynamic value) {
  final text = value?.toString();
  if (text == null || text.isEmpty) {
    return null;
  }
  return text;
}

bool _libraryBool(dynamic value) {
  if (value is bool) return value;
  return value == 1 || value == '1' || value == 'true';
}

class BookData {
  final int id;
  final String title;
  final String? author;
  final String? isbn;
  final String? category;
  final int totalCopies;
  final int availableCopies;
  final String? description;
  final String? coverImage;
  final bool isActive;

  const BookData({
    required this.id,
    required this.title,
    this.author,
    this.isbn,
    this.category,
    required this.totalCopies,
    required this.availableCopies,
    this.description,
    this.coverImage,
    required this.isActive,
  });

  bool get canBorrow => isActive && availableCopies > 0;

  factory BookData.fromJson(Map<String, dynamic> json) {
    return BookData(
      id: _libraryInt(json['id']),
      title: _libraryString(json['title']) ?? '',
      author: _libraryString(json['author']),
      isbn: _libraryString(json['isbn']),
      category: _libraryString(json['category']),
      totalCopies: _libraryInt(json['total_copies']),
      availableCopies: _libraryInt(json['available_copies']),
      description: _libraryString(json['description']),
      coverImage: _libraryString(json['cover_image']),
      isActive: _libraryBool(json['is_active']),
    );
  }
}

class BookLoanData {
  final int id;
  final String status;
  final String? borrowedAt;
  final String? dueAt;
  final String? returnedAt;
  final BookData? book;

  const BookLoanData({
    required this.id,
    required this.status,
    this.borrowedAt,
    this.dueAt,
    this.returnedAt,
    this.book,
  });

  bool get isBorrowed => status == 'borrowed';

  factory BookLoanData.fromJson(Map<String, dynamic> json) {
    final rawBook = json['book'];
    return BookLoanData(
      id: _libraryInt(json['id']),
      status: _libraryString(json['status']) ?? 'borrowed',
      borrowedAt: _libraryString(json['borrowed_at']),
      dueAt: _libraryString(json['due_at']),
      returnedAt: _libraryString(json['returned_at']),
      book: rawBook is Map<String, dynamic>
          ? BookData.fromJson(rawBook)
          : rawBook is Map
          ? BookData.fromJson(Map<String, dynamic>.from(rawBook))
          : null,
    );
  }
}

class LibraryBooksResponse {
  final List<BookData> books;
  final int currentPage;
  final int lastPage;
  final int total;

  const LibraryBooksResponse({
    required this.books,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  factory LibraryBooksResponse.fromJson(Map<String, dynamic> json) {
    final pagination = Map<String, dynamic>.from(
      json['pagination'] as Map? ?? const {},
    );

    return LibraryBooksResponse(
      books:
          (json['books'] as List?)
              ?.map(
                (item) =>
                    BookData.fromJson(Map<String, dynamic>.from(item as Map)),
              )
              .toList() ??
          const [],
      currentPage: _libraryInt(pagination['current_page']),
      lastPage: _libraryInt(pagination['last_page']),
      total: _libraryInt(pagination['total']),
    );
  }
}

class LibraryLoansResponse {
  final List<BookLoanData> loans;

  const LibraryLoansResponse({required this.loans});

  factory LibraryLoansResponse.fromJson(Map<String, dynamic> json) {
    return LibraryLoansResponse(
      loans:
          (json['loans'] as List?)
              ?.map(
                (item) => BookLoanData.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ),
              )
              .toList() ??
          const [],
    );
  }
}

class LibraryOverview {
  final LibraryBooksResponse booksResponse;
  final LibraryLoansResponse loansResponse;

  const LibraryOverview({
    required this.booksResponse,
    required this.loansResponse,
  });
}
