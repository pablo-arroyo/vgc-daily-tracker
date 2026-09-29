import '../../../domain/models/team.dart';
import '../../../utils/result.dart';
import '../../services/storage/local_storage_service.dart';
import 'team_repository.dart';

/// [TeamRepository] on local storage: one document per team, keyed by id.
class TeamRepositoryLocal implements TeamRepository {
  TeamRepositoryLocal({required this._storage});

  final LocalStorageService _storage;

  static const _store = 'teams';

  @override
  Stream<List<Team>> watchAll() => _storage
      .watchAll(_store)
      .map(
        (documents) =>
            [for (final doc in documents) Team.fromJson(doc)]
              ..sort(compareTeamsByName),
      );

  @override
  Future<Result<void>> save(Team team) =>
      _storage.put(_store, team.id, team.toJson());

  @override
  Future<Result<void>> delete(String id) => _storage.delete(_store, id);
}
