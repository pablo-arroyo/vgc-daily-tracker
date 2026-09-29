import '../../../domain/models/team.dart';
import '../../../utils/result.dart';

/// Order teams are listed in: alphabetical, ignoring case.
int compareTeamsByName(Team a, Team b) =>
    a.name.toLowerCase().compareTo(b.name.toLowerCase());

/// Source of truth for the player's saved teams.
abstract class TeamRepository {
  /// Every team, sorted by [compareTeamsByName], emitted now and again after
  /// each change.
  Stream<List<Team>> watchAll();

  /// Inserts [team], or replaces the team with the same id.
  Future<Result<void>> save(Team team);

  Future<Result<void>> delete(String id);
}
