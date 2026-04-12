import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:teacher_school_app/data/repositories/profile_repository.dart';
import 'package:teacher_school_app/l10n/app_localizations.dart';
import 'package:teacher_school_app/presentation/providers/profile_provider.dart';
import 'package:teacher_school_app/presentation/screens/profile/portfolio_work_create_screen.dart';

import '../../helpers/test_app.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  testWidgets('portfolio work create screen renders localized form', (
    tester,
  ) async {
    final l10n = lookupAppLocalizations(const Locale('uz'));
    await tester.pumpWidget(
      buildTestApp(
        const PortfolioWorkCreateScreen(),
        overrides: [
          profileControllerProvider.overrideWith(
            (ref) => ProfileController(MockProfileRepository()),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(l10n.portfolioCreateTitle), findsOneWidget);
    expect(find.text(l10n.portfolioWorkTitleLabel), findsOneWidget);
    expect(find.text(l10n.portfolioPublishedPlaceLabel), findsOneWidget);
    expect(
      find.text(l10n.portfolioCoauthorSearchTitle.toUpperCase()),
      findsOneWidget,
    );
    expect(find.text(l10n.pdfOnlyFileLabel.toUpperCase()), findsOneWidget);
    expect(find.text(l10n.saveAction.toUpperCase()), findsOneWidget);
  });
}
