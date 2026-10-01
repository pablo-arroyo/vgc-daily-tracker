// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stat_spread.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StatSpread _$StatSpreadFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_StatSpread', json, ($checkedConvert) {
      final val = _StatSpread(
        hp: $checkedConvert('hp', (v) => (v as num?)?.toInt() ?? 0),
        atk: $checkedConvert('atk', (v) => (v as num?)?.toInt() ?? 0),
        def: $checkedConvert('def', (v) => (v as num?)?.toInt() ?? 0),
        spa: $checkedConvert('spa', (v) => (v as num?)?.toInt() ?? 0),
        spd: $checkedConvert('spd', (v) => (v as num?)?.toInt() ?? 0),
        spe: $checkedConvert('spe', (v) => (v as num?)?.toInt() ?? 0),
      );
      return val;
    });

Map<String, dynamic> _$StatSpreadToJson(_StatSpread instance) =>
    <String, dynamic>{
      'hp': instance.hp,
      'atk': instance.atk,
      'def': instance.def,
      'spa': instance.spa,
      'spd': instance.spd,
      'spe': instance.spe,
    };
