// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ItemApiModel _$ItemApiModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_ItemApiModel', json, ($checkedConvert) {
      final val = _ItemApiModel(
        id: $checkedConvert('id', (v) => (v as num).toInt()),
        name: $checkedConvert('name', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$ItemApiModelToJson(_ItemApiModel instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};
