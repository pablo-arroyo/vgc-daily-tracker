import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/domain/models/game_log.dart';
import 'package:vgc_daily_tracker/domain/models/mistake_category.dart';

import '../../../testing/app.dart';
import '../../../testing/progress_actions.dart';

/// Midday UTC: "today" and "yesterday" are the same calendar days in any
/// timezone the test machine uses.
final now = DateTime.utc(2026, 9, 30, 12);

GameLog game(
  String id, {
  required int daysAgo,
  GameResult result = GameResult.win,
  MistakeCategory? mistake,
}) => GameLog(
  id: id,
  playedAt: now.subtract(Duration(days: daysAgo)),
  result: result,
  teamId: 't1',
  teamName: 'Big Six',
  mistake: mistake,
);

void main() {
  testWidgets('Progress: totals, streak, focus and team record; delete a '
      'game and undo', (tester) async {
    await withClock(Clock.fixed(now), () async {
      await pumpApp(
        tester,
        games: [
          game('today', daysAgo: 0, mistake: MistakeCategory.speedCalc),
          game(
            'yesterday',
            daysAgo: 1,
            result: GameResult.loss,
            mistake: MistakeCategory.speedCalc,
          ),
        ],
      );
      await tester.tap(find.text('Progress'));
      await tester.pumpAndSettle();

      expect(find.text('games logged'), findsOneWidget);
      expect(find.text('2'), findsWidgets); // games logged and day streak
      expect(find.text('50%'), findsWidgets);
      expect(find.text(MistakeCategory.speedCalc.label), findsWidgets);
      // Lower cards are built as you scroll, like for a real user.
      await scrollTo(tester, find.text('Big Six (1-1)'));
      expect(find.text('Big Six (1-1)'), findsOneWidget);

      // Scroll to the (unique) header; `.first` of an empty finder throws.
      await scrollTo(tester, find.text('Recent games'));
      await tester.tap(find.byTooltip('Delete game').first);
      await tester.pumpAndSettle();
      // The newest game (today's win) was deleted; yesterday's loss remains.
      await scrollTo(tester, find.text('Big Six (0-1)'));
      expect(find.text('Big Six (0-1)'), findsOneWidget);
      expect(find.text('Game deleted'), findsOneWidget);

      await tester.tap(find.widgetWithText(SnackBarAction, 'Undo'));
      await tester.pumpAndSettle();
      await scrollTo(tester, find.text('Big Six (1-1)'));
      expect(find.text('Big Six (1-1)'), findsOneWidget);
    });
  });
}
