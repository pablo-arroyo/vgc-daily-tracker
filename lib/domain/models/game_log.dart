import 'package:freezed_annotation/freezed_annotation.dart';

import 'mistake_category.dart';

part 'game_log.freezed.dart';
part 'game_log.g.dart';

enum GameResult { win, loss }

/// One logged game: the original tracker's fields, with two fixes. The team
/// is referenced by id (its name is kept as a snapshot for display after the
/// team is deleted), and the time is a single UTC instant ([playedAt]), with
/// the local day derived when displaying rather than stored.
///
/// Pokémon are stored as PokéAPI slugs.
@freezed
abstract class GameLog with _$GameLog {
  const factory GameLog({
    required String id,
    required DateTime playedAt,
    required GameResult result,
    String? teamId,
    String? teamName,

    /// The full six of the team used; empty when no saved team was picked.
    @Default([]) List<String> team,
    @Default([]) List<String> brought,
    @Default([]) List<String> leads,

    /// The saved opponent team this game was against, if one was picked.
    /// Its name is kept too, so a deleted team still reads well.
    String? opponentTeamId,
    String? opponentTeamName,
    @Default([]) List<String> opponentTeam,
    @Default([]) List<String> opponentBrought,
    @Default([]) List<String> opponentLeads,

    /// "What decided this game?", when answered.
    MistakeCategory? mistake,
    @Default('') String notes,
  }) = _GameLog;

  factory GameLog.fromJson(Map<String, Object?> json) =>
      _$GameLogFromJson(json);
}
