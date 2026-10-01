// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'type_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TypeApiModel _$TypeApiModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_TypeApiModel', json, ($checkedConvert) {
      final val = _TypeApiModel(
        id: $checkedConvert('id', (v) => (v as num).toInt()),
        name: $checkedConvert('name', (v) => v as String),
        damageRelations: $checkedConvert(
          'damage_relations',
          (v) => DamageRelationsApiModel.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    }, fieldKeyMap: const {'damageRelations': 'damage_relations'});

Map<String, dynamic> _$TypeApiModelToJson(_TypeApiModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'damage_relations': instance.damageRelations.toJson(),
    };

_DamageRelationsApiModel _$DamageRelationsApiModelFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  '_DamageRelationsApiModel',
  json,
  ($checkedConvert) {
    final val = _DamageRelationsApiModel(
      doubleDamageTo: $checkedConvert(
        'double_damage_to',
        (v) => (v as List<dynamic>)
            .map((e) => NamedApiResource.fromJson(e as Map<String, dynamic>))
            .toList(),
      ),
      halfDamageTo: $checkedConvert(
        'half_damage_to',
        (v) => (v as List<dynamic>)
            .map((e) => NamedApiResource.fromJson(e as Map<String, dynamic>))
            .toList(),
      ),
      noDamageTo: $checkedConvert(
        'no_damage_to',
        (v) => (v as List<dynamic>)
            .map((e) => NamedApiResource.fromJson(e as Map<String, dynamic>))
            .toList(),
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'doubleDamageTo': 'double_damage_to',
    'halfDamageTo': 'half_damage_to',
    'noDamageTo': 'no_damage_to',
  },
);

Map<String, dynamic> _$DamageRelationsApiModelToJson(
  _DamageRelationsApiModel instance,
) => <String, dynamic>{
  'double_damage_to': instance.doubleDamageTo.map((e) => e.toJson()).toList(),
  'half_damage_to': instance.halfDamageTo.map((e) => e.toJson()).toList(),
  'no_damage_to': instance.noDamageTo.map((e) => e.toJson()).toList(),
};
