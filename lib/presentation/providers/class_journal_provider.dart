import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_error_handler.dart';
import '../../data/datasources/remote/class_journal_api.dart';
import '../../data/models/class_journal_model.dart';
import 'auth_provider.dart';

final classJournalApiProvider = Provider<ClassJournalApi>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return ClassJournalApi(apiService);
});

class ClassJournalState {
  final bool isLoading;
  final String? error;
  final ClassJournalResponse? journal;
  final String selectedDate;

  ClassJournalState({
    this.isLoading = false,
    this.error,
    this.journal,
    String? selectedDate,
  }) : selectedDate = selectedDate ?? _todayStr();

  static String _todayStr() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  ClassJournalState copyWith({
    bool? isLoading,
    String? error,
    ClassJournalResponse? journal,
    String? selectedDate,
  }) {
    return ClassJournalState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      journal: journal ?? this.journal,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }
}

class ClassJournalNotifier extends StateNotifier<ClassJournalState> {
  final ClassJournalApi _api;

  ClassJournalNotifier(this._api) : super(ClassJournalState());

  Future<void> loadJournal(int groupId, {String? date}) async {
    final targetDate = date ?? state.selectedDate;
    state = state.copyWith(isLoading: true, selectedDate: targetDate);

    try {
      final response = await _api.getClassJournal(groupId, date: targetDate);
      final data = response.data;
      if (data is Map<String, dynamic>) {
        final journal = ClassJournalResponse.fromJson(data);
        state = state.copyWith(isLoading: false, journal: journal, error: null);
      } else {
        state = state.copyWith(isLoading: false, error: 'Invalid response');
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: ApiErrorHandler.readableMessage(e),
      );
    }
  }

  void changeDate(int groupId, String date) {
    loadJournal(groupId, date: date);
  }
}

final classJournalProvider =
    StateNotifierProvider.autoDispose<ClassJournalNotifier, ClassJournalState>(
  (ref) {
    final api = ref.watch(classJournalApiProvider);
    return ClassJournalNotifier(api);
  },
);
