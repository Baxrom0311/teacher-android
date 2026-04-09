import 'package:flutter_test/flutter_test.dart';
import 'package:teacher_school_app/data/models/dashboard_model.dart';
import 'package:teacher_school_app/data/models/library_model.dart';
import 'package:teacher_school_app/data/models/profile_model.dart';

void main() {
  test('teacher dashboard contract parses backend payload', () {
    final response = TeacherDashboardResponse.fromJson({
      'current_year': {'id': '12', 'name': '2025/2026'},
      'current_quarter': {'id': 3, 'name': '3-chorak'},
      'today': {
        'date': '2026-04-05',
        'lessons_total': '5',
        'sessions_open': 2,
        'sessions_closed': '1',
        'absent_count': 4,
      },
      'overview': {
        'groups_count': 3,
        'subjects_count': '4',
        'students_count': '96',
      },
      'recent_assessments': [
        {
          'id': '14',
          'title': 'Nazorat ishi',
          'date': '2026-04-04',
          'max_score': '100',
          'subject_name': 'Matematika',
          'group_name': '9-A',
        },
      ],
    });

    expect(response.currentYear?.id, 12);
    expect(response.today.lessonsTotal, 5);
    expect(response.overview.studentsCount, 96);
    expect(response.recentAssessments.single.subjectName, 'Matematika');
  });

  test('profile contract parses documents and coauthors', () {
    final response = ProfileResponse.fromJson({
      'teacher': {
        'id': 7,
        'name': 'Baxrom Ustoz',
        'email': 'teacher@example.com',
        'phone': '+998901234567',
        'passport_no': 'AA1234567',
      },
      'profile': {
        'id': 2,
        'user_id': 7,
        'university': 'SamDU',
        'graduation_date': '2016-06-20',
        'passport_url': 'https://example.com/passport.pdf',
      },
      'works': [
        {
          'id': 11,
          'title': 'Ilmiy maqola',
          'created_by': 7,
          'authors': [
            {'id': 7, 'name': 'Baxrom Ustoz'},
            {'id': 9, 'name': 'Dilnoza Ustoz'},
          ],
        },
      ],
      'can_edit': true,
    });

    expect(response.teacher.passportNo, 'AA1234567');
    expect(response.profile?.passportUrl, isNotNull);
    expect(response.works.single.authors.length, 2);
    expect(response.works.single.authors.last.name, 'Dilnoza Ustoz');
  });

  test('library contract parses books and active loans', () {
    final books = LibraryBooksResponse.fromJson({
      'books': [
        {
          'id': '1',
          'title': 'Algebra',
          'available_copies': '2',
          'total_copies': 3,
          'is_active': true,
        },
      ],
      'pagination': {'current_page': 1, 'last_page': 1, 'total': '1'},
    });

    final loans = LibraryLoansResponse.fromJson({
      'loans': [
        {
          'id': 5,
          'status': 'borrowed',
          'book': {
            'id': 1,
            'title': 'Algebra',
            'available_copies': 2,
            'total_copies': 3,
            'is_active': true,
          },
        },
      ],
    });

    expect(books.books.single.canBorrow, isTrue);
    expect(loans.loans.single.isBorrowed, isTrue);
    expect(loans.loans.single.book?.title, 'Algebra');
  });
}
