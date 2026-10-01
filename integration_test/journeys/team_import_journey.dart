import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../testing/app.dart';
import '../../testing/showdown_pastes.dart';
import '../../testing/team_import_actions.dart';

/// Import the Reg M-C artifact's Team 1 and read its Speed order.
void teamImportJourney() {
  testWidgets('import Team 1, open it: Mega Metagross is at 178 Speed', (
    tester,
  ) async {
    await pumpApp(tester);
    await tester.tap(find.text('Teams'));
    await tester.pumpAndSettle();

    await importTeam(tester, name: 'Worlds Metagross', paste: team1Paste);
    await tester.tap(find.text('Worlds Metagross'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      speedTier('Metagross-Mega'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(tester.widget<Text>(speedTier('Metagross-Mega')).data, '178');
  });
}
