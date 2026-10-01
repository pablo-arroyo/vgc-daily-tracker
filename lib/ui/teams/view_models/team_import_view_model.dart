import 'package:flutter/foundation.dart';

import '../../../data/repositories/team/team_repository.dart';
import '../../../domain/models/team.dart';
import '../../../domain/use_cases/import_team_use_case.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';

/// State for importing a team from a Showdown paste: checks it with
/// [ImportTeamUseCase], then saves the team with its sets.
class TeamImportViewModel extends ChangeNotifier {
  TeamImportViewModel({
    required this._teamRepository,
    required this._importTeam,
    this._side = TeamSide.mine,
  }) {
    import = Command0(_import);
  }

  final TeamRepository _teamRepository;
  final ImportTeamUseCase _importTeam;
  final TeamSide _side;

  /// Whose team is being imported.
  TeamSide get side => _side;

  /// Validates the paste and saves it as a new team.
  late final Command0<void> import;

  String _name = '';
  String _paste = '';

  void setName(String name) => _name = name;

  void setPaste(String paste) => _paste = paste;

  /// What stopped the last import, or empty.
  List<String> get problems => switch (import.result) {
    Failure(error: TeamImportError(:final problems)) => problems,
    _ => const [],
  };

  Future<Result<void>> _import() async {
    switch (await _importTeam(name: _name, paste: _paste, side: _side)) {
      case Ok(value: final team):
        return _teamRepository.save(team);
      case Failure(:final error):
        return Result.failure(error);
    }
  }
}
