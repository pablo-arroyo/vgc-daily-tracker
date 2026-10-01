import 'package:clock/clock.dart';
import 'package:flutter/foundation.dart';

import '../../../data/repositories/game_log/game_log_repository.dart';
import '../../../data/repositories/routine/routine_repository.dart';
import '../../../data/repositories/team/team_repository.dart';
import '../../../domain/backup/backup_format.dart';
import '../../../domain/models/backup.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';

/// A finished export: the text to copy, and what it holds.
typedef BackupExport = ({String text, String summary});

/// State for the Backup screen: copy everything out as JSON, or merge a
/// backup back in.
class BackupViewModel extends ChangeNotifier {
  BackupViewModel({
    required this._teamRepository,
    required this._gameLogRepository,
    required this._routineRepository,
  }) {
    export = Command0(_export);
    restore = Command1(_restore);
  }

  final TeamRepository _teamRepository;
  final GameLogRepository _gameLogRepository;
  final RoutineRepository _routineRepository;

  /// Builds the backup text of all teams, games and routine days.
  late final Command0<BackupExport> export;

  /// Merges a pasted backup in by id: the backup's copy replaces one with
  /// the same id, and everything else stays. Completes with a summary.
  late final Command1<String, String> restore;

  Future<Result<BackupExport>> _export() async {
    final Map<String, Set<String>> days;
    switch (await _routineRepository.allDays()) {
      case Ok(:final value):
        days = value;
      case Failure(:final error):
        return Result.failure(error);
    }
    final backup = Backup(
      exportedAt: clock.now().toUtc(),
      teams: await _teamRepository.watchAll().first,
      games: await _gameLogRepository.watchAll().first,
      routine: {
        for (final MapEntry(key: day, value: checked) in days.entries)
          day: checked.toList()..sort(),
      },
    );
    return Result.ok((
      text: BackupFormat.encode(backup),
      summary: _summary(backup),
    ));
  }

  Future<Result<String>> _restore(String text) async {
    if (text.trim().isEmpty) {
      return const Result.failure(
        BackupFormatException('Paste a backup first.'),
      );
    }
    final Backup backup;
    switch (BackupFormat.decode(text)) {
      case Ok(:final value):
        backup = value;
      case Failure(:final error):
        return Result.failure(error);
    }
    for (final team in backup.teams) {
      if (await _teamRepository.save(team) case Failure(:final error)) {
        return Result.failure(error);
      }
    }
    for (final game in backup.games) {
      if (await _gameLogRepository.add(game) case Failure(:final error)) {
        return Result.failure(error);
      }
    }
    for (final MapEntry(key: day, value: checked) in backup.routine.entries) {
      final saved = await _routineRepository.save(day, checked.toSet());
      if (saved case Failure(:final error)) return Result.failure(error);
    }
    return Result.ok(_summary(backup));
  }

  /// `2 teams, 1 game, 1 routine day`.
  static String _summary(Backup backup) => [
    _count(backup.teams.length, 'team'),
    _count(backup.games.length, 'game'),
    _count(backup.routine.length, 'routine day'),
  ].join(', ');

  static String _count(int n, String noun) => '$n $noun${n == 1 ? '' : 's'}';
}
