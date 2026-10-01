import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/domain/models/team.dart';

import '../../../testing/app.dart';
import '../../../testing/fakes/fake_pokemon_repository.dart';

void main() {
  final mine = Team(
    id: 't1',
    name: 'Big Six',
    pokemon: [FakePokemonRepository.sampleRef('kingambit')],
  );
  final rival = Team(
    id: 'o1',
    name: 'Rival Grassy',
    side: TeamSide.opponent,
    pokemon: [FakePokemonRepository.sampleRef('rillaboom')],
  );

  testWidgets('write a matchup note from your team; it shows on their team '
      'too', (tester) async {
    tester.view.physicalSize = const Size(1200, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await pumpApp(tester, teams: [mine, rival]);
    await tester.tap(find.text('Teams'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Big Six'));
    await tester.pumpAndSettle();

    expect(find.text('Matchup notes'), findsOneWidget);
    await tester.tap(find.widgetWithText(ListTile, 'Rival Grassy'));
    await tester.pumpAndSettle();
    expect(find.text('Big Six vs Rival Grassy'), findsOneWidget);
    await tester.enterText(
      find.widgetWithText(TextField, 'Game plan'),
      'Lead Whimsicott + Kingambit; Tailwind turn 1.',
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pumpAndSettle();
    expect(
      find.text('Lead Whimsicott + Kingambit; Tailwind turn 1.'),
      findsOneWidget,
    );

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Opponents'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Rival Grassy'));
    await tester.pumpAndSettle();
    expect(
      find.descendant(
        of: find.widgetWithText(ListTile, 'Big Six'),
        matching: find.text('Lead Whimsicott + Kingambit; Tailwind turn 1.'),
      ),
      findsOneWidget,
    );
  });
}
