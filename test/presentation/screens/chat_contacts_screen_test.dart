import 'package:flutter_test/flutter_test.dart';
import 'package:teacher_school_app/data/models/chat_model.dart';
import 'package:teacher_school_app/presentation/providers/chat_provider.dart';
import 'package:teacher_school_app/presentation/screens/chat/chat_contacts_screen.dart';

import '../../helpers/test_app.dart';

void main() {
  testWidgets('chat contacts screen renders localized contact list', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        const ChatContactsScreen(),
        overrides: [
          chatContactsProvider.overrideWith(
            (ref) => [
              ChatContact(
                id: 7,
                name: 'Aziza',
                role: 'parent',
                lastMessage: 'Salom',
                lastMessageAt: '2026-04-07 09:15:00',
                unreadCount: 3,
              ),
            ],
          ),
        ],
      ),
    );
    await tester.pump();

    expect(find.text('Xabarlar'), findsOneWidget);
    expect(find.text('Aziza'), findsOneWidget);
    expect(find.text('Salom'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
  });
}
