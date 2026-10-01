import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/domain/models/team.dart';

import '../../../testing/app.dart';
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
    pokemon: [FakePokemonRepository.sampleRef('rillaboom')],
  );

  /// Result, your 4 brought and 2 leads, then Save game. Both teams must
  /// already be picked.
  Future<void> playAndSave(WidgetTester tester, String result) async {
    await tester.tap(find.text(result));
    await tester.pumpAndSettle();
    for (final name in ['Kingambit', 'Whimsicott', 'Garchomp', 'Incineroar']) {
      await tapChip(tester, section: 'your-brought', name: name);
    }
    for (final name in ['Kingambit', 'Whimsicott']) {
      await tapChip(tester, section: 'your-leads', name: name);
    }
    await tester.tap(find.widgetWithText(FilledButton, 'Save game'));
    await tester.pumpAndSettle();
  }

  testWidgets('log a best-of-3 game by game, won 2–1', (tester) async {
    tester.view.physicalSize = const Size(1200, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await pumpApp(tester, teams: [mine, rival]);
    await tester.tap(find.text('Log Game'));
    await tester.pumpAndSettle();

    // Game 1.
    await tester.tap(find.text('Part of a best-of-3'));
    await selectDropdownItem(tester, 'Your team used', 'Big Six');
    await selectDropdownItem(tester, 'Their team', 'Rival Grassy');
    await playAndSave(tester, 'Win');
    expect(find.text('Best-of-3 vs Rival Grassy · 1–0'), findsOneWidget);

    // Game 2: both teams carried over.
    await tester.tap(find.widgetWithText(FilledButton, 'Log game 2'));
    await tester.pumpAndSettle();
    expect(find.text('Game 2 of a best-of-3'), findsOneWidget);
    expect(find.text('Big Six'), findsWidgets);
    expect(find.text('Rival Grassy'), findsWidgets);
    await playAndSave(tester, 'Loss');
    expect(find.text('Best-of-3 vs Rival Grassy · 1–1'), findsOneWidget);

    // Game 3 decides it.
    await tester.tap(find.widgetWithText(FilledButton, 'Log game 3'));
    await tester.pumpAndSettle();
    await playAndSave(tester, 'Win');
    expect(find.text('Game logged ✓ · Set won 2–1'), findsOneWidget);
    expect(find.textContaining('Best-of-3 vs'), findsNothing);
  });
}
