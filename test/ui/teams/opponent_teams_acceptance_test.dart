import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/config/format_config.dart';

import '../../../testing/app.dart';
import '../../../testing/team_import_actions.dart';

void main() {
  testWidgets('import an opponent team: it lists under Opponents only, and '
      'never as your team in Log Game', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('Teams'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Opponents'));
    await tester.pumpAndSettle();
    expect(find.text('No opponent teams saved yet.'), findsOneWidget);
    expect(find.text('Add Reg M-C sample teams'), findsNothing);

    await importTeam(
      tester,
      name: 'Grassy Offense (Worlds finals)',
      paste: FormatConfig.regMC.sampleTeams[1].paste,
    );
    expect(find.text('Grassy Offense (Worlds finals)'), findsOneWidget);

    await tester.tap(find.text('My teams'));
    await tester.pumpAndSettle();
    expect(find.text('Grassy Offense (Worlds finals)'), findsNothing);
    expect(find.text('No teams saved yet.'), findsOneWidget);

    await tester.tap(find.text('Log Game'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(InputDecorator, 'Your team used'));
    await tester.pumpAndSettle();
    expect(find.text('Grassy Offense (Worlds finals)'), findsNothing);
  });
}
