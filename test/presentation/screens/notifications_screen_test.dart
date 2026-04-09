import 'package:flutter_test/flutter_test.dart';

import 'package:teacher_school_app/data/models/notification_model.dart';
import 'package:teacher_school_app/presentation/providers/notification_provider.dart';
import 'package:teacher_school_app/presentation/screens/notifications/notifications_screen.dart';

import '../../helpers/test_app.dart';

void main() {
  testWidgets('notifications screen renders localized empty state', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        const NotificationsScreen(),
        overrides: [
          notificationsProvider.overrideWith(
            (ref) => NotificationsResponse(
              notifications: const [],
              currentPage: 1,
              lastPage: 1,
            ),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Bildirishnomalar'), findsOneWidget);
    expect(find.text('Bildirishnomalar yo\'q'), findsOneWidget);
    expect(
      find.text('Hozircha siz uchun yangi bildirishnoma yo\'q.'),
      findsOneWidget,
    );
  });
}
