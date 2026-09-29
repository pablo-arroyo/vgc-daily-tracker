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

  const PokemonRef._();

  factory PokemonRef.fromJson(Map<String, Object?> json) =>
      _$PokemonRefFromJson(json);

  /// PokéAPI serves every sprite at this URL pattern, so lists can show
  /// sprites without fetching each Pokémon's details.
  String get spriteUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';
}
