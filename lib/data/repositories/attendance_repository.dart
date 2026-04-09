import 'package:dio/dio.dart';
import '../../core/network/api_error_handler.dart';
import '../datasources/remote/attendance_api.dart';
import '../models/attendance_model.dart';
import '../../core/storage/outbox_service.dart';
import './base_repository.dart';

class AttendanceRepository extends BaseRepository {
  final AttendanceApi _api;
  final OutboxService _outbox;

  AttendanceRepository(this._api, this._outbox);

  Future<List<AttendanceSession>> fetchAttendanceSessions(
    int quarterId,
    String date,
  ) async {
    return safeCallList(
      () => _api.getAttendanceSessions(quarterId, date),
      (data) => AttendanceSession.fromJson(data),
      listKey: 'sessions',
    );
  }

  Future<List<AttendanceOption>> fetchAttendanceOptions() async {
    return safeCallList(
      () => _api.getAttendanceOptions(),
      (data) => AttendanceOption.fromJson(data),
      listKey: 'statuses',
    );
  }

  Future<AttendanceDetail> fetchAttendanceDetail(int id) async {
    return safeCall(
      () => _api.getAttendanceDetail(id),
      (data) => AttendanceDetail.fromJson(data),
    );
  }

  Future<AttendanceDetail> createAttendance(
    int quarterId,
    int timetableEntryId,
    String date,
    List<AttendanceRow> rows, {
    String? clientActionId,
  }) async {
    final mappedRows = rows
        .map((r) => {'student_id': r.studentId, 'status': r.status})
        .toList();
    try {
      final response = await _api.createAttendance(
        quarterId,
        timetableEntryId,
        date,
        mappedRows,
        clientActionId: clientActionId,
      );
      return AttendanceDetail.fromJson(response.data);
    } catch (error, stackTrace) {
      if (error is DioException && ApiErrorHandler.isNetworkError(error)) {
        await _outbox.queueAction(
          OutboxAction(
            id: 'att_create_${DateTime.now().millisecondsSinceEpoch}',
            type: OutboxActionType.markAttendance,
            payload: {
              'quarter_id': quarterId,
              'timetable_entry_id': timetableEntryId,
              'date': date,
              'rows': mappedRows,
            },
            queuedAt: DateTime.now(),
          ),
        );
        ApiErrorHandler.throwAsException(
          'Offline: Yo\'qlama saqlandi va internet ulanganda yuboriladi.',
          stackTrace,
        );
      }

      ApiErrorHandler.throwAsException(error, stackTrace);
    }
  }

  Future<AttendanceDetail> updateAttendance(
    int id,
    List<AttendanceRow> rows,
  ) async {
    final mappedRows = rows
        .map(
          (r) => {
            'student_id': r.studentId,
            'status': r.status,
            'note': r.note,
          },
        )
        .toList();
    try {
      final response = await _api.updateAttendance(id, mappedRows);
      return AttendanceDetail.fromJson(response.data);
    } catch (error, stackTrace) {
      if (error is DioException && ApiErrorHandler.isNetworkError(error)) {
        await _outbox.queueAction(
          OutboxAction(
            id: 'att_update_${id}_${DateTime.now().millisecondsSinceEpoch}',
            type: OutboxActionType.updateAttendance,
            payload: {'attendance_id': id, 'rows': mappedRows},
            queuedAt: DateTime.now(),
          ),
        );
        ApiErrorHandler.throwAsException(
          'Offline: O\'zgarishlar saqlandi va internet ulanganda yuboriladi.',
          stackTrace,
        );
      }

      ApiErrorHandler.throwAsException(error, stackTrace);
    }
  }

  Future<List<dynamic>> fetchAbsenceExcuses({String? status}) async {
    return safeCallList(
      () => _api.getAbsenceExcuses(status: status),
      (data) => data,
    );
  }

  Future<void> reviewExcuse(int id, String status) async {
    await safeCall(() => _api.reviewExcuse(id, status), (data) => data);
  }
}
