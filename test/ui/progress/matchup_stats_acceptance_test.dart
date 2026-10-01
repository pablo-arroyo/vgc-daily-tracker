import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/domain/models/game_log.dart';

import '../../../testing/app.dart';
import '../../../testing/progress_actions.dart';

final now = DateTime.utc(2026, 9, 30, 12);

GameLog vs(String id, String? teamId, String? name, GameResult result) =>
    GameLog(
      id: id,
      playedAt: now,
      result: result,
      opponentTeamId: teamId,
      opponentTeamName: name,
    );

void main() {
  testWidgets('Progress shows your record against each saved opponent team', (
    tester,
  ) async {
    await withClock(Clock.fixed(now), () async {
      await pumpApp(
        tester,
        games: [
          vs('a', 'o1', 'Rival Grassy', GameResult.win),
          vs('b', 'o1', 'Rival Grassy', GameResult.loss),
          vs('c', 'o1', 'Rival Grassy', GameResult.loss),
          vs('d', 'o2', 'Ladder Rain', GameResult.win),
          vs('e', null, null, GameResult.win), // not against a saved team
        ],
      );
      await tester.tap(find.text('Progress'));
      await tester.pumpAndSettle();

      await scrollTo(tester, find.text('Vs opponent teams'));
      final card = find.ancestor(
        of: find.text('Vs opponent teams'),
        matching: find.byType(Card),
      );
      Finder inCard(String text) =>
          find.descendant(of: card, matching: find.text(text));
      expect(inCard('Rival Grassy (1-2)'), findsOneWidget);
      expect(inCard('33%'), findsOneWidget);
      expect(inCard('Ladder Rain (1-0)'), findsOneWidget);
      expect(inCard('100%'), findsOneWidget);
    });
  });
}
