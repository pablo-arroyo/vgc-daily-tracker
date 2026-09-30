import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../testing/app.dart';
import '../../../testing/team_editor_actions.dart';

void main() {
  testWidgets('create a team with six Pokémon, then edit its name', (
    tester,
  ) async {
    await pumpApp(tester);
    await tester.tap(find.text('Teams'));
    await tester.pumpAndSettle();

    await createTeam(
      tester,
      name: 'Big Six',
      picks: const [
        ('king', 'Kingambit'),
        ('whim', 'Whimsicott'),
        ('garch', 'Garchomp'),
        ('incin', 'Incineroar'),
        ('rilla', 'Rillaboom'),
        ('chariz', 'Charizard'),
      ],
    );

    expect(find.text('Big Six'), findsOneWidget);
    expect(find.text('Garchomp'), findsOneWidget);

    await tester.tap(find.byTooltip('Edit Big Six'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'Team name'),
      'Big Six (Worlds)',
    );
    await tapSave(tester);

    expect(find.text('Big Six (Worlds)'), findsOneWidget);
    expect(find.text('Big Six'), findsNothing);
  });
}
