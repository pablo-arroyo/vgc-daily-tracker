import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/data/repositories/game_log/game_log_repository_local.dart';
import 'package:vgc_daily_tracker/data/repositories/team/team_repository_local.dart';
import 'package:vgc_daily_tracker/domain/models/game_log.dart';
import 'package:vgc_daily_tracker/domain/models/team.dart';

import '../../../testing/storage.dart';

void main() {
  test('deleting a team keeps its games, which still show its name', () async {
    final storage = await memoryStorage();
    final teams = TeamRepositoryLocal(storage: storage);
    final games = GameLogRepositoryLocal(storage: storage);
    await teams.save(const Team(id: 't1', name: 'Big Six', pokemon: []));
    await games.add(
      GameLog(
        id: 'g1',
        playedAt: DateTime.utc(2026, 9, 29, 20),
        result: GameResult.win,
        teamId: 't1',
        teamName: 'Big Six',
      ),
    );

    await teams.delete('t1');

    expect(await teams.watchAll().first, isEmpty);
    final [kept] = await games.watchAll().first;
    expect(kept.teamName, 'Big Six');
  });
}
