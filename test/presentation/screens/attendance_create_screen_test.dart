import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:teacher_school_app/data/models/attendance_model.dart';
import 'package:teacher_school_app/presentation/providers/attendance_provider.dart';
import 'package:teacher_school_app/presentation/screens/attendance/attendance_create_screen.dart';

import '../../helpers/test_app.dart';

class _FakeAttendanceController extends StateNotifier<AttendanceSessionState>
    implements AttendanceController {
  _FakeAttendanceController() : super(AttendanceSessionState());

  @override
  Future<bool> createAttendance({
    required int quarterId,
    required int timetableEntryId,
    required String date,
  }) async {
    return true;
  }

  @override
  void setInitialDetail(AttendanceDetail detail) {
    state = state.copyWith(detail: detail);
  }

  @override
  Future<bool> updateExistingAttendance(int sessionId) async {
    return true;
  }

  @override
  void updateStudentStatus(int studentId, String status) {}
}

void main() {
  testWidgets('attendance create screen renders localized title and rows', (
    tester,
  ) async {
    final options = [
      AttendanceOption(value: 'present', label: 'Keldi'),
      AttendanceOption(value: 'absent', label: 'Kelmadi'),
    ];

    await tester.pumpWidget(
      buildTestApp(
        const AttendanceCreateScreen(),
        overrides: [
          attendanceOptionsProvider.overrideWith((ref) => options),
          attendanceControllerProvider.overrideWith(
            (ref) => _FakeAttendanceController(),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Davomat yo\'qlash'), findsOneWidget);
    expect(find.text('Saqlash'), findsOneWidget);
    expect(find.text('O\'quvchi 1'), findsOneWidget);
    expect(find.text('Keldi'), findsWidgets);
    expect(find.text('Kelmadi'), findsWidgets);
  });
}
