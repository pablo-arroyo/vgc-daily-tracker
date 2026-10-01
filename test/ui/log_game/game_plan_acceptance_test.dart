import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/domain/models/matchup_note.dart';
import 'package:vgc_daily_tracker/domain/models/team.dart';

import '../../../testing/app.dart';
import '../../../testing/fakes/fake_matchup_repository.dart';
import '../../../testing/fakes/fake_pokemon_repository.dart';
import '../../../testing/log_game_actions.dart';

void main() {
  final mine = Team(
    id: 't1',
    name: 'Big Six',
    pokemon: [
      for (final slug in [
        'kingambit',
        'whimsicott',
        'garchomp',
        'incineroar',
        'rillaboom',
        'charizard',
      ])
        FakePokemonRepository.sampleRef(slug),
    ],
  );
  final rival = Team(
    id: 'o1',
    name: 'Rival Grassy',
    side: TeamSide.opponent,
    notes: 'Sneasler runs Unburden: Fake Out it turn 1.',
    pokemon: [FakePokemonRepository.sampleRef('rillaboom')],
  );

  testWidgets('picking both teams shows the game plan before the battle, '
      'and the matchup plan can be updated right there', (tester) async {
    tester.view.physicalSize = const Size(1200, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final matchups = FakeMatchupRepository(
      notes: [
        MatchupNote(
          myTeamId: 't1',
          opponentTeamId: 'o1',
          notes: 'Lead Whimsicott + Kingambit.',
          updatedAt: DateTime.utc(2026, 9, 30),
        ),
      ],
    );
    await pumpApp(tester, teams: [mine, rival], matchups: matchups);
    await tester.tap(find.text('Log Game'));
    await tester.pumpAndSettle();

    await selectDropdownItem(tester, 'Their team', 'Rival Grassy');
    expect(find.text('Game plan'), findsOneWidget);
    expect(
      find.text('Sneasler runs Unburden: Fake Out it turn 1.'),
      findsOneWidget,
    );
    expect(
      find.text('Pick your team to see your plan for this matchup.'),
      findsOneWidget,
    );

    await selectDropdownItem(tester, 'Your team used', 'Big Six');
    expect(find.text('Big Six vs Rival Grassy'), findsOneWidget);
    expect(find.text('Lead Whimsicott + Kingambit.'), findsOneWidget);

    await tester.tap(find.byTooltip('Edit the matchup plan'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'Game plan'),
      'Lead Whimsicott + Kingambit. Tailwind turn 1.',
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pumpAndSettle();

    expect(
      find.text('Lead Whimsicott + Kingambit. Tailwind turn 1.'),
      findsOneWidget,
    );
    expect(
      (await matchups.watchAll().first).single.notes,
      'Lead Whimsicott + Kingambit. Tailwind turn 1.',
    );
  });
}
