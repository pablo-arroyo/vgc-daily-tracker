import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../testing/app.dart';
import '../../../testing/team_import_actions.dart';

void main() {
  testWidgets("an empty Teams tab adds the format's 3 sample teams, each "
      'with full sets', (tester) async {
    tester.view.physicalSize = const Size(1200, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await pumpApp(tester);
    await tester.tap(find.text('Teams'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add Reg M-C sample teams'));
    await tester.pumpAndSettle();

    for (final name in [
      'Big Six',
      'Mega Metagross (Worlds 2026)',
      'Rillaboom / Sneasler Grassy Offense',
    ]) {
      expect(find.text(name), findsOneWidget);
    }
    expect(find.text('Add Reg M-C sample teams'), findsNothing);

    await tester.tap(find.text('Big Six'));
    await tester.pumpAndSettle();
    expect(tester.widget<Text>(speedTier('Charizard-Mega-Y')).data, '167');
    expect(tester.widget<Text>(speedTier('Floette-Mega')).data, '169');
  });
}
