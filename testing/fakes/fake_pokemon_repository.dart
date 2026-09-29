import 'package:vgc_daily_tracker/data/repositories/pokemon/pokemon_names.dart';
import 'package:vgc_daily_tracker/data/repositories/pokemon/pokemon_repository.dart';
import 'package:vgc_daily_tracker/data/services/pokeapi/poke_api_exception.dart';
import 'package:vgc_daily_tracker/domain/models/pokemon.dart';
import 'package:vgc_daily_tracker/domain/models/pokemon_ref.dart';
import 'package:vgc_daily_tracker/utils/result.dart';

/// In-memory [PokemonRepository] for widget and integration tests. It holds
/// plain Dart data (no fixture files), so it also works inside the app on a
/// device. Names resolve with the real [PokemonNames] rules.
class FakePokemonRepository implements PokemonRepository {
  FakePokemonRepository({List<Pokemon>? pokemon})
    : _pokemon = {for (final p in pokemon ?? samplePokemon) p.slug: p};

  final Map<String, Pokemon> _pokemon;

  List<PokemonRef> get _refs => [
    for (final p in _pokemon.values)
      PokemonRef(id: p.id, slug: p.slug, displayName: p.displayName),
  ];

  @override
  Future<Result<List<PokemonRef>>> search(String query) async {
    final needle = PokemonNames.normalize(query);
    if (needle.isEmpty) return const Result.ok([]);
    return Result.ok([
      ..._refs.where((r) => r.slug.startsWith(needle)),
      ..._refs.where(
        (r) => !r.slug.startsWith(needle) && r.slug.contains(needle),
      ),
    ]);
  }

  @override
  Future<Result<PokemonRef>> resolve(String name) async {
    final match = PokemonNames.resolve(_refs, name);
    return match != null
        ? Result.ok(match)
        : Result.failure(PokeApiNotFound(name));
  }

  @override
  Future<Result<Pokemon>> getPokemon(String slug) async {
    final pokemon = _pokemon[slug];
    return pokemon != null
        ? Result.ok(pokemon)
        : Result.failure(PokeApiNotFound(slug));
  }

  /// Real base stats (same as the recorded PokéAPI fixtures).
  static const samplePokemon = [
    Pokemon(
      id: 983,
      slug: 'kingambit',
      displayName: 'Kingambit',
      types: ['dark', 'steel'],
      baseStats: BaseStats(
        hp: 100,
        attack: 135,
        defense: 120,
        specialAttack: 60,
        specialDefense: 85,
        speed: 50,
      ),
      spriteUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/983.png',
    ),
    Pokemon(
      id: 10305,
      slug: 'raichu-mega-y',
      displayName: 'Raichu-Mega-Y',
      types: ['electric'],
      baseStats: BaseStats(
        hp: 60,
        attack: 100,
        defense: 55,
        specialAttack: 160,
        specialDefense: 80,
        speed: 130,
      ),
      spriteUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/10305.png',
    ),
    Pokemon(
      id: 902,
      slug: 'basculegion-male',
      displayName: 'Basculegion-Male',
      types: ['water', 'ghost'],
      baseStats: BaseStats(
        hp: 120,
        attack: 112,
        defense: 65,
        specialAttack: 80,
        specialDefense: 75,
        speed: 78,
      ),
      spriteUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/902.png',
    ),
  ];
}
