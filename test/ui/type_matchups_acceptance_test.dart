import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/domain/models/pokemon_set.dart';
import 'package:vgc_daily_tracker/domain/models/team.dart';
import 'package:vgc_daily_tracker/domain/showdown/showdown_format.dart';
import 'package:vgc_daily_tracker/utils/result.dart';

import '../../testing/app.dart';
import '../../testing/fakes/fake_pokemon_repository.dart';
import '../../testing/log_game_actions.dart';
import '../../testing/progress_actions.dart';
import '../../testing/showdown_pastes.dart';

void main() {
  const ref = FakePokemonRepository.sampleRef;
  final team1 = Team(
    id: 't1',
    name: 'Worlds Metagross',
    pokemon: [
      for (final slug in [
        'kingambit',
        'kleavor',
        'metagross',
        'whimsicott',
        'raichu',
        'basculegion-male',
      ])
        ref(slug),
    ],
    sets: (ShowdownFormat.parse(team1Paste) as Ok<List<PokemonSet>>).value,
  );
  final rival = Team(
    id: 'o1',
    name: 'Rival Grassy',
    side: TeamSide.opponent,
    pokemon: [ref('sneasler'), ref('rillaboom')],
  );

  testWidgets("a team's weaknesses on its detail screen", (tester) async {
    tester.view.physicalSize = const Size(1200, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await pumpApp(tester, teams: [team1, rival]);
    await tester.tap(find.text('Teams'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Worlds Metagross'));
    await tester.pumpAndSettle();

    await scrollTo(tester, find.text('Weaknesses'));
    expect(find.text('Ground · 3 weak · 1 resists'), findsOneWidget);
    expect(find.text('Fire · 3 weak · 1 resists'), findsOneWidget);
    expect(
      find.text("Types only: abilities like Levitate aren't counted."),
      findsOneWidget,
    );
  });

  testWidgets('their likely attacks against your team in Log Game', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await pumpApp(tester, teams: [team1, rival]);
    await tester.tap(find.text('Log Game'));
    await tester.pumpAndSettle();

    await selectDropdownItem(tester, 'Your team used', 'Worlds Metagross');
    await selectDropdownItem(tester, 'Their team', 'Rival Grassy');

    expect(find.text('Their likely attacks'), findsOneWidget);
    expect(find.text('Fighting → Kingambit ×4'), findsOneWidget);
    expect(find.text('Poison → Whimsicott ×4'), findsOneWidget);
    expect(find.text('Grass → Basculegion-Male ×2'), findsOneWidget);
  });
}
