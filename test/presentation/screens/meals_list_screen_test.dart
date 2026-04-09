import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teacher_school_app/data/models/meal_model.dart';
import 'package:teacher_school_app/l10n/app_localizations.dart';
import 'package:teacher_school_app/presentation/providers/meal_provider.dart';
import 'package:teacher_school_app/presentation/screens/meals/meals_list_screen.dart';

import '../../helpers/test_app.dart';

void main() {
  testWidgets('meals list screen renders localized labels and selected meal', (
    tester,
  ) async {
    final l10n = lookupAppLocalizations(const Locale('uz'));
    final response = MealIndexResponse(
      groups: [MealGroupData(id: 1, name: '1-A')],
      currentGroup: MealGroupData(id: 1, name: '1-A'),
      groupId: 1,
      report: null,
      today: '2026-04-06',
      mealTypes: const ['breakfast', 'lunch', 'dinner'],
      selectedType: 'breakfast',
      selectedName: 'Sho\'rva',
      selectedRecipe: 'Go\'sht, kartoshka, sabzi',
      mediaByType: const {},
    );

    await tester.pumpWidget(
      buildTestApp(
        const MealsListScreen(),
        overrides: [mealsIndexProvider.overrideWith((ref) => response)],
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text(l10n.mealsReportTitle), findsOneWidget);
    expect(find.text(l10n.mealsDateLabel('2026-04-06')), findsOneWidget);
    expect(find.text(l10n.mealsNameLabel), findsOneWidget);
    expect(find.text(l10n.mealsRecipeLabel), findsOneWidget);
    expect(find.text(l10n.mealsImagesLabel), findsOneWidget);
    expect(find.text(l10n.mealsSaveAction), findsOneWidget);
    expect(find.text('Sho\'rva'), findsOneWidget);
    expect(find.text(l10n.mealTypeLabel('breakfast')), findsOneWidget);
  });
}
