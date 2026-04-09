import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_service.dart';

class LibraryApi {
  final ApiService _apiService;

  LibraryApi(this._apiService);

  Future<Response> getBooks({String? query, int perPage = 20}) async {
    return _apiService.dio.get(
      ApiConstants.libraryBooks,
      queryParameters: {
        'per_page': perPage,
        if (query != null && query.isNotEmpty) 'q': query,
      },
    );
  }

  Future<Response> getMyLoans() async {
    return _apiService.dio.get(ApiConstants.libraryMyLoans);
  }

  Future<Response> borrowBook(int bookId) async {
    return _apiService.dio.post(ApiConstants.borrowBook(bookId));
  }

  Future<Response> returnLoan(int loanId) async {
    return _apiService.dio.post(ApiConstants.returnLoan(loanId));
  }
}
