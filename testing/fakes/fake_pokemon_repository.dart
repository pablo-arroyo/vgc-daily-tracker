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

  /// When set, `search` and `getPokemon` fail with it (e.g. offline).
  Exception? failWith;

  List<PokemonRef> get _refs => [
    for (final p in _pokemon.values)
      PokemonRef(id: p.id, slug: p.slug, displayName: p.displayName),
  ];

  @override
  Future<Result<List<PokemonRef>>> search(String query) async {
    if (failWith case final error?) return Result.failure(error);
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
    if (failWith case final error?) return Result.failure(error);
    final pokemon = _pokemon[slug];
    return pokemon != null
        ? Result.ok(pokemon)
        : Result.failure(PokeApiNotFound(slug));
  }

  /// The [PokemonRef] of one of the [samplePokemon], by slug.
  static PokemonRef sampleRef(String slug) {
    final p = samplePokemon.singleWhere((p) => p.slug == slug);
    return PokemonRef(id: p.id, slug: p.slug, displayName: p.displayName);
  }

  /// Real PokéAPI data (fetched 2026-09-29): enough for a full team plus a
  /// Charizard / Charizard-Mega-Y pair for species-clause tests.
  static const samplePokemon = [
    Pokemon(
      id: 983,
      slug: 'kingambit',
      speciesSlug: 'kingambit',
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
      speciesSlug: 'raichu',
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
      speciesSlug: 'basculegion',
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
    Pokemon(
      id: 547,
      slug: 'whimsicott',
      speciesSlug: 'whimsicott',
      displayName: 'Whimsicott',
      types: ['grass', 'fairy'],
      baseStats: BaseStats(
        hp: 60,
        attack: 67,
        defense: 85,
        specialAttack: 77,
        specialDefense: 75,
        speed: 116,
      ),
      spriteUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/547.png',
    ),
    Pokemon(
      id: 445,
      slug: 'garchomp',
      speciesSlug: 'garchomp',
      displayName: 'Garchomp',
      types: ['dragon', 'ground'],
      baseStats: BaseStats(
        hp: 108,
        attack: 130,
        defense: 95,
        specialAttack: 80,
        specialDefense: 85,
        speed: 102,
      ),
      spriteUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/445.png',
    ),
    Pokemon(
      id: 727,
      slug: 'incineroar',
      speciesSlug: 'incineroar',
      displayName: 'Incineroar',
      types: ['fire', 'dark'],
      baseStats: BaseStats(
        hp: 95,
        attack: 115,
        defense: 90,
        specialAttack: 80,
        specialDefense: 90,
        speed: 60,
      ),
      spriteUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/727.png',
    ),
    Pokemon(
      id: 812,
      slug: 'rillaboom',
      speciesSlug: 'rillaboom',
      displayName: 'Rillaboom',
      types: ['grass'],
      baseStats: BaseStats(
        hp: 100,
        attack: 125,
        defense: 90,
        specialAttack: 60,
        specialDefense: 70,
        speed: 85,
      ),
      spriteUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/812.png',
    ),
    Pokemon(
      id: 6,
      slug: 'charizard',
      speciesSlug: 'charizard',
      displayName: 'Charizard',
      types: ['fire', 'flying'],
      baseStats: BaseStats(
        hp: 78,
        attack: 84,
        defense: 78,
        specialAttack: 109,
        specialDefense: 85,
        speed: 100,
      ),
      spriteUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/6.png',
    ),
    Pokemon(
      id: 10035,
      slug: 'charizard-mega-y',
      speciesSlug: 'charizard',
      displayName: 'Charizard-Mega-Y',
      types: ['fire', 'flying'],
      baseStats: BaseStats(
        hp: 78,
        attack: 104,
        defense: 78,
        specialAttack: 159,
        specialDefense: 115,
        speed: 100,
      ),
      spriteUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/10035.png',
    ),
  ];
}
