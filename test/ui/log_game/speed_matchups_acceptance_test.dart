import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/domain/models/pokemon_set.dart';
import 'package:vgc_daily_tracker/domain/models/team.dart';
import 'package:vgc_daily_tracker/domain/showdown/showdown_format.dart';
import 'package:vgc_daily_tracker/utils/result.dart';

import '../../../testing/app.dart';
import '../../../testing/fakes/fake_pokemon_repository.dart';
import '../../../testing/log_game_actions.dart';
import '../../../testing/showdown_pastes.dart';

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
  // An opponent seen at Team Preview: species only, no spreads.
  final rival = Team(
    id: 'o1',
    name: 'Rival Grassy',
    side: TeamSide.opponent,
    pokemon: [ref('sneasler'), ref('rillaboom')],
  );

  /// The Speed list, top to bottom, as read on screen.
  List<String> speedRows(WidgetTester tester) => [
    for (final e
        in find
            .descendant(
              of: find.byKey(const ValueKey('speed-order')),
              matching: find.byKey(const ValueKey('speed-row')),
            )
            .evaluate())
      (e.widget as Text).data!,
  ];

  testWidgets('both teams in Speed order: Megas, ranges for unknown spreads, '
      'and Trick Room', (tester) async {
    tester.view.physicalSize = const Size(1200, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await pumpApp(tester, teams: [team1, rival]);
    await tester.tap(find.text('Log Game'));
    await tester.pumpAndSettle();

    await selectDropdownItem(tester, 'Your team used', 'Worlds Metagross');
    await selectDropdownItem(tester, 'Their team', 'Rival Grassy');

    expect(find.text('Speed'), findsOneWidget);
    expect(speedRows(tester), [
      'Raichu-Mega-Y · yours · 200',
      'Sneasler · theirs · 140–189',
      'Whimsicott · yours · 184',
      'Metagross-Mega · yours · 178',
      'Rillaboom · theirs · 105–150',
      'Kleavor · yours · 137',
      'Basculegion-Male · yours · 130',
      'Kingambit · yours · 70',
    ]);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Trick Room'));
    await tester.pumpAndSettle();
    expect(speedRows(tester).take(3), [
      'Kingambit · yours · 70',
      'Rillaboom · theirs · 105–150',
      'Basculegion-Male · yours · 130',
    ]);
  });
}
