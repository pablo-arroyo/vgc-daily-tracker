import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../testing/app.dart';
import '../../testing/team_editor_actions.dart';

/// Teams tab on the real app: create → list → edit → delete (with undo).
void teamsJourney() {
  testWidgets('create, list, edit and delete a team', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('Teams'));
    await tester.pumpAndSettle();
    expect(find.text('No teams saved yet.'), findsOneWidget);

    await createTeam(
      tester,
      name: 'Rillaboom Offense',
      picks: const [
        ('rilla', 'Rillaboom'),
        ('incin', 'Incineroar'),
        ('king', 'Kingambit'),
        ('whim', 'Whimsicott'),
        ('garch', 'Garchomp'),
        ('raichu', 'Raichu-Mega-Y'),
      ],
    );
    expect(find.text('Rillaboom Offense'), findsOneWidget);

    await tester.tap(find.byTooltip('Edit Rillaboom Offense'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'Team name'),
      'Grassy Offense',
    );
    await tapSave(tester);
    expect(find.text('Grassy Offense'), findsOneWidget);

    await tester.tap(find.byTooltip('Delete Grassy Offense'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();
    expect(find.text('No teams saved yet.'), findsOneWidget);
  });
}
