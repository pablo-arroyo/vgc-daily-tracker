import 'dart:async';

import 'package:vgc_daily_tracker/data/repositories/team/team_repository.dart';
import 'package:vgc_daily_tracker/domain/models/team.dart';
import 'package:vgc_daily_tracker/utils/result.dart';

/// In-memory [TeamRepository]. Passes the same contract tests as the real
/// one, so screen tests can rely on it.
class FakeTeamRepository implements TeamRepository {
  FakeTeamRepository({List<Team> teams = const []})
    : _teams = {for (final team in teams) team.id: team};

  final Map<String, Team> _teams;

  /// When set, `save` and `delete` fail with it and change nothing.
  Exception? failWith;
  final _changes = StreamController<List<Team>>.broadcast();

  List<Team> get _current => _teams.values.toList()..sort(compareTeamsByName);

  @override
  Stream<List<Team>> watchAll() async* {
    yield _current;
    yield* _changes.stream;
  }

  @override
  Future<Result<void>> save(Team team) async {
    if (failWith case final error?) return Result.failure(error);
    _teams[team.id] = team;
    _changes.add(_current);
    return const Result.ok(null);
  }

  @override
  Future<Result<void>> delete(String id) async {
    if (failWith case final error?) return Result.failure(error);
    _teams.remove(id);
    _changes.add(_current);
    return const Result.ok(null);
  }
}
