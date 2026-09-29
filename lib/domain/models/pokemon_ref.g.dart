// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon_ref.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PokemonRef _$PokemonRefFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_PokemonRef', json, ($checkedConvert) {
      final val = _PokemonRef(
        id: $checkedConvert('id', (v) => (v as num).toInt()),
        slug: $checkedConvert('slug', (v) => v as String),
        displayName: $checkedConvert('display_name', (v) => v as String),
      );
      return val;
    }, fieldKeyMap: const {'displayName': 'display_name'});

Map<String, dynamic> _$PokemonRefToJson(_PokemonRef instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'display_name': instance.displayName,
    };
