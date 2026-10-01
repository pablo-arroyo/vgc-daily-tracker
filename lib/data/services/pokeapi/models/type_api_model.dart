import 'package:freezed_annotation/freezed_annotation.dart';

import 'named_api_resource.dart';

part 'type_api_model.freezed.dart';
part 'type_api_model.g.dart';

/// `GET /type/{name}`, keeping only what this type hits for how much (the
/// defending side follows from the other types' entries).
@freezed
abstract class TypeApiModel with _$TypeApiModel {
  const factory TypeApiModel({
    required int id,
    required String name,
    required DamageRelationsApiModel damageRelations,
  }) = _TypeApiModel;

  factory TypeApiModel.fromJson(Map<String, Object?> json) =>
      _$TypeApiModelFromJson(json);
}

@freezed
abstract class DamageRelationsApiModel with _$DamageRelationsApiModel {
  const factory DamageRelationsApiModel({
    required List<NamedApiResource> doubleDamageTo,
    required List<NamedApiResource> halfDamageTo,
    required List<NamedApiResource> noDamageTo,
  }) = _DamageRelationsApiModel;

  factory DamageRelationsApiModel.fromJson(Map<String, Object?> json) =>
      _$DamageRelationsApiModelFromJson(json);
}
