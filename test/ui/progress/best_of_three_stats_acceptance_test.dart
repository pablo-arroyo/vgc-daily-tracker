import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/domain/models/game_log.dart';

import '../../../testing/app.dart';
import '../../../testing/progress_actions.dart';

final now = DateTime.utc(2026, 9, 30, 12);

/// Game [game] of set [setId], played [minutesAgo] before [now].
GameLog setGame(
  String setId,
  int game,
  GameResult result, {
  required int minutesAgo,
  String? against,
  bool endsSet = false,
}) => GameLog(
  id: '$setId-$game',
  playedAt: now.subtract(Duration(minutes: minutesAgo)),
  result: result,
  setId: setId,
  setGame: game,
  opponentTeamId: against == null ? null : 'opp-$against',
  opponentTeamName: against,
  endsSet: endsSet,
);

void main() {
  testWidgets('Progress shows best-of-3 records: sets, game 1 against '
      'games 2–3, unfinished sets and recent sets', (tester) async {
    tester.view.physicalSize = const Size(1200, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await withClock(Clock.fixed(now), () async {
      await pumpApp(
        tester,
        games: [
          // Won 2–1 against Rival Grassy (oldest).
          setGame(
            'a',
            1,
            GameResult.win,
            minutesAgo: 90,
            against: 'Rival Grassy',
          ),
          setGame(
            'a',
            2,
            GameResult.loss,
            minutesAgo: 80,
            against: 'Rival Grassy',
          ),
          setGame(
            'a',
            3,
            GameResult.win,
            minutesAgo: 70,
            against: 'Rival Grassy',
          ),
          // Lost 0–2 against Ladder Rain.
          setGame(
            'b',
            1,
            GameResult.loss,
            minutesAgo: 60,
            against: 'Ladder Rain',
          ),
          setGame(
            'b',
            2,
            GameResult.loss,
            minutesAgo: 50,
            against: 'Ladder Rain',
          ),
          // Ended early after a win (newest set).
          setGame('c', 1, GameResult.win, minutesAgo: 40, endsSet: true),
          // A single game: not part of any set.
          GameLog(
            id: 'single',
            playedAt: now.subtract(const Duration(minutes: 30)),
            result: GameResult.win,
          ),
        ],
      );
      await tester.tap(find.text('Progress'));
      await tester.pumpAndSettle();

      await scrollTo(tester, find.text('Best-of-3 sets'));
      final card = find.ancestor(
        of: find.text('Best-of-3 sets'),
        matching: find.byType(Card),
      );
      Finder inCard(String text) =>
          find.descendant(of: card, matching: find.text(text));
      expect(inCard('Set record (1-1)'), findsOneWidget);
      expect(inCard('50%'), findsOneWidget);
      expect(inCard('Game 1 win rate'), findsOneWidget);
      expect(inCard('67%'), findsOneWidget);
      expect(inCard('Games 2–3 win rate'), findsOneWidget);
      expect(inCard('33%'), findsOneWidget);
      expect(inCard('Unfinished sets'), findsOneWidget);
      expect(inCard('Unfinished 1–0 · W'), findsOneWidget);
      expect(inCard('Ladder Rain · Lost 0–2 · L L'), findsOneWidget);
      expect(inCard('Rival Grassy · Won 2–1 · W L W'), findsOneWidget);
    });
  });
}
