import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/domain/models/game_log.dart';

import '../../../testing/app.dart';
import '../../../testing/progress_actions.dart';

final now = DateTime.utc(2026, 9, 30, 12);

void main() {
  final game = GameLog(
    id: 'g1',
    playedAt: now,
    result: GameResult.loss,
    opponentTeam: const [
      'rillaboom',
      'sneasler',
      'incineroar',
      'kingambit',
      'salamence',
      'grimmsnarl',
    ],
  );

  testWidgets("save a game's opponent as a team: it appears under "
      'Opponents, and the game no longer offers it', (tester) async {
    tester.view.physicalSize = const Size(1200, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await withClock(Clock.fixed(now), () async {
      await pumpApp(tester, games: [game]);
      await tester.tap(find.text('Progress'));
      await tester.pumpAndSettle();

      final save = find.byTooltip('Save their team');
      await scrollTo(tester, save);
      await tester.tap(save);
      await tester.pumpAndSettle();
      await tester.enterText(
        find.widgetWithText(TextField, 'Team name'),
        'Ladder Grassy',
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Save'));
      await tester.pumpAndSettle();

      expect(find.text('Saved Ladder Grassy to Opponents'), findsOneWidget);
      expect(find.byTooltip('Save their team'), findsNothing);

      await tester.tap(find.text('Teams'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Opponents'));
      await tester.pumpAndSettle();
      expect(find.text('Ladder Grassy'), findsOneWidget);
      expect(find.text('Grimmsnarl'), findsOneWidget);
    });
  });
}
