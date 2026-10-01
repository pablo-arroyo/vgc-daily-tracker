import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/models/game_log.dart';
import '../../../domain/models/mistake_category.dart';

part 'progress_stats.freezed.dart';

/// Everything the Progress tab shows, computed from the game log.
/// Percentages are rounded like the original tracker and null with no games.
@freezed
abstract class ProgressStats with _$ProgressStats {
  const factory ProgressStats({
    required int totalGames,
    required int? winRatePercent,
    required int gamesLast7Days,
    required int? winRateLast7DaysPercent,
    required int dayStreak,
    required WeeklyFocus? weeklyFocus,
    required List<MistakeCount> mistakeBreakdown,
    required List<TeamRecord> teamRecords,

    /// Your record against each saved opponent team (games linked to one).
    required List<TeamRecord> opponentTeamRecords,
    required List<LeadRecord> opponentLeads,

    /// Best-of-3 sets: decided ones make the record; ended early or still
    /// open ones count as unfinished.
    required int setsWon,
    required int setsLost,
    required int? setWinRatePercent,
    required int unfinishedSets,

    /// Win % in game 1 of a set, against games 2–3 (how you adapt).
    required int? game1WinRatePercent,
    required int? laterGamesWinRatePercent,

    /// The most recent sets, newest first.
    required List<SetRecord> recentSets,
    required List<GameLog> recentGames,
  }) = _ProgressStats;
}

/// The mistake to watch for this week: it showed up in [count] of the
/// [gamesWithMistakes] games that had a mistake picked in the last 14 days.
@freezed
abstract class WeeklyFocus with _$WeeklyFocus {
  const factory WeeklyFocus({
    required MistakeCategory mistake,
    required int count,
    required int gamesWithMistakes,
  }) = _WeeklyFocus;
}

@freezed
abstract class MistakeCount with _$MistakeCount {
  const factory MistakeCount({
    required MistakeCategory mistake,
    required int count,
  }) = _MistakeCount;
}

/// Your record with one team (or against one opponent team), grouped by
/// team id; [teamName] is the name from the most recent game with it.
@freezed
abstract class TeamRecord with _$TeamRecord {
  const factory TeamRecord({
    required String teamId,
    required String teamName,
    required int wins,
    required int losses,
    required int winRatePercent,
  }) = _TeamRecord;
}

/// An opponent lead you've faced [timesSeen] times, with your win rate
/// against it.
@freezed
abstract class LeadRecord with _$LeadRecord {
  const factory LeadRecord({
    required String slug,
    required int timesSeen,
    required int winRatePercent,
  }) = _LeadRecord;
}

/// One best-of-3, as a single line, e.g.
/// `Rival Grassy · Won 2–1 · W L W`.
@freezed
abstract class SetRecord with _$SetRecord {
  const factory SetRecord({required String setId, required String label}) =
      _SetRecord;
}
