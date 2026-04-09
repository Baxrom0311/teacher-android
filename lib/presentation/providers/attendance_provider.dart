import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_error_handler.dart';
import '../../data/datasources/remote/attendance_api.dart';
import '../../data/models/attendance_model.dart';
import '../../data/repositories/attendance_repository.dart';
import '../../core/storage/outbox_service.dart';
import 'auth_provider.dart';

// Dependency injection
final attendanceApiProvider = Provider<AttendanceApi>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return AttendanceApi(apiService);
});

final attendanceRepositoryProvider = Provider<AttendanceRepository>((ref) {
  final api = ref.watch(attendanceApiProvider);
  final outbox = ref.watch(outboxServiceProvider);
  return AttendanceRepository(api, outbox);
});

// FutureProvider for fetching options globally
final attendanceOptionsProvider = FutureProvider<List<AttendanceOption>>((
  ref,
) async {
  final repository = ref.watch(attendanceRepositoryProvider);
  return repository.fetchAttendanceOptions();
});

// StateNotifier for creating / editing attendance
class AttendanceSessionState {
  final bool isLoading;
  final String? error;
  final AttendanceDetail? detail;

  AttendanceSessionState({this.isLoading = false, this.error, this.detail});

  AttendanceSessionState copyWith({
    bool? isLoading,
    String? error,
    AttendanceDetail? detail,
  }) {
    return AttendanceSessionState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      detail: detail ?? this.detail,
    );
  }
}

class AttendanceController extends StateNotifier<AttendanceSessionState> {
  final AttendanceRepository _repository;

  AttendanceController(this._repository) : super(AttendanceSessionState());

  // Called when we first load an attendance detail or prep for creation
  void setInitialDetail(AttendanceDetail detail) {
    state = state.copyWith(detail: detail, isLoading: false, error: null);
  }

  void updateStudentStatus(int studentId, String status) {
    if (state.detail == null) return;

    final updatedRows = state.detail!.rows.map((row) {
      if (row.studentId == studentId) {
        return row.copyWith(status: status);
      }
      return row;
    }).toList();

    state = state.copyWith(
      detail: AttendanceDetail(
        session: state.detail!.session,
        rows: updatedRows,
      ),
    );
  }

  Future<bool> createAttendance({
    required int quarterId,
    required int timetableEntryId,
    required String date,
  }) async {
    if (state.detail == null) return false;

    state = state.copyWith(isLoading: true, error: null);
    try {
      final updatedDetail = await _repository.createAttendance(
        quarterId,
        timetableEntryId,
        date,
        state.detail!.rows,
      );
      state = state.copyWith(isLoading: false, detail: updatedDetail);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: ApiErrorHandler.readableMessage(e),
      );
      return false;
    }
  }

  Future<bool> updateExistingAttendance(int sessionId) async {
    if (state.detail == null) return false;

    state = state.copyWith(isLoading: true, error: null);
    try {
      final updatedDetail = await _repository.updateAttendance(
        sessionId,
        state.detail!.rows,
      );
      state = state.copyWith(isLoading: false, detail: updatedDetail);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: ApiErrorHandler.readableMessage(e),
      );
      return false;
    }
  }
}

final attendanceControllerProvider =
    StateNotifierProvider.autoDispose<
      AttendanceController,
      AttendanceSessionState
    >((ref) {
      final repository = ref.watch(attendanceRepositoryProvider);
      return AttendanceController(repository);
    });

// ─── Absence Excuses ───

final absenceExcusesProvider = FutureProvider.family<List<dynamic>, String?>((
  ref,
  status,
) {
  return ref
      .watch(attendanceRepositoryProvider)
      .fetchAbsenceExcuses(status: status);
});

class AbsenceReviewNotifier extends StateNotifier<AsyncValue<void>> {
  final AttendanceRepository _repository;
  final Ref _ref;

  AbsenceReviewNotifier(this._repository, this._ref)
    : super(const AsyncValue.data(null));

  Future<bool> review(int id, String status) async {
    state = const AsyncValue.loading();
    try {
      await _repository.reviewExcuse(id, status);
      state = const AsyncValue.data(null);
      _ref.invalidate(absenceExcusesProvider);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

final absenceReviewControllerProvider =
    StateNotifierProvider<AbsenceReviewNotifier, AsyncValue<void>>((ref) {
      return AbsenceReviewNotifier(
        ref.watch(attendanceRepositoryProvider),
        ref,
      );
    });
