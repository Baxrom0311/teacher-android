import '../../core/network/api_error_handler.dart';
import '../datasources/remote/timetable_api.dart';
import '../models/school_period_model.dart';
import '../models/timetable_model.dart';

class TimetableRepository {
  final TimetableApi _api;

  TimetableRepository(this._api);

  Future<Map<String, dynamic>> fetchTimetable({
    int? quarterId,
    String? date,
    int days = 7,
  }) async {
    try {
      final response = await _api.getTimetable(
        quarterId: quarterId,
        date: date,
        days: days,
      );
      final data = response.data;

      final schedule = <String, List<TimetableEntry>>{};
      if (data['schedule_by_date'] != null) {
        final rawSchedule = data['schedule_by_date'] as Map<String, dynamic>;
        rawSchedule.forEach((dateString, entriesRaw) {
          final entries = (entriesRaw as List)
              .map((e) => TimetableEntry.fromJson(e, dateString))
              .toList();
          schedule[dateString] = entries;
        });
      }

      return {
        'dates': List<String>.from(data['dates'] ?? []),
        'schedule_by_date': schedule,
        'current_year': data['current_year'] != null
            ? AcademicYear.fromJson(data['current_year'])
            : null,
        'current_quarter': data['current_quarter'] != null
            ? Quarter.fromJson(data['current_quarter'])
            : null,
      };
    } catch (error, stackTrace) {
      ApiErrorHandler.throwAsException(error, stackTrace);
    }
  }
}
