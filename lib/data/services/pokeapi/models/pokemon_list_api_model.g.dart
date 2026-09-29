// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon_list_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PokemonListApiModel _$PokemonListApiModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_PokemonListApiModel', json, ($checkedConvert) {
      final val = _PokemonListApiModel(
        count: $checkedConvert('count', (v) => (v as num).toInt()),
        results: $checkedConvert(
          'results',
          (v) => (v as List<dynamic>)
              .map((e) => NamedApiResource.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$PokemonListApiModelToJson(
  _PokemonListApiModel instance,
) => <String, dynamic>{'count': instance.count, 'results': instance.results};
