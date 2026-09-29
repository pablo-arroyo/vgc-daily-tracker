// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon_detail_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PokemonDetailApiModel _$PokemonDetailApiModelFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_PokemonDetailApiModel', json, ($checkedConvert) {
  final val = _PokemonDetailApiModel(
    id: $checkedConvert('id', (v) => (v as num).toInt()),
    name: $checkedConvert('name', (v) => v as String),
    species: $checkedConvert(
      'species',
      (v) => NamedApiResource.fromJson(v as Map<String, dynamic>),
    ),
    types: $checkedConvert(
      'types',
      (v) => (v as List<dynamic>)
          .map(
            (e) => PokemonTypeSlotApiModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    ),
    stats: $checkedConvert(
      'stats',
      (v) => (v as List<dynamic>)
          .map((e) => PokemonStatApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    abilities: $checkedConvert(
      'abilities',
      (v) => (v as List<dynamic>)
          .map(
            (e) => PokemonAbilityApiModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    ),
    sprites: $checkedConvert(
      'sprites',
      (v) => PokemonSpritesApiModel.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$PokemonDetailApiModelToJson(
  _PokemonDetailApiModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'species': instance.species,
  'types': instance.types,
  'stats': instance.stats,
  'abilities': instance.abilities,
  'sprites': instance.sprites,
};

_PokemonTypeSlotApiModel _$PokemonTypeSlotApiModelFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_PokemonTypeSlotApiModel', json, ($checkedConvert) {
  final val = _PokemonTypeSlotApiModel(
    slot: $checkedConvert('slot', (v) => (v as num).toInt()),
    type: $checkedConvert(
      'type',
      (v) => NamedApiResource.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$PokemonTypeSlotApiModelToJson(
  _PokemonTypeSlotApiModel instance,
) => <String, dynamic>{'slot': instance.slot, 'type': instance.type};

_PokemonStatApiModel _$PokemonStatApiModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_PokemonStatApiModel', json, ($checkedConvert) {
      final val = _PokemonStatApiModel(
        baseStat: $checkedConvert('base_stat', (v) => (v as num).toInt()),
        effort: $checkedConvert('effort', (v) => (v as num).toInt()),
        stat: $checkedConvert(
          'stat',
          (v) => NamedApiResource.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    }, fieldKeyMap: const {'baseStat': 'base_stat'});

Map<String, dynamic> _$PokemonStatApiModelToJson(
  _PokemonStatApiModel instance,
) => <String, dynamic>{
  'base_stat': instance.baseStat,
  'effort': instance.effort,
  'stat': instance.stat,
};

_PokemonAbilityApiModel _$PokemonAbilityApiModelFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_PokemonAbilityApiModel', json, ($checkedConvert) {
  final val = _PokemonAbilityApiModel(
    ability: $checkedConvert(
      'ability',
      (v) => NamedApiResource.fromJson(v as Map<String, dynamic>),
    ),
    isHidden: $checkedConvert('is_hidden', (v) => v as bool),
    slot: $checkedConvert('slot', (v) => (v as num).toInt()),
  );
  return val;
}, fieldKeyMap: const {'isHidden': 'is_hidden'});

Map<String, dynamic> _$PokemonAbilityApiModelToJson(
  _PokemonAbilityApiModel instance,
) => <String, dynamic>{
  'ability': instance.ability,
  'is_hidden': instance.isHidden,
  'slot': instance.slot,
};

_PokemonSpritesApiModel _$PokemonSpritesApiModelFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_PokemonSpritesApiModel', json, ($checkedConvert) {
  final val = _PokemonSpritesApiModel(
    frontDefault: $checkedConvert('front_default', (v) => v as String),
    other: $checkedConvert(
      'other',
      (v) => v == null
          ? null
          : OtherSpritesApiModel.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
}, fieldKeyMap: const {'frontDefault': 'front_default'});

Map<String, dynamic> _$PokemonSpritesApiModelToJson(
  _PokemonSpritesApiModel instance,
) => <String, dynamic>{
  'front_default': instance.frontDefault,
  'other': instance.other,
};

_OtherSpritesApiModel _$OtherSpritesApiModelFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_OtherSpritesApiModel', json, ($checkedConvert) {
  final val = _OtherSpritesApiModel(
    officialArtwork: $checkedConvert(
      'official-artwork',
      (v) => v == null
          ? null
          : OfficialArtworkApiModel.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
}, fieldKeyMap: const {'officialArtwork': 'official-artwork'});

Map<String, dynamic> _$OtherSpritesApiModelToJson(
  _OtherSpritesApiModel instance,
) => <String, dynamic>{'official-artwork': instance.officialArtwork};

_OfficialArtworkApiModel _$OfficialArtworkApiModelFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_OfficialArtworkApiModel', json, ($checkedConvert) {
  final val = _OfficialArtworkApiModel(
    frontDefault: $checkedConvert('front_default', (v) => v as String),
  );
  return val;
}, fieldKeyMap: const {'frontDefault': 'front_default'});

Map<String, dynamic> _$OfficialArtworkApiModelToJson(
  _OfficialArtworkApiModel instance,
) => <String, dynamic>{'front_default': instance.frontDefault};
