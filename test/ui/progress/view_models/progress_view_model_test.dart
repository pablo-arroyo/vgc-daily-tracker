import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/domain/models/game_log.dart';
import 'package:vgc_daily_tracker/domain/models/mistake_category.dart';
import 'package:vgc_daily_tracker/domain/models/team.dart';
import 'package:vgc_daily_tracker/ui/progress/view_models/progress_stats.dart';
import 'package:vgc_daily_tracker/ui/progress/view_models/progress_view_model.dart';
import 'package:vgc_daily_tracker/utils/result.dart';

import '../../../../testing/fakes/fake_game_log_repository.dart';
import '../../../../testing/fakes/fake_id_generator.dart';
import '../../../../testing/fakes/fake_pokemon_repository.dart';
import '../../../../testing/fakes/fake_team_repository.dart';

/// Tests run in a fixed timezone, UTC-6 (Costa Rica), so "local day" is
/// deterministic on any machine.
DateTime costaRica(DateTime utc) => utc.subtract(const Duration(hours: 6));

/// "Now": 2026-09-30 10:00 local (16:00 UTC).
final now = DateTime.utc(2026, 9, 30, 16);

/// A game played at local [day] of September 2026, [hour] local time.
GameLog game(
  String id, {
  required int day,
  int hour = 12,
  GameResult result = GameResult.win,
  MistakeCategory? mistake,
  String? teamId,
  String? teamName,
  List<String> opponentLeads = const [],
}) => GameLog(
  id: id,
  // Local = UTC-6, so UTC = local + 6h.
  playedAt: DateTime.utc(2026, 9, day, hour + 6),
  result: result,
  mistake: mistake,
  teamId: teamId,
  teamName: teamName,
  opponentLeads: opponentLeads,
);

void main() {
  /// Builds the view model at [now] and lets it load [games].
  Future<ProgressViewModel> progressOf(List<GameLog> games) async {
    late ProgressViewModel viewModel;
    await withClock(Clock.fixed(now), () async {
      viewModel = ProgressViewModel(
        gameLogRepository: FakeGameLogRepository(games: games),
        teamRepository: FakeTeamRepository(),
        pokemonRepository: FakePokemonRepository(),
        idGenerator: SequentialIdGenerator(),
        toLocal: costaRica,
      );
      await pumpEventQueue();
    });
    addTearDown(viewModel.dispose);
    return viewModel;
  }

  test('an empty history: zeros, no rates, no focus, empty lists', () async {
    final viewModel = await progressOf([]);

    expect(viewModel.loaded, isTrue);
    final stats = viewModel.stats;
    expect(stats.totalGames, 0);
    expect(stats.winRatePercent, isNull);
    expect(stats.gamesLast7Days, 0);
    expect(stats.winRateLast7DaysPercent, isNull);
    expect(stats.dayStreak, 0);
    expect(stats.weeklyFocus, isNull);
    expect(stats.mistakeBreakdown, isEmpty);
    expect(stats.teamRecords, isEmpty);
    expect(stats.opponentLeads, isEmpty);
    expect(stats.recentGames, isEmpty);
  });

  test('totals and overall win %, rounded like the original', () async {
    final stats = (await progressOf([
      game('a', day: 1),
      game('b', day: 2),
      game('c', day: 3),
      game('d', day: 4, result: GameResult.loss),
    ])).stats;
    expect(stats.totalGames, 4);
    expect(stats.winRatePercent, 75);

    final twoOfThree = (await progressOf([
      game('a', day: 1),
      game('b', day: 2),
      game('c', day: 3, result: GameResult.loss),
    ])).stats;
    expect(twoOfThree.winRatePercent, 67);
  });

  test('last 7 days = today and the 6 local days before it', () async {
    final stats = (await progressOf([
      game('first-day-in', day: 24),
      game('today', day: 30, result: GameResult.loss),
      // 23:30 local on the 23rd is already the 24th in UTC: still excluded.
      game('late-night-before', day: 23, hour: 23),
    ])).stats;

    expect(stats.gamesLast7Days, 2);
    expect(stats.winRateLast7DaysPercent, 50);
  });

  group('day streak', () {
    Future<int> streakOf(List<int> days, {int lateNightDay = 0}) async =>
        (await progressOf([
          for (final day in days) game('d$day', day: day),
          if (lateNightDay > 0) game('late', day: lateNightDay, hour: 23),
        ])).stats.dayStreak;

    test('counts consecutive local days back from today', () async {
      expect(await streakOf([30, 29, 28, 26]), 3);
    });

    test('with nothing logged yet today, counts back from yesterday', () async {
      expect(await streakOf([29, 28]), 2);
    });

    test('is 0 when the last game was before yesterday', () async {
      expect(await streakOf([28, 27]), 0);
    });

    test('a 23:30 game counts for its local day, not the UTC one', () async {
      // Local 29th 23:30 is the 30th in UTC; with UTC days this would read as
      // "today, then a gap on the 29th" = 1.
      expect(await streakOf([28], lateNightDay: 29), 2);
    });
  });

  group('weekly focus', () {
    const speed = MistakeCategory.speedCalc;
    const protect = MistakeCategory.protectCall;

    test('is the most common real mistake in the last 14 local days', () async {
      final stats = (await progressOf([
        game('a', day: 30, mistake: protect),
        game('b', day: 25, mistake: speed),
        game('c', day: 17, mistake: speed), // first day of the window
        game('d', day: 16, mistake: protect), // outside it
        game('e', day: 29, mistake: MistakeCategory.playedWell),
        game('f', day: 28), // no mistake picked
      ])).stats;

      expect(
        stats.weeklyFocus,
        const WeeklyFocus(mistake: speed, count: 2, gamesWithMistakes: 3),
      );
    });

    test('a tie goes to the most recent mistake', () async {
      final stats = (await progressOf([
        game('old', day: 20, mistake: speed),
        game('new', day: 29, mistake: protect),
      ])).stats;

      expect(stats.weeklyFocus?.mistake, protect);
    });

    test('is absent when only "played well" was picked', () async {
      final stats = (await progressOf([
        game('a', day: 30, mistake: MistakeCategory.playedWell),
      ])).stats;

      expect(stats.weeklyFocus, isNull);
    });
  });

  test('mistake breakdown: every picked category, all time, most common '
      'first (ties in option order)', () async {
    final stats = (await progressOf([
      game('a', day: 1, mistake: MistakeCategory.protectCall),
      game('b', day: 2, mistake: MistakeCategory.playedWell),
      game('c', day: 3, mistake: MistakeCategory.protectCall),
      game('d', day: 4, mistake: MistakeCategory.speedCalc),
      game('e', day: 5), // nothing picked: not counted
    ])).stats;

    expect(stats.mistakeBreakdown, const [
      MistakeCount(mistake: MistakeCategory.protectCall, count: 2),
      MistakeCount(mistake: MistakeCategory.playedWell, count: 1),
      MistakeCount(mistake: MistakeCategory.speedCalc, count: 1),
    ]);
  });

  test('win rate by team: grouped by id (renames stay one row), deleted '
      'teams kept, most games first', () async {
    final stats = (await progressOf([
      game('a', day: 1, teamId: 't1', teamName: 'Big Six'),
      game('b', day: 2, teamId: 't1', teamName: 'Big Six'),
      game(
        'c',
        day: 3,
        teamId: 't1',
        teamName: 'Big Six v2', // renamed since
        result: GameResult.loss,
      ),
      game('d', day: 4, teamId: 't2', teamName: 'Rilla Offense'),
      game(
        'e',
        day: 5,
        teamId: 't9',
        teamName: 'Old team', // since deleted
        result: GameResult.loss,
      ),
      game('f', day: 6), // no team
    ])).stats;

    expect(stats.teamRecords, const [
      TeamRecord(
        teamId: 't1',
        teamName: 'Big Six v2',
        wins: 2,
        losses: 1,
        winRatePercent: 67,
      ),
      TeamRecord(
        teamId: 't9',
        teamName: 'Old team',
        wins: 0,
        losses: 1,
        winRatePercent: 0,
      ),
      TeamRecord(
        teamId: 't2',
        teamName: 'Rilla Offense',
        wins: 1,
        losses: 0,
        winRatePercent: 100,
      ),
    ]);
  });

  test('opponent leads: the 8 most seen (ties: most recently seen first), '
      'with your win % against each', () async {
    final stats = (await progressOf([
      game('a', day: 1, opponentLeads: ['rillaboom', 'incineroar']),
      game(
        'b',
        day: 2,
        opponentLeads: ['rillaboom', 'sneasler'],
        result: GameResult.loss,
      ),
      game('c', day: 3, opponentLeads: ['rillaboom']),
      game('d', day: 3, opponentLeads: ['sneasler'], result: GameResult.loss),
      // Eight one-off leads, more recent than Incineroar's single sighting.
      for (var i = 0; i < 8; i++)
        game('x$i', day: 4, opponentLeads: ['mon-$i']),
    ])).stats;

    expect(stats.opponentLeads, hasLength(8));
    expect(stats.opponentLeads.take(2), const [
      LeadRecord(slug: 'rillaboom', timesSeen: 3, winRatePercent: 67),
      LeadRecord(slug: 'sneasler', timesSeen: 2, winRatePercent: 0),
    ]);
    expect(
      stats.opponentLeads.map((l) => l.slug),
      isNot(contains('incineroar')),
      reason: 'tied at 1, but seen least recently',
    );
  });

  test('recent games: all of them, newest first, updated live', () async {
    final games = FakeGameLogRepository(
      games: [game('older', day: 20), game('newer', day: 25)],
    );
    late ProgressViewModel viewModel;
    await withClock(Clock.fixed(now), () async {
      viewModel = ProgressViewModel(
        gameLogRepository: games,
        teamRepository: FakeTeamRepository(),
        pokemonRepository: FakePokemonRepository(),
        idGenerator: SequentialIdGenerator(),
        toLocal: costaRica,
      );
      await pumpEventQueue();
      expect(viewModel.stats.recentGames.map((g) => g.id), ['newer', 'older']);

      await games.add(game('just-logged', day: 30));
      await pumpEventQueue();
    });
    addTearDown(viewModel.dispose);

    expect(viewModel.stats.totalGames, 3);
    expect(viewModel.stats.recentGames.first.id, 'just-logged');
  });

  test(
    'by default uses the device timezone (a game just played is today)',
    () async {
      late ProgressViewModel viewModel;
      await withClock(Clock.fixed(now), () async {
        viewModel = ProgressViewModel(
          gameLogRepository: FakeGameLogRepository(
            games: [GameLog(id: 'now', playedAt: now, result: GameResult.win)],
          ),
          teamRepository: FakeTeamRepository(),
          pokemonRepository: FakePokemonRepository(),
          idGenerator: SequentialIdGenerator(),
        );
        await pumpEventQueue();
      });
      addTearDown(viewModel.dispose);

      expect(viewModel.stats.gamesLast7Days, 1);
      expect(viewModel.stats.dayStreak, 1);
    },
  );

  test('deleteGame removes a game and undoDelete brings it back', () async {
    final games = FakeGameLogRepository(
      games: [game('a', day: 29), game('b', day: 30)],
    );
    late ProgressViewModel viewModel;
    await withClock(Clock.fixed(now), () async {
      viewModel = ProgressViewModel(
        gameLogRepository: games,
        teamRepository: FakeTeamRepository(),
        pokemonRepository: FakePokemonRepository(),
        idGenerator: SequentialIdGenerator(),
        toLocal: costaRica,
      );
      await pumpEventQueue();

      await viewModel.deleteGame.execute(viewModel.stats.recentGames.first);
      await pumpEventQueue();
      expect(viewModel.deleteGame.completed, isTrue);
      expect(viewModel.stats.recentGames.map((g) => g.id), ['a']);

      await viewModel.undoDelete.execute();
      await pumpEventQueue();
    });
    addTearDown(viewModel.dispose);

    expect(viewModel.stats.recentGames.map((g) => g.id), ['b', 'a']);
  });

  test(
    'labels a game with its local date and Pokémon by display name',
    () async {
      final viewModel = await progressOf([]);

      // 23:30 local on the 29th is already the 30th in UTC.
      expect(
        viewModel.dateLabel(game('late', day: 29, hour: 23)),
        '2026-09-29',
      );
      expect(viewModel.pokemonName('raichu-mega-y'), 'Raichu-Mega-Y');
    },
  );

  group("saving a game's opponent as a team", () {
    const six = [
      'rillaboom',
      'sneasler',
      'incineroar',
      'kingambit',
      'salamence',
      'grimmsnarl',
    ];
    final played = GameLog(
      id: 'g1',
      playedAt: now,
      result: GameResult.loss,
      opponentTeam: six,
    );

    late FakeGameLogRepository games;
    late FakeTeamRepository teams;

    Future<ProgressViewModel> withGame(GameLog game) async {
      games = FakeGameLogRepository(games: [game]);
      teams = FakeTeamRepository();
      final viewModel = ProgressViewModel(
        gameLogRepository: games,
        teamRepository: teams,
        pokemonRepository: FakePokemonRepository(),
        idGenerator: SequentialIdGenerator(),
        toLocal: costaRica,
      );
      addTearDown(viewModel.dispose);
      await pumpEventQueue();
      return viewModel;
    }

    String? problem(ProgressViewModel viewModel) =>
        switch (viewModel.saveOpponentTeam.result) {
          Failure(error: SaveOpponentTeamError(:final message)) => message,
          _ => null,
        };

    test(
      'is offered for an unlinked game with all 6 of their Pokémon',
      () async {
        final viewModel = await withGame(played);

        expect(viewModel.canSaveOpponentTeam(played), isTrue);
        expect(
          viewModel.canSaveOpponentTeam(
            played.copyWith(opponentTeam: six.take(5).toList()),
          ),
          isFalse,
        );
        expect(
          viewModel.canSaveOpponentTeam(played.copyWith(opponentTeamId: 'o9')),
          isFalse,
        );
      },
    );

    test('saves their 6 as an opponent team and links the game', () async {
      final viewModel = await withGame(played);

      await viewModel.saveOpponentTeam.execute((
        game: played,
        name: '  Ladder Grassy ',
      ));

      expect(viewModel.saveOpponentTeam.completed, isTrue);
      final [team] = await teams.watchAll().first;
      expect(team.id, 'id-1');
      expect(team.name, 'Ladder Grassy');
      expect(team.side, TeamSide.opponent);
      expect(team.pokemon.map((p) => p.slug), six);
      expect(team.pokemon.first.displayName, 'Rillaboom');
      final [game] = await games.watchAll().first;
      expect(game.opponentTeamId, 'id-1');
      expect(game.opponentTeamName, 'Ladder Grassy');
    });

    test('needs a name', () async {
      final viewModel = await withGame(played);

      await viewModel.saveOpponentTeam.execute((game: played, name: ' '));

      expect(problem(viewModel), 'Give the team a name.');
      expect(await teams.watchAll().first, isEmpty);
    });

    test("a Pokémon that can't be looked up stops it, saving nothing", () async {
      final odd = played.copyWith(opponentTeam: [...six.take(5), 'missingno']);
      final viewModel = await withGame(odd);

      await viewModel.saveOpponentTeam.execute((game: odd, name: 'Odd'));

      expect(
        problem(viewModel),
        "Couldn't look up their Pokémon. Check your connection and try again.",
      );
      expect(await teams.watchAll().first, isEmpty);
      expect((await games.watchAll().first).single.opponentTeamId, isNull);
    });

    test('a failed save leaves the game unlinked', () async {
      final viewModel = await withGame(played);
      teams.failWith = Exception('disk full');

      await viewModel.saveOpponentTeam.execute((game: played, name: 'X'));

      expect(viewModel.saveOpponentTeam.error, isTrue);
      expect((await games.watchAll().first).single.opponentTeamId, isNull);
    });
  });
}
