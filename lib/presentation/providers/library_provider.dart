import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/remote/library_api.dart';
import '../../data/models/library_model.dart';
import '../../data/repositories/library_repository.dart';
import 'auth_provider.dart';

final libraryApiProvider = Provider<LibraryApi>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return LibraryApi(apiService);
});

final libraryRepositoryProvider = Provider<LibraryRepository>((ref) {
  final api = ref.watch(libraryApiProvider);
  return LibraryRepository(api);
});

final libraryQueryProvider = StateProvider.autoDispose<String>((ref) => '');

final libraryOverviewProvider = FutureProvider.autoDispose<LibraryOverview>((
  ref,
) async {
  final repository = ref.watch(libraryRepositoryProvider);
  final query = ref.watch(libraryQueryProvider);

  final booksFuture = repository.fetchBooks(query: query);
  final loansFuture = repository.fetchMyLoans();

  final booksResponse = await booksFuture;
  final loansResponse = await loansFuture;

  return LibraryOverview(
    booksResponse: booksResponse,
    loansResponse: loansResponse,
  );
});

class LibraryActionController extends StateNotifier<AsyncValue<void>> {
  final LibraryRepository _repository;

  LibraryActionController(this._repository)
    : super(const AsyncValue.data(null));

  Future<void> borrowBook(int bookId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.borrowBook(bookId));
  }

  Future<void> returnLoan(int loanId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.returnLoan(loanId));
  }
}

final libraryActionControllerProvider =
    StateNotifierProvider.autoDispose<
      LibraryActionController,
      AsyncValue<void>
    >((ref) {
      final repository = ref.watch(libraryRepositoryProvider);
      return LibraryActionController(repository);
    });
