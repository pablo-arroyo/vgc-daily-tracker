import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/domain/backup/backup_format.dart';
import 'package:vgc_daily_tracker/domain/models/backup.dart';
import 'package:vgc_daily_tracker/domain/models/game_log.dart';
import 'package:vgc_daily_tracker/domain/models/matchup_note.dart';
import 'package:vgc_daily_tracker/domain/models/team.dart';
import 'package:vgc_daily_tracker/ui/backup/view_models/backup_view_model.dart';
import 'package:vgc_daily_tracker/utils/result.dart';

import '../../../../testing/fakes/fake_game_log_repository.dart';
import '../../../../testing/fakes/fake_matchup_repository.dart';
import '../../../../testing/fakes/fake_routine_repository.dart';
import '../../../../testing/fakes/fake_team_repository.dart';

final now = DateTime.utc(2026, 10, 1, 9);

void main() {
  const mine = Team(id: 't1', name: 'Big Six', pokemon: []);
  const rival = Team(
    id: 'o1',
    name: 'Rival Grassy',
    pokemon: [],
    side: TeamSide.opponent,
  );
  final game = GameLog(
    id: 'g1',
    playedAt: DateTime.utc(2026, 9, 30, 20),
    result: GameResult.win,
  );

  late FakeTeamRepository teams;
  late FakeGameLogRepository games;
  late FakeRoutineRepository routine;
  late FakeMatchupRepository matchups;

  setUp(() {
    teams = FakeTeamRepository();
    games = FakeGameLogRepository();
    routine = FakeRoutineRepository();
    matchups = FakeMatchupRepository();
  });

  BackupViewModel create() {
    final viewModel = BackupViewModel(
      teamRepository: teams,
      gameLogRepository: games,
      routineRepository: routine,
      matchupRepository: matchups,
    );
    addTearDown(viewModel.dispose);
    return viewModel;
  }

  /// A backup's text, as another device would have copied it.
  String backupOf({
    List<Team> teams = const [],
    List<GameLog> games = const [],
    Map<String, List<String>> routine = const {},
    List<MatchupNote> matchups = const [],
  }) => BackupFormat.encode(
    Backup(
      exportedAt: now,
      teams: teams,
      games: games,
      routine: routine,
      matchups: matchups,
    ),
  );

  group('export', () {
    test('includes every team (both sides), game and routine day', () async {
      teams = FakeTeamRepository(teams: [mine, rival]);
      games = FakeGameLogRepository(games: [game]);
      await routine.save('2026-09-30', {'speed-order', 'log-fast'});
      final viewModel = create();

      await withClock(Clock.fixed(now), viewModel.export.execute);

      final exported = (viewModel.export.result! as Ok<BackupExport>).value;
      expect(exported.summary, '2 teams, 1 game, 1 routine day');
      final backup = (BackupFormat.decode(exported.text) as Ok<Backup>).value;
      expect(backup.exportedAt, now);
      expect(backup.teams, unorderedEquals([mine, rival]));
      expect(backup.games, [game]);
      expect(backup.routine, {
        '2026-09-30': ['log-fast', 'speed-order'],
      });
    });

    test('counts read naturally when there is nothing yet', () async {
      final viewModel = create();

      await viewModel.export.execute();

      expect(
        (viewModel.export.result! as Ok<BackupExport>).value.summary,
        '0 teams, 0 games, 0 routine days',
      );
    });
  });

  group('matchup notes', () {
    final plan = MatchupNote(
      myTeamId: 't1',
      opponentTeamId: 'o1',
      notes: 'Lead Whimsicott.',
      updatedAt: DateTime.utc(2026, 9, 30),
    );

    test('are exported, and named in the summary', () async {
      matchups = FakeMatchupRepository(notes: [plan]);
      final viewModel = create();

      await viewModel.export.execute();

      final exported = (viewModel.export.result! as Ok<BackupExport>).value;
      expect(
        exported.summary,
        '0 teams, 0 games, 0 routine days, 1 matchup note',
      );
      expect(
        (BackupFormat.decode(exported.text) as Ok<Backup>).value.matchups,
        [plan],
      );
    });

    test('are restored, merged by pair of teams', () async {
      final viewModel = create();

      await viewModel.restore.execute(backupOf(matchups: [plan]));

      expect(await matchups.watchAll().first, [plan]);
    });
  });

  group('restore', () {
    String? problem(BackupViewModel viewModel) =>
        switch (viewModel.restore.result) {
          Failure(error: BackupFormatException(:final message)) => message,
          _ => null,
        };

    test('merges by id: same ids replaced, everything else kept', () async {
      const kept = Team(id: 't2', name: 'Kept', pokemon: []);
      teams = FakeTeamRepository(teams: [mine, kept]);
      await routine.save('2026-09-29', {'log-fast'});
      await routine.save('2026-09-30', {'log-fast'});
      final viewModel = create();

      await viewModel.restore.execute(
        backupOf(
          teams: [
            mine.copyWith(name: 'Big Six (restored)'),
            rival,
          ],
          games: [game],
          routine: {
            '2026-09-30': ['speed-order'],
          },
        ),
      );

      expect(
        (viewModel.restore.result! as Ok<String>).value,
        '2 teams, 1 game, 1 routine day',
      );
      expect(
        (await teams.watchAll().first).map((t) => t.name),
        unorderedEquals(['Big Six (restored)', 'Kept', 'Rival Grassy']),
      );
      expect(await games.watchAll().first, [game]);
      expect((await routine.allDays() as Ok<Map<String, Set<String>>>).value, {
        '2026-09-29': {'log-fast'},
        '2026-09-30': {'speed-order'},
      });
    });

    test('restoring the same backup twice changes nothing more', () async {
      final viewModel = create();
      final text = backupOf(teams: [mine], games: [game]);

      await viewModel.restore.execute(text);
      await viewModel.restore.execute(text);

      expect(await teams.watchAll().first, [mine]);
      expect(await games.watchAll().first, [game]);
    });

    test("says why text can't be restored, and changes nothing", () async {
      final viewModel = create();

      await viewModel.restore.execute('{"teams": []}');

      expect(problem(viewModel), "This isn't a VGC Daily Tracker backup.");
      expect(await teams.watchAll().first, isEmpty);
    });

    test('asks for a backup when the field is empty', () async {
      final viewModel = create();

      await viewModel.restore.execute('  ');

      expect(problem(viewModel), 'Paste a backup first.');
    });

    test('a failed save is an error', () async {
      teams.failWith = Exception('disk full');
      final viewModel = create();

      await viewModel.restore.execute(backupOf(teams: [mine]));

      expect(viewModel.restore.error, isTrue);
      expect(problem(viewModel), isNull);
    });
  });
}
