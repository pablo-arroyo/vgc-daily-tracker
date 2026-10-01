// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon_set.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PokemonSet _$PokemonSetFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_PokemonSet',
  json,
  ($checkedConvert) {
    final val = _PokemonSet(
      species: $checkedConvert('species', (v) => v as String),
      nickname: $checkedConvert('nickname', (v) => v as String?),
      gender: $checkedConvert('gender', (v) => v as String?),
      item: $checkedConvert('item', (v) => v as String?),
      ability: $checkedConvert('ability', (v) => v as String?),
      megaAbility: $checkedConvert('mega_ability', (v) => v as String?),
      level: $checkedConvert('level', (v) => (v as num?)?.toInt() ?? 50),
      evs: $checkedConvert(
        'evs',
        (v) => v == null
            ? const StatSpread()
            : StatSpread.fromJson(v as Map<String, dynamic>),
      ),
      ivs: $checkedConvert(
        'ivs',
        (v) => v == null
            ? StatSpread.perfectIvs
            : StatSpread.fromJson(v as Map<String, dynamic>),
      ),
      nature: $checkedConvert(
        'nature',
        (v) => $enumDecodeNullable(_$NatureEnumMap, v) ?? Nature.serious,
      ),
      moves: $checkedConvert(
        'moves',
        (v) =>
            (v as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      ),
    );
    return val;
  },
  fieldKeyMap: const {'megaAbility': 'mega_ability'},
);

Map<String, dynamic> _$PokemonSetToJson(_PokemonSet instance) =>
    <String, dynamic>{
      'species': instance.species,
      'nickname': instance.nickname,
      'gender': instance.gender,
      'item': instance.item,
      'ability': instance.ability,
      'mega_ability': instance.megaAbility,
      'level': instance.level,
      'evs': instance.evs.toJson(),
      'ivs': instance.ivs.toJson(),
      'nature': _$NatureEnumMap[instance.nature]!,
      'moves': instance.moves,
    };

const _$NatureEnumMap = {
  Nature.hardy: 'hardy',
  Nature.lonely: 'lonely',
  Nature.brave: 'brave',
  Nature.adamant: 'adamant',
  Nature.naughty: 'naughty',
  Nature.bold: 'bold',
  Nature.docile: 'docile',
  Nature.relaxed: 'relaxed',
  Nature.impish: 'impish',
  Nature.lax: 'lax',
  Nature.timid: 'timid',
  Nature.hasty: 'hasty',
  Nature.serious: 'serious',
  Nature.jolly: 'jolly',
  Nature.naive: 'naive',
  Nature.modest: 'modest',
  Nature.mild: 'mild',
  Nature.quiet: 'quiet',
  Nature.bashful: 'bashful',
  Nature.rash: 'rash',
  Nature.calm: 'calm',
  Nature.gentle: 'gentle',
  Nature.sassy: 'sassy',
  Nature.careful: 'careful',
  Nature.quirky: 'quirky',
};
