import 'package:freezed_annotation/freezed_annotation.dart';

import 'named_api_resource.dart';

part 'pokemon_list_api_model.freezed.dart';
part 'pokemon_list_api_model.g.dart';

/// `GET /pokemon?limit=N`: the paged name index. `count` is the total number
/// of entries, including alternate forms such as megas.
@freezed
abstract class PokemonListApiModel with _$PokemonListApiModel {
  const factory PokemonListApiModel({
    required int count,
    required List<NamedApiResource> results,
  }) = _PokemonListApiModel;

  factory PokemonListApiModel.fromJson(Map<String, Object?> json) =>
      _$PokemonListApiModelFromJson(json);
}
