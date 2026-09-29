import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../data/repositories/team/team_repository.dart';
import '../../../domain/models/team.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';

/// State for the Teams tab: the saved teams, kept live from the repository.
class TeamsViewModel extends ChangeNotifier {
  TeamsViewModel({required TeamRepository teamRepository})
    : _teamRepository = teamRepository {
    deleteTeam = Command1(_deleteTeam);
    undoDelete = Command0(_undoDelete);
    _subscription = teamRepository.watchAll().listen((teams) {
      _teams = teams;
      _loaded = true;
      notifyListeners();
    });
  }

  final TeamRepository _teamRepository;
  late final StreamSubscription<List<Team>> _subscription;

  /// Deletes a team, remembering it so [undoDelete] can restore it.
  late final Command1<void, Team> deleteTeam;

  /// Restores the team removed by the last [deleteTeam].
  late final Command0<void> undoDelete;

  Team? _lastDeleted;

  bool _loaded = false;
  List<Team> _teams = const [];

  /// False until the first list arrives, so the view can show a spinner
  /// rather than a misleading "no teams" message.
  bool get loaded => _loaded;

  List<Team> get teams => _teams;

  Future<Result<void>> _deleteTeam(Team team) {
    // Undo is only offered after a successful delete (see TeamsScreen).
    _lastDeleted = team;
    return _teamRepository.delete(team.id);
  }

  Future<Result<void>> _undoDelete() async {
    final team = _lastDeleted!;
    _lastDeleted = null;
    return _teamRepository.save(team);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
