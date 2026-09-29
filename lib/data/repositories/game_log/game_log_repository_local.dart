import '../../../domain/models/game_log.dart';
import '../../../utils/result.dart';
import '../../services/storage/local_storage_service.dart';
import 'game_log_repository.dart';

/// [GameLogRepository] on local storage: one document per game, keyed by id.
class GameLogRepositoryLocal implements GameLogRepository {
  GameLogRepositoryLocal({required this._storage});

  final LocalStorageService _storage;

  static const _store = 'game_logs';

  @override
  Stream<List<GameLog>> watchAll() => _storage
      .watchAll(_store)
      .map(
        (documents) =>
            [for (final doc in documents) GameLog.fromJson(doc)]
              ..sort(compareGamesNewestFirst),
      );

  @override
  Future<Result<void>> add(GameLog game) =>
      _storage.put(_store, game.id, game.toJson());

  @override
  Future<Result<void>> delete(String id) => _storage.delete(_store, id);
}
