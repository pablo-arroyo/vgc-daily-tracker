import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/domain/models/team.dart';

import '../../../testing/app.dart';
import '../../../testing/fakes/fake_pokemon_repository.dart';
import '../../../testing/log_game_actions.dart';
import '../../../testing/progress_actions.dart';

void main() {
  final rival = Team(
    id: 'o1',
    name: 'Rival Grassy',
    side: TeamSide.opponent,
    pokemon: [
      for (final slug in [
        'rillaboom',
        'sneasler',
        'incineroar',
        'kingambit',
        'salamence',
        'grimmsnarl',
      ])
        FakePokemonRepository.sampleRef(slug),
    ],
  );

  testWidgets("pick a saved opponent team: its 6 Pokémon fill the opponent's "
      'slots and the game is logged against them', (tester) async {
    tester.view.physicalSize = const Size(1200, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await pumpApp(tester, teams: [rival]);
    await tester.tap(find.text('Log Game'));
    await tester.pumpAndSettle();

    await selectDropdownItem(tester, 'Their team', 'Rival Grassy');
    TextField slot(int n) => tester.widget<TextField>(
      find.widgetWithText(TextField, 'Opp. Pokémon $n'),
    );
    expect(slot(1).controller?.text, 'Rillaboom');
    expect(slot(6).controller?.text, 'Grimmsnarl');

    await tester.tap(find.text('Win'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Save game'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Progress'));
    await tester.pumpAndSettle();
    final opponents = find.textContaining('Opp: Rillaboom, Sneasler');
    await scrollTo(tester, opponents);
    expect(opponents, findsOneWidget);
  });
}
