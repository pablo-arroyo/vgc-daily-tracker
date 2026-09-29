import 'package:freezed_annotation/freezed_annotation.dart';

part 'pokemon_ref.freezed.dart';
part 'pokemon_ref.g.dart';

/// A lightweight pointer to a Pokémon, from the name index: enough to show
/// it in a list and to fetch the full [Pokemon] later.
@freezed
abstract class PokemonRef with _$PokemonRef {
  const factory PokemonRef({
    required int id,
    required String slug,
    required String displayName,
  }) = _PokemonRef;

  factory PokemonRef.fromJson(Map<String, Object?> json) =>
      _$PokemonRefFromJson(json);
}
