import 'package:freezed_annotation/freezed_annotation.dart';

import 'game_log.dart';
import 'matchup_note.dart';
import 'team.dart';

part 'backup.freezed.dart';
part 'backup.g.dart';

/// Everything the player has entered: teams (both sides, with sets and
/// notes), logged games, routine ticks by local day and matchup notes. The Pokémon name index
/// isn't included, since it can always be downloaded again.
@freezed
abstract class Backup with _$Backup {
  const factory Backup({
    required DateTime exportedAt,
    required List<Team> teams,
    required List<GameLog> games,

    /// Ticked routine item ids per local day, e.g. `2026-09-30`.
    required Map<String, List<String>> routine,

    /// Game plans per pair of teams. Missing in backups made before matchup
    /// notes existed, which still restore.
    @Default([]) List<MatchupNote> matchups,
  }) = _Backup;

  factory Backup.fromJson(Map<String, Object?> json) => _$BackupFromJson(json);
}
