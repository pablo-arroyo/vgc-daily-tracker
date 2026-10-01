import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/domain/models/team.dart';

import '../../testing/app.dart';
import '../../testing/fakes/fake_pokemon_repository.dart';
import '../../testing/log_game_actions.dart';
import '../../testing/progress_actions.dart';

/// A best-of-3 on the real app: two wins close the set, and Progress
/// records it.
void bestOfThreeJourney() {
  testWidgets('log a set won 2–0', (tester) async {
    final rival = Team(
      id: 'o1',
      name: 'Rival Grassy',
      side: TeamSide.opponent,
      pokemon: [FakePokemonRepository.sampleRef('rillaboom')],
    );
    await pumpApp(tester, teams: [rival]);
    await tester.tap(find.text('Log Game'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Part of a best-of-3'));
    await tester.tap(find.text('Win'));
    await tester.pumpAndSettle();
    await selectDropdownItem(tester, 'Their team', 'Rival Grassy');
    await tester.tap(find.widgetWithText(FilledButton, 'Save game'));
    await tester.pumpAndSettle();
    expect(find.text('Best-of-3 vs Rival Grassy · 1–0'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Log game 2'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Win'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Save game'));
    await tester.pumpAndSettle();

    expect(find.text('Game logged ✓ · Set won 2–0'), findsOneWidget);

    await tester.tap(find.text('Progress'));
    await tester.pumpAndSettle();
    await scrollTo(tester, find.text('Set record (1-0)'));
    expect(find.text('Rival Grassy · Won 2–0 · W W'), findsOneWidget);
  });
}
