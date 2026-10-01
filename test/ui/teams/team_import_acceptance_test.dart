import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../testing/app.dart';
import '../../../testing/showdown_pastes.dart';
import '../../../testing/team_import_actions.dart';

void main() {
  testWidgets('import Team 1 from Showdown, open it, and see Mega Metagross '
      'at 178 Speed', (tester) async {
    tester.view.physicalSize = const Size(1200, 2400);
    addTearDown(tester.view.reset);
    await pumpApp(tester);
    await tester.tap(find.text('Teams'));
    await tester.pumpAndSettle();

    await importTeam(tester, name: 'Worlds Metagross', paste: team1Paste);
    expect(find.text('Worlds Metagross'), findsOneWidget);

    await tester.tap(find.text('Worlds Metagross'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Speed order'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(tester.widget<Text>(speedTier('Metagross-Mega')).data, '178');
    expect(tester.widget<Text>(speedTier('Raichu-Mega-Y')).data, '200');
    // Fastest first: Mega Raichu Y (200) tops the list.
    final tiers = find.byKey(const ValueKey('speed'));
    expect(tester.widget<Text>(tiers.first).data, '200');
  });
}
