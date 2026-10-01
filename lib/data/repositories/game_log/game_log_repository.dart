import '../../../domain/models/game_log.dart';
import '../../../utils/result.dart';

/// Order games are listed in: newest first.
int compareGamesNewestFirst(GameLog a, GameLog b) =>
    b.playedAt.compareTo(a.playedAt);

/// Source of truth for logged games.
abstract class GameLogRepository {
  /// Every logged game, sorted by [compareGamesNewestFirst], emitted now and
  /// again after each change.
  Stream<List<GameLog>> watchAll();

  /// Inserts [game], or replaces the game with the same id.
  Future<Result<void>> add(GameLog game);

  Future<Result<void>> delete(String id);
}
