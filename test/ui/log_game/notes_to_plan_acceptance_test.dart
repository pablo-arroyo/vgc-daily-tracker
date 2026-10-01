import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/domain/models/matchup_note.dart';
import 'package:vgc_daily_tracker/domain/models/team.dart';

import '../../../testing/app.dart';
import '../../../testing/fakes/fake_matchup_repository.dart';
import '../../../testing/fakes/fake_pokemon_repository.dart';
import '../../../testing/log_game_actions.dart';

/// Midday UTC: the same calendar day in any timezone the tests run in.
final now = DateTime.utc(2026, 9, 30, 12);

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
    pokemon: [FakePokemonRepository.sampleRef('rillaboom')],
  );

  testWidgets('after logging a game, its notes can be added to the '
      'matchup plan for next time', (tester) async {
    tester.view.physicalSize = const Size(1200, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final matchups = FakeMatchupRepository(
      notes: [
        MatchupNote(
          myTeamId: 't1',
          opponentTeamId: 'o1',
          notes: 'Lead Whimsicott + Kingambit.',
          updatedAt: DateTime.utc(2026, 9, 29),
        ),
      ],
    );
    await withClock(Clock.fixed(now), () async {
      await pumpApp(tester, teams: [mine, rival], matchups: matchups);
      await tester.tap(find.text('Log Game'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Loss'));
      await tester.pumpAndSettle();
      await selectDropdownItem(tester, 'Your team used', 'Big Six');
      for (final name in [
        'Kingambit',
        'Whimsicott',
        'Garchomp',
        'Incineroar',
      ]) {
        await tapChip(tester, section: 'your-brought', name: name);
      }
      for (final name in ['Kingambit', 'Whimsicott']) {
        await tapChip(tester, section: 'your-leads', name: name);
      }
      await selectDropdownItem(tester, 'Their team', 'Rival Grassy');
      await tester.enterText(
        find.widgetWithText(TextField, 'Notes'),
        'Lost the speed tie on turn 2: Tailwind first.',
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Save game'));
      await tester.pumpAndSettle();

      expect(find.text('Game logged ✓'), findsOneWidget);
      await tester.tap(
        find.widgetWithText(SnackBarAction, 'Add to matchup notes'),
      );
      await tester.pumpAndSettle();

      expect(find.text('Added to Big Six vs Rival Grassy'), findsOneWidget);
      expect(
        (await matchups.watchAll().first).single.notes,
        'Lead Whimsicott + Kingambit.\n'
        '2026-09-30: Lost the speed tie on turn 2: Tailwind first.',
      );
    });
  });
}
