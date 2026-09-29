// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'named_api_resource.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NamedApiResource _$NamedApiResourceFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_NamedApiResource', json, ($checkedConvert) {
      final val = _NamedApiResource(
        name: $checkedConvert('name', (v) => v as String),
        url: $checkedConvert('url', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$NamedApiResourceToJson(_NamedApiResource instance) =>
    <String, dynamic>{'name': instance.name, 'url': instance.url};
