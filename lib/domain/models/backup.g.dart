// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Backup _$BackupFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_Backup', json, ($checkedConvert) {
      final val = _Backup(
        exportedAt: $checkedConvert(
          'exported_at',
          (v) => DateTime.parse(v as String),
        ),
        teams: $checkedConvert(
          'teams',
          (v) => (v as List<dynamic>)
              .map((e) => Team.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        games: $checkedConvert(
          'games',
          (v) => (v as List<dynamic>)
              .map((e) => GameLog.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        routine: $checkedConvert(
          'routine',
          (v) => (v as Map<String, dynamic>).map(
            (k, e) => MapEntry(
              k,
              (e as List<dynamic>).map((e) => e as String).toList(),
            ),
          ),
        ),
      );
      return val;
    }, fieldKeyMap: const {'exportedAt': 'exported_at'});

Map<String, dynamic> _$BackupToJson(_Backup instance) => <String, dynamic>{
  'exported_at': instance.exportedAt.toIso8601String(),
  'teams': instance.teams.map((e) => e.toJson()).toList(),
  'games': instance.games.map((e) => e.toJson()).toList(),
  'routine': instance.routine,
};
