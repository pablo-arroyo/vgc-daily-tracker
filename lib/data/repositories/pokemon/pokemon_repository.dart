import '../../../domain/models/pokemon.dart';
import '../../../domain/models/pokemon_ref.dart';
import '../../../utils/result.dart';

/// Source of truth for Pokémon data.
abstract class PokemonRepository {
  /// Autocomplete: names starting with [query] first, then names containing
  /// it, each group in PokéAPI order. A blank query returns nothing.
  Future<Result<List<PokemonRef>>> search(String query);

  /// Maps a typed or Showdown-style name to its entry, e.g. `Basculegion-F`
  /// → `basculegion-female`. Fails with `PokeApiNotFound` rather than
  /// guessing from a partial name.
  Future<Result<PokemonRef>> resolve(String name);

  /// Full details (types, base stats, sprite) for [slug].
  Future<Result<Pokemon>> getPokemon(String slug);
}
