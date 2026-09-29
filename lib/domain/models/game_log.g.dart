// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GameLog _$GameLogFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_GameLog',
  json,
  ($checkedConvert) {
    final val = _GameLog(
      id: $checkedConvert('id', (v) => v as String),
      playedAt: $checkedConvert(
        'played_at',
        (v) => DateTime.parse(v as String),
      ),
      result: $checkedConvert(
        'result',
        (v) => $enumDecode(_$GameResultEnumMap, v),
      ),
      teamId: $checkedConvert('team_id', (v) => v as String?),
      teamName: $checkedConvert('team_name', (v) => v as String?),
      team: $checkedConvert(
        'team',
        (v) =>
            (v as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      ),
      brought: $checkedConvert(
        'brought',
        (v) =>
            (v as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      ),
      leads: $checkedConvert(
        'leads',
        (v) =>
            (v as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      ),
      opponentTeam: $checkedConvert(
        'opponent_team',
        (v) =>
            (v as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      ),
      opponentBrought: $checkedConvert(
        'opponent_brought',
        (v) =>
            (v as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      ),
      opponentLeads: $checkedConvert(
        'opponent_leads',
        (v) =>
            (v as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      ),
      mistake: $checkedConvert(
        'mistake',
        (v) => $enumDecodeNullable(_$MistakeCategoryEnumMap, v),
      ),
      notes: $checkedConvert('notes', (v) => v as String? ?? ''),
    );
    return val;
  },
  fieldKeyMap: const {
    'playedAt': 'played_at',
    'teamId': 'team_id',
    'teamName': 'team_name',
    'opponentTeam': 'opponent_team',
    'opponentBrought': 'opponent_brought',
    'opponentLeads': 'opponent_leads',
  },
);

Map<String, dynamic> _$GameLogToJson(_GameLog instance) => <String, dynamic>{
  'id': instance.id,
  'played_at': instance.playedAt.toIso8601String(),
  'result': _$GameResultEnumMap[instance.result]!,
  'team_id': instance.teamId,
  'team_name': instance.teamName,
  'team': instance.team,
  'brought': instance.brought,
  'leads': instance.leads,
  'opponent_team': instance.opponentTeam,
  'opponent_brought': instance.opponentBrought,
  'opponent_leads': instance.opponentLeads,
  'mistake': _$MistakeCategoryEnumMap[instance.mistake],
  'notes': instance.notes,
};

const _$GameResultEnumMap = {GameResult.win: 'win', GameResult.loss: 'loss'};

const _$MistakeCategoryEnumMap = {
  MistakeCategory.playedWell: 'playedWell',
  MistakeCategory.teamPreview: 'teamPreview',
  MistakeCategory.protectCall: 'protectCall',
  MistakeCategory.speedCalc: 'speedCalc',
  MistakeCategory.overcommitted: 'overcommitted',
  MistakeCategory.wrongBring: 'wrongBring',
  MistakeCategory.damageCalc: 'damageCalc',
  MistakeCategory.teambuildingGap: 'teambuildingGap',
  MistakeCategory.outplayed: 'outplayed',
};
