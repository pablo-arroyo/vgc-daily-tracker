import 'package:freezed_annotation/freezed_annotation.dart';

import 'named_api_resource.dart';

part 'pokemon_detail_api_model.freezed.dart';
part 'pokemon_detail_api_model.g.dart';

/// `GET /pokemon/{slug}`, keeping only the fields the app reads. Field names
/// and nesting mirror the JSON; unknown keys are ignored when parsing.
@freezed
abstract class PokemonDetailApiModel with _$PokemonDetailApiModel {
  const factory PokemonDetailApiModel({
    required int id,
    required String name,
    required NamedApiResource species,
    required List<PokemonTypeSlotApiModel> types,
    required List<PokemonStatApiModel> stats,
    required List<PokemonAbilityApiModel> abilities,
    required PokemonSpritesApiModel sprites,
  }) = _PokemonDetailApiModel;

  factory PokemonDetailApiModel.fromJson(Map<String, Object?> json) =>
      _$PokemonDetailApiModelFromJson(json);
}

@freezed
abstract class PokemonTypeSlotApiModel with _$PokemonTypeSlotApiModel {
  const factory PokemonTypeSlotApiModel({
    required int slot,
    required NamedApiResource type,
  }) = _PokemonTypeSlotApiModel;

  factory PokemonTypeSlotApiModel.fromJson(Map<String, Object?> json) =>
      _$PokemonTypeSlotApiModelFromJson(json);
}

@freezed
abstract class PokemonStatApiModel with _$PokemonStatApiModel {
  const factory PokemonStatApiModel({
    required int baseStat,
    required int effort,
    required NamedApiResource stat,
  }) = _PokemonStatApiModel;

  factory PokemonStatApiModel.fromJson(Map<String, Object?> json) =>
      _$PokemonStatApiModelFromJson(json);
}

@freezed
abstract class PokemonAbilityApiModel with _$PokemonAbilityApiModel {
  const factory PokemonAbilityApiModel({
    required NamedApiResource ability,
    required bool isHidden,
    required int slot,
  }) = _PokemonAbilityApiModel;

  factory PokemonAbilityApiModel.fromJson(Map<String, Object?> json) =>
      _$PokemonAbilityApiModelFromJson(json);
}

@freezed
abstract class PokemonSpritesApiModel with _$PokemonSpritesApiModel {
  const factory PokemonSpritesApiModel({
    required String frontDefault,
    OtherSpritesApiModel? other,
  }) = _PokemonSpritesApiModel;

  factory PokemonSpritesApiModel.fromJson(Map<String, Object?> json) =>
      _$PokemonSpritesApiModelFromJson(json);
}

@freezed
abstract class OtherSpritesApiModel with _$OtherSpritesApiModel {
  const factory OtherSpritesApiModel({
    @JsonKey(name: 'official-artwork') OfficialArtworkApiModel? officialArtwork,
  }) = _OtherSpritesApiModel;

  factory OtherSpritesApiModel.fromJson(Map<String, Object?> json) =>
      _$OtherSpritesApiModelFromJson(json);
}

@freezed
abstract class OfficialArtworkApiModel with _$OfficialArtworkApiModel {
  const factory OfficialArtworkApiModel({required String frontDefault}) =
      _OfficialArtworkApiModel;

  factory OfficialArtworkApiModel.fromJson(Map<String, Object?> json) =>
      _$OfficialArtworkApiModelFromJson(json);
}
