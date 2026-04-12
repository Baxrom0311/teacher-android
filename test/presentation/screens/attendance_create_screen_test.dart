import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:teacher_school_app/data/models/attendance_model.dart';
import 'package:teacher_school_app/presentation/providers/attendance_provider.dart';
import 'package:teacher_school_app/presentation/screens/attendance/attendance_create_screen.dart';

import '../../helpers/test_app.dart';

class _FakeAttendanceController extends StateNotifier<AttendanceSessionState>
    implements AttendanceController {
  _FakeAttendanceController({AttendanceDetail? detail})
    : super(AttendanceSessionState(detail: detail));

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
    final detail = AttendanceDetail(
      session: AttendanceSession(
        id: 1,
        timetableEntryId: 1,
        subjectName: 'Matematika',
        groupName: '7-A',
        date: '2026-04-06',
        createdAt: '2026-04-06T08:00:00',
      ),
      rows: [
        AttendanceRow(
          id: 1,
          studentId: 1,
          studentName: 'O\'quvchi 1',
          status: 'present',
        ),
      ],
    );

    await tester.pumpWidget(
      buildTestApp(
        const AttendanceCreateScreen(),
        overrides: [
          attendanceOptionsProvider.overrideWith((ref) => options),
          attendanceControllerProvider.overrideWith(
            (ref) => _FakeAttendanceController(detail: detail),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Davomat yo\'qlash'), findsOneWidget);
    expect(find.text('SAQLASH'), findsOneWidget);
    expect(find.text('O\'quvchi 1'), findsOneWidget);
    expect(find.text('Keldi'), findsWidgets);
    expect(find.text('Kelmadi'), findsWidgets);
  });
}
