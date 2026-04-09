import '../../core/network/api_error_handler.dart';
import '../datasources/remote/library_api.dart';
import '../models/library_model.dart';

class LibraryRepository {
  final LibraryApi _api;

  LibraryRepository(this._api);

  Future<LibraryBooksResponse> fetchBooks({
    String? query,
    int perPage = 20,
  }) async {
    try {
      final response = await _api.getBooks(query: query, perPage: perPage);
      return LibraryBooksResponse.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );
    } catch (error, stackTrace) {
      ApiErrorHandler.throwAsException(error, stackTrace);
    }
  }

  Future<LibraryLoansResponse> fetchMyLoans() async {
    try {
      final response = await _api.getMyLoans();
      return LibraryLoansResponse.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );
    } catch (error, stackTrace) {
      ApiErrorHandler.throwAsException(error, stackTrace);
    }
  }

  Future<void> borrowBook(int bookId) async {
    try {
      await _api.borrowBook(bookId);
    } catch (error, stackTrace) {
      ApiErrorHandler.throwAsException(error, stackTrace);
    }
  }

  Future<void> returnLoan(int loanId) async {
    try {
      await _api.returnLoan(loanId);
    } catch (error, stackTrace) {
      ApiErrorHandler.throwAsException(error, stackTrace);
    }
  }
}
