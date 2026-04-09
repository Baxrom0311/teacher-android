import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teacher_school_app/presentation/widgets/app_feedback.dart';

import '../../helpers/test_app.dart';

void main() {
  testWidgets('app feedback widgets render localized content', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        const Scaffold(
          body: Column(
            children: [
              AppErrorView(message: 'Xato matni'),
              AppEmptyView(message: 'Bo`sh holat'),
              AppInlineMessageCard(
                message: 'Muvaffaqiyatli saqlandi',
                type: AppInlineMessageType.success,
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Xato matni'), findsOneWidget);
    expect(find.text('Bo`sh holat'), findsOneWidget);
    expect(find.text('Muvaffaqiyatli saqlandi'), findsOneWidget);
    expect(find.byType(AppErrorView), findsOneWidget);
    expect(find.byType(AppEmptyView), findsOneWidget);
    expect(find.byType(AppInlineMessageCard), findsOneWidget);
  });
}
