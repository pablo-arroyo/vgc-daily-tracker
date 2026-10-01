import '../../../domain/models/matchup_note.dart';
import '../../../utils/result.dart';
import '../../services/storage/local_storage_service.dart';
import 'matchup_repository.dart';

/// [MatchupRepository] on local storage: one document per pair of teams.
class MatchupRepositoryLocal implements MatchupRepository {
  MatchupRepositoryLocal({required this._storage});

  final LocalStorageService _storage;

  static const _store = 'matchups';

  @override
  Stream<List<MatchupNote>> watchAll() => _storage
      .watchAll(_store)
      .map(
        (documents) => [for (final doc in documents) MatchupNote.fromJson(doc)],
      );

  @override
  Future<Result<void>> save(MatchupNote note) =>
      _storage.put(_store, note.key, note.toJson());
}
