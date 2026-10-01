import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/domain/models/game_log.dart';
import 'package:vgc_daily_tracker/domain/models/team.dart';

import '../../../testing/app.dart';
import '../../../testing/clipboard.dart';
import '../../../testing/fakes/fake_pokemon_repository.dart';
import '../../../testing/fakes/fake_routine_repository.dart';
import '../../../testing/progress_actions.dart';

final now = DateTime.utc(2026, 9, 30, 12);

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
  final game = GameLog(
    id: 'g1',
    playedAt: now,
    result: GameResult.win,
    teamId: 't1',
    teamName: 'Big Six',
    opponentTeamId: 'o1',
    opponentTeamName: 'Rival Grassy',
  );

  Future<void> openBackup(WidgetTester tester) async {
    await tester.tap(find.byTooltip('Backup & restore'));
    await tester.pumpAndSettle();
  }

  testWidgets('copy a backup, restore it into an empty app: teams, games '
      'and routine ticks are all back', (tester) async {
    final clipboard = FakeClipboard(tester);
    await withClock(Clock.fixed(now), () async {
      final routine = FakeRoutineRepository();
      await routine.save('2026-09-30', {'speed-order'});
      await pumpApp(
        tester,
        teams: [mine, rival],
        games: [game],
        routine: routine,
      );
      await openBackup(tester);
      await tester.tap(find.widgetWithText(FilledButton, 'Copy backup'));
      await tester.pumpAndSettle();
      expect(
        find.text('Backup copied: 2 teams, 1 game, 1 routine day'),
        findsOneWidget,
      );

      // A fresh, empty app (another device, or after reinstalling).
      await pumpApp(tester);
      await openBackup(tester);
      await tester.enterText(
        find.widgetWithText(TextField, 'Paste a backup here'),
        clipboard.text!,
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Restore'));
      await tester.pumpAndSettle();
      expect(
        find.text('Restored 2 teams, 1 game, 1 routine day'),
        findsOneWidget,
      );

      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.byType(Checkbox).evaluate().length, greaterThan(0));
      final ticked = tester.widgetList<CheckboxListTile>(
        find.byType(CheckboxListTile),
      );
      expect(ticked.where((t) => t.value ?? false), hasLength(1));
      await tester.tap(find.text('Teams'));
      await tester.pumpAndSettle();
      expect(find.text('Big Six'), findsOneWidget);
      await tester.tap(find.text('Progress'));
      await tester.pumpAndSettle();
      await scrollTo(tester, find.text('Rival Grassy (1-0)'));
      expect(find.text('Rival Grassy (1-0)'), findsOneWidget);
    });
  });
}
