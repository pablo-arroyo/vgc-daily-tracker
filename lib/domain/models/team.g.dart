// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Team _$TeamFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_Team', json, ($checkedConvert) {
      final val = _Team(
        id: $checkedConvert('id', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        pokemon: $checkedConvert(
          'pokemon',
          (v) => (v as List<dynamic>)
              .map((e) => PokemonRef.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        sets: $checkedConvert(
          'sets',
          (v) =>
              (v as List<dynamic>?)
                  ?.map((e) => PokemonSet.fromJson(e as Map<String, dynamic>))
                  .toList() ??
              const [],
        ),
        side: $checkedConvert(
          'side',
          (v) => $enumDecodeNullable(_$TeamSideEnumMap, v) ?? TeamSide.mine,
        ),
      );
      return val;
    });

Map<String, dynamic> _$TeamToJson(_Team instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'pokemon': instance.pokemon.map((e) => e.toJson()).toList(),
  'sets': instance.sets.map((e) => e.toJson()).toList(),
  'side': _$TeamSideEnumMap[instance.side]!,
};

const _$TeamSideEnumMap = {
  TeamSide.mine: 'mine',
  TeamSide.opponent: 'opponent',
};
