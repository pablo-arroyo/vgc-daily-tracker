import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/data/repositories/game_log/game_log_repository.dart';
import 'package:vgc_daily_tracker/domain/models/game_log.dart';
import 'package:vgc_daily_tracker/utils/result.dart';

/// Behavior every [GameLogRepository] must have. Run against the real
/// implementation and the fake, so screen tests can trust the fake.
void gameLogRepositoryContract(Future<GameLogRepository> Function() create) {
  late GameLogRepository repository;

  setUp(() async => repository = await create());

  GameLog game(String id, {int day = 29, int hour = 20}) => GameLog(
    id: id,
    playedAt: DateTime.utc(2026, 9, day, hour),
    result: GameResult.win,
  );

  test('an added game appears in watchAll', () async {
    final added = await repository.add(game('g1'));

    expect(added, isA<Ok<void>>());
    expect(await repository.watchAll().first, [game('g1')]);
  });

  test('adding a game with an existing id replaces it', () async {
    await repository.add(game('g1'));

    await repository.add(game('g1').copyWith(opponentTeamId: 'o1'));

    expect(await repository.watchAll().first, [
      game('g1').copyWith(opponentTeamId: 'o1'),
    ]);
  });

  test('lists games newest first', () async {
    await repository.add(game('mid', day: 28));
    await repository.add(game('newest', day: 29, hour: 23));
    await repository.add(game('oldest', day: 20));
    await repository.add(game('earlier-today', day: 29, hour: 9));

    final ids = (await repository.watchAll().first).map((g) => g.id);

    expect(ids, ['newest', 'earlier-today', 'mid', 'oldest']);
  });

  test('delete removes the game, and watchers see it go', () async {
    await repository.add(game('g1', day: 28));
    await repository.add(game('g2', day: 29));
    final emissions = repository.watchAll().take(2).toList();
    await Future<void>.delayed(Duration.zero);

    final deleted = await repository.delete('g2');

    expect(deleted, isA<Ok<void>>());
    final [before, after] = await emissions;
    expect(before.map((g) => g.id), ['g2', 'g1']);
    expect(after.map((g) => g.id), ['g1']);
  });

  test('concurrent adds never overwrite each other', () async {
    await Future.wait([
      for (var i = 0; i < 25; i++) repository.add(game('g$i', hour: i % 24)),
    ]);

    expect(await repository.watchAll().first, hasLength(25));
  });
}
