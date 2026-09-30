import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:vgc_daily_tracker/domain/models/game_log.dart';
import 'package:vgc_daily_tracker/domain/models/mistake_category.dart';
import 'package:vgc_daily_tracker/ui/core/theme/app_theme.dart';
import 'package:vgc_daily_tracker/ui/progress/view_models/progress_view_model.dart';
import 'package:vgc_daily_tracker/ui/progress/widgets/progress_screen.dart';

import '../../../../testing/fakes/fake_game_log_repository.dart';

/// "Now": 2026-09-30 10:00 in UTC-6.
final now = DateTime.utc(2026, 9, 30, 16);
DateTime costaRica(DateTime utc) => utc.subtract(const Duration(hours: 6));

GameLog game(
  String id, {
  required int day,
  GameResult result = GameResult.win,
  MistakeCategory? mistake,
  String? teamId,
  String? teamName,
  List<String> brought = const [],
  List<String> leads = const [],
  List<String> opponentTeam = const [],
  List<String> opponentLeads = const [],
  String notes = '',
}) => GameLog(
  id: id,
  playedAt: DateTime.utc(2026, 9, day, 18), // 12:00 local
  result: result,
  mistake: mistake,
  teamId: teamId,
  teamName: teamName,
  brought: brought,
  leads: leads,
  opponentTeam: opponentTeam,
  opponentLeads: opponentLeads,
  notes: notes,
);

/// Pumps the Progress screen over [games] at [now] (run inside withClock).
Future<FakeGameLogRepository> pumpProgress(
  WidgetTester tester,
  List<GameLog> games,
) async {
  // Tall enough that every card is built (the list builds lazily).
  tester.view.physicalSize = const Size(800, 3000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final repository = FakeGameLogRepository(games: games);
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: ChangeNotifierProvider(
        create: (_) => ProgressViewModel(
          gameLogRepository: repository,
          toLocal: costaRica,
        ),
        child: const ProgressScreen(),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return repository;
}

/// The value shown in the stat box labelled [label].
String statValue(WidgetTester tester, String label) {
  final box = find.ancestor(
    of: find.text(label),
    matching: find.byKey(const ValueKey('stat-box')),
  );
  return tester
      .widgetList<Text>(find.descendant(of: box, matching: find.byType(Text)))
      .first
      .data!;
}

void main() {
  group('overview and focus', () {
    testWidgets('empty: zeros, dashes and the "log a few games" prompt', (
      tester,
    ) async {
      await withClock(Clock.fixed(now), () async {
        await pumpProgress(tester, []);

        expect(statValue(tester, 'games logged'), '0');
        expect(statValue(tester, 'overall win rate'), '–');
        expect(statValue(tester, 'last 7 days'), '–');
        expect(statValue(tester, 'day streak'), '0');
        expect(
          find.text('Log a few games to see your most common mistake here.'),
          findsOneWidget,
        );
      });
    });

    testWidgets('with games: numbers and the accurate focus text', (
      tester,
    ) async {
      await withClock(Clock.fixed(now), () async {
        await pumpProgress(tester, [
          game('a', day: 30, mistake: MistakeCategory.speedCalc),
          game(
            'b',
            day: 29,
            result: GameResult.loss,
            mistake: MistakeCategory.speedCalc,
          ),
        ]);

        expect(statValue(tester, 'games logged'), '2');
        expect(statValue(tester, 'overall win rate'), '50%');
        expect(statValue(tester, 'last 7 days'), '50%');
        expect(statValue(tester, 'day streak'), '2');
        expect(find.text(MistakeCategory.speedCalc.label), findsWidgets);
        expect(
          find.text(
            'Showed up in 2 of the 2 games with a mistake noted in the last '
            '14 days. Make it the one thing you watch for this week.',
          ),
          findsOneWidget,
        );
      });
    });

    testWidgets('games but no repeated mistake: says to keep logging', (
      tester,
    ) async {
      await withClock(Clock.fixed(now), () async {
        await pumpProgress(tester, [game('a', day: 30)]);

        expect(
          find.text(
            'No repeated mistake pattern yet in the last two weeks — keep '
            'logging.',
          ),
          findsOneWidget,
        );
      });
    });
  });

  group('team, lead and mistake cards', () {
    testWidgets('empty states', (tester) async {
      await withClock(Clock.fixed(now), () async {
        await pumpProgress(tester, []);

        expect(
          find.text('No games logged with a saved team yet.'),
          findsOneWidget,
        );
        expect(find.text('No opponent lead data logged yet.'), findsOneWidget);
        expect(find.text('No games logged yet.'), findsWidgets);
      });
    });

    testWidgets('rows with records, win % and proportional bars', (
      tester,
    ) async {
      await withClock(Clock.fixed(now), () async {
        await pumpProgress(tester, [
          game(
            'a',
            day: 28,
            teamId: 't1',
            teamName: 'Big Six',
            opponentLeads: ['rillaboom'],
            mistake: MistakeCategory.protectCall,
          ),
          game(
            'b',
            day: 29,
            teamId: 't1',
            teamName: 'Big Six',
            result: GameResult.loss,
            opponentLeads: ['rillaboom'],
            mistake: MistakeCategory.protectCall,
          ),
          game(
            'c',
            day: 30,
            teamId: 't1',
            teamName: 'Big Six',
            mistake: MistakeCategory.speedCalc,
          ),
        ]);

        // 67% also appears as the overall and last-7-days rates.
        final teamRow = find.ancestor(
          of: find.text('Big Six (2-1)'),
          matching: find.byType(Row),
        );
        expect(
          find.descendant(of: teamRow, matching: find.text('67%')),
          findsOneWidget,
        );
        expect(find.text('Rillaboom (seen 2×)'), findsOneWidget);
        expect(find.text('50% win'), findsOneWidget);

        // The label also shows in a recent game's summary, so look for it
        // inside the bars only.
        double barOf(String label) {
          const bars = ValueKey('mistake-bar');
          final bar = find.ancestor(
            of: find.descendant(
              of: find.byKey(bars),
              matching: find.text(label),
            ),
            matching: find.byKey(bars),
          );
          return tester
              .widget<FractionallySizedBox>(
                find.descendant(
                  of: bar,
                  matching: find.byType(FractionallySizedBox),
                ),
              )
              .widthFactor!;
        }

        expect(barOf(MistakeCategory.protectCall.label), 1.0);
        expect(barOf(MistakeCategory.speedCalc.label), 0.5);
      });
    });
  });

  group('recent games', () {
    testWidgets('each game: badge, local date and team, picks, mistake or '
        'notes', (tester) async {
      await withClock(Clock.fixed(now), () async {
        await pumpProgress(tester, [
          game(
            'full',
            day: 30,
            teamId: 't1',
            teamName: 'Big Six',
            brought: ['kingambit', 'whimsicott'],
            leads: ['kingambit'],
            opponentTeam: ['rillaboom', 'raichu-mega-y'],
            opponentLeads: ['rillaboom'],
            mistake: MistakeCategory.speedCalc,
          ),
          game(
            'notes-only',
            day: 29,
            result: GameResult.loss,
            notes: 'Tailwind turns!',
          ),
        ]);

        expect(find.text('W'), findsOneWidget);
        expect(find.text('L'), findsOneWidget);
        expect(find.text('2026-09-30 · Big Six'), findsOneWidget);
        expect(
          find.text('Brought: Kingambit, Whimsicott · Leads: Kingambit'),
          findsOneWidget,
        );
        expect(
          find.text('Opp: Rillaboom, Raichu-Mega-Y · Opp leads: Rillaboom'),
          findsOneWidget,
        );
        expect(find.text('2026-09-29'), findsOneWidget);
        expect(find.text('Tailwind turns!'), findsOneWidget);
      });
    });

    testWidgets('shows 15, then "Show all"', (tester) async {
      await withClock(Clock.fixed(now), () async {
        await pumpProgress(tester, [
          for (var i = 1; i <= 20; i++) game('g$i', day: i),
        ]);
        final items = find.byTooltip('Delete game');
        expect(items, findsNWidgets(15));

        await tester.tap(find.text('Show all (20)'));
        await tester.pumpAndSettle();

        expect(items, findsNWidgets(20));
      });
    });

    testWidgets('delete a game, then undo', (tester) async {
      await withClock(Clock.fixed(now), () async {
        await pumpProgress(tester, [game('a', day: 30), game('b', day: 29)]);

        await tester.tap(find.byTooltip('Delete game').first);
        await tester.pumpAndSettle();
        expect(find.byTooltip('Delete game'), findsOneWidget);
        expect(find.text('Game deleted'), findsOneWidget);

        await tester.tap(find.widgetWithText(SnackBarAction, 'Undo'));
        await tester.pumpAndSettle();
        expect(find.byTooltip('Delete game'), findsNWidgets(2));
      });
    });

    testWidgets('a failed delete says so', (tester) async {
      await withClock(Clock.fixed(now), () async {
        final games = await pumpProgress(tester, [game('a', day: 30)]);
        games.failWith = Exception('disk full');

        await tester.tap(find.byTooltip('Delete game'));
        await tester.pumpAndSettle();

        expect(
          find.text("Couldn't delete the game. Try again."),
          findsOneWidget,
        );
        expect(find.byTooltip('Delete game'), findsOneWidget);
      });
    });
  });
}
