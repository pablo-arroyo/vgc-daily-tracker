import 'package:freezed_annotation/freezed_annotation.dart';

part 'matchup_note.freezed.dart';
part 'matchup_note.g.dart';

/// Notes for one of your teams against one opponent team: the game plan
/// for that matchup.
@freezed
abstract class MatchupNote with _$MatchupNote {
  const factory MatchupNote({
    required String myTeamId,
    required String opponentTeamId,
    required String notes,
    required DateTime updatedAt,
  }) = _MatchupNote;

  const MatchupNote._();

  factory MatchupNote.fromJson(Map<String, Object?> json) =>
      _$MatchupNoteFromJson(json);

  /// One note per pair of teams.
  String get key => keyOf(myTeamId, opponentTeamId);

  /// The key for your team [myTeamId] against [opponentTeamId].
  static String keyOf(String myTeamId, String opponentTeamId) =>
      '$myTeamId|$opponentTeamId';
}
