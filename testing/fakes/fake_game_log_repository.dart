import 'dart:async';

import 'package:vgc_daily_tracker/data/repositories/game_log/game_log_repository.dart';
import 'package:vgc_daily_tracker/domain/models/game_log.dart';
import 'package:vgc_daily_tracker/utils/result.dart';

/// In-memory [GameLogRepository]. Passes the same contract tests as the real
/// one, so screen tests can rely on it.
class FakeGameLogRepository implements GameLogRepository {
  final _games = <String, GameLog>{};
  final _changes = StreamController<List<GameLog>>.broadcast();

  List<GameLog> get _current =>
      _games.values.toList()..sort(compareGamesNewestFirst);

  @override
  Stream<List<GameLog>> watchAll() async* {
    yield _current;
    yield* _changes.stream;
  }

  @override
  Future<Result<void>> add(GameLog game) async {
    _games[game.id] = game;
    _changes.add(_current);
    return const Result.ok(null);
  }

  @override
  Future<Result<void>> delete(String id) async {
    _games.remove(id);
    _changes.add(_current);
    return const Result.ok(null);
  }
}
