// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'matchup_note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MatchupNote _$MatchupNoteFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_MatchupNote',
  json,
  ($checkedConvert) {
    final val = _MatchupNote(
      myTeamId: $checkedConvert('my_team_id', (v) => v as String),
      opponentTeamId: $checkedConvert('opponent_team_id', (v) => v as String),
      notes: $checkedConvert('notes', (v) => v as String),
      updatedAt: $checkedConvert(
        'updated_at',
        (v) => DateTime.parse(v as String),
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'myTeamId': 'my_team_id',
    'opponentTeamId': 'opponent_team_id',
    'updatedAt': 'updated_at',
  },
);

Map<String, dynamic> _$MatchupNoteToJson(_MatchupNote instance) =>
    <String, dynamic>{
      'my_team_id': instance.myTeamId,
      'opponent_team_id': instance.opponentTeamId,
      'notes': instance.notes,
      'updated_at': instance.updatedAt.toIso8601String(),
    };
