import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../config/format_config.dart';
import '../../../data/repositories/team/team_repository.dart';
import '../../../domain/models/team.dart';
import '../../../domain/use_cases/import_team_use_case.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';

/// State for the Teams tab: the saved teams, kept live from the repository.
class TeamsViewModel extends ChangeNotifier {
  TeamsViewModel({
    required this._teamRepository,
    required this._importTeam,
    required this._format,
  }) {
    deleteTeam = Command1(_deleteTeam);
    undoDelete = Command0(_undoDelete);
    addSampleTeams = Command0(_addSampleTeams);
    _subscription = _teamRepository.watchAll().listen((teams) {
      _teams = teams;
      _loaded = true;
      notifyListeners();
    });
  }

  final TeamRepository _teamRepository;
  final ImportTeamUseCase _importTeam;
  final FormatConfig _format;
  late final StreamSubscription<List<Team>> _subscription;

  /// Checks every sample team of the format, then saves them all, or none
  /// if any fails (e.g. offline).
  late final Command0<void> addSampleTeams;

  /// `Add Reg M-C sample teams`.
  String get sampleTeamsLabel => 'Add ${_format.label} sample teams';

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

  Future<Result<void>> _addSampleTeams() async {
    final teams = <Team>[];
    for (final sample in _format.sampleTeams) {
      switch (await _importTeam(name: sample.name, paste: sample.paste)) {
        case Ok(value: final team):
          teams.add(team);
        case Failure(:final error):
          return Result.failure(error);
      }
    }
    for (final team in teams) {
      final saved = await _teamRepository.save(team);
      if (saved is Failure) return saved;
    }
    return const Result.ok(null);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
