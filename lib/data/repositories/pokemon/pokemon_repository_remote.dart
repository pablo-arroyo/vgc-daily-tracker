import 'package:clock/clock.dart';

import '../../../domain/models/pokemon.dart';
import '../../../domain/models/pokemon_ref.dart';
import '../../../utils/result.dart';
import '../../services/pokeapi/models/named_api_resource.dart';
import '../../services/pokeapi/models/pokemon_detail_api_model.dart';
import '../../services/pokeapi/poke_api_exception.dart';
import '../../services/pokeapi/poke_api_service.dart';
import '../../services/storage/local_storage_service.dart';
import 'pokemon_names.dart';
import 'pokemon_repository.dart';

/// [PokemonRepository] backed by PokéAPI, with caching:
/// - the name index is fetched once and kept for 24 hours (PokéAPI sends
///   `Cache-Control: max-age=86400`), in memory and in local storage so it
///   survives app restarts; concurrent callers share one request, and an
///   expired index is still served when the network is down;
/// - details are cached in memory per slug for the app session.
class PokemonRepositoryRemote implements PokemonRepository {
  PokemonRepositoryRemote({required this._service, required this._storage});

  final PokeApiService _service;
  final LocalStorageService _storage;

  static const _cacheStore = 'cache';
  static const _indexKey = 'pokemon_index';

  static const _indexMaxAge = Duration(hours: 24);

  /// Large enough for the whole index in one request (1,351 entries today).
  static const _indexLimit = 100000;

  List<PokemonRef>? _index;
  DateTime? _indexLoadedAt;
  Future<Result<List<PokemonRef>>>? _indexRequest;

  /// Successful lookups only, so a failed one is retried next time.
  final _details = <String, Pokemon>{};

  @override
  Future<Result<List<PokemonRef>>> search(String query) async {
    final needle = PokemonNames.normalize(query);
    if (needle.isEmpty) return const Result.ok([]);
    final index = await _loadIndex();
    switch (index) {
      case Ok(value: final refs):
        return Result.ok([
          ...refs.where((r) => r.slug.startsWith(needle)),
          ...refs.where(
            (r) => !r.slug.startsWith(needle) && r.slug.contains(needle),
          ),
        ]);
      case Failure(:final error):
        return Result.failure(error);
    }
  }

  @override
  Future<Result<PokemonRef>> resolve(String name, {String? item}) async {
    final index = await _loadIndex();
    switch (index) {
      case Ok(value: final refs):
        final match = PokemonNames.resolve(refs, name, item: item);
        return match != null
            ? Result.ok(match)
            : Result.failure(PokeApiNotFound(name));
      case Failure(:final error):
        return Result.failure(error);
    }
  }

  @override
  Future<Result<Pokemon>> getPokemon(String slug) async {
    final cached = _details[slug];
    if (cached != null) return Result.ok(cached);

    final result = await _service.getPokemon(slug);
    switch (result) {
      case Ok(:final value):
        return Result.ok(_details[slug] = _toDomain(value));
      case Failure(:final error):
        return Result.failure(error);
    }
  }

  bool get _indexIsFresh =>
      _index != null && clock.now().difference(_indexLoadedAt!) <= _indexMaxAge;

  Future<Result<List<PokemonRef>>> _loadIndex() async {
    if (_index == null) await _restoreIndex();
    if (_indexIsFresh) return Result.ok(_index!);
    // Autocomplete fires on each keystroke: share the request in flight.
    return _indexRequest ??= _fetchIndex().whenComplete(
      () => _indexRequest = null,
    );
  }

  Future<Result<List<PokemonRef>>> _fetchIndex() async {
    final result = await _service.getPokemonList(limit: _indexLimit);
    switch (result) {
      case Ok(:final value):
        _indexLoadedAt = clock.now();
        _index = value.results.map(_toRef).toList();
        await _persistIndex();
        return Result.ok(_index!);
      case Failure(:final error):
        // Offline with an expired index: a day-old list beats no list.
        final stale = _index;
        return stale != null ? Result.ok(stale) : Result.failure(error);
    }
  }

  /// Loads the index saved by an earlier app session, fresh or not: an
  /// expired one still serves as the offline fallback.
  Future<void> _restoreIndex() async {
    final stored = await _storage.get(_cacheStore, _indexKey);
    if (stored case Ok(value: final document?)) {
      _indexLoadedAt = DateTime.parse(document['loaded_at']! as String);
      _index = [
        for (final entry in document['entries']! as List<Object?>)
          PokemonRef.fromJson(entry! as Map<String, Object?>),
      ];
    }
  }

  Future<void> _persistIndex() => _storage.put(_cacheStore, _indexKey, {
    'loaded_at': _indexLoadedAt!.toIso8601String(),
    'entries': [for (final ref in _index!) ref.toJson()],
  });

  static PokemonRef _toRef(NamedApiResource entry) => PokemonRef(
    // Entry URLs end in the id: https://pokeapi.co/api/v2/pokemon/983/
    id: int.parse(
      Uri.parse(entry.url).pathSegments.lastWhere((s) => s.isNotEmpty),
    ),
    slug: entry.name,
    displayName: PokemonNames.displayName(entry.name),
  );

  static Pokemon _toDomain(PokemonDetailApiModel api) {
    int stat(String name) =>
        api.stats.singleWhere((s) => s.stat.name == name).baseStat;
    return Pokemon(
      id: api.id,
      slug: api.name,
      speciesSlug: api.species.name,
      displayName: PokemonNames.displayName(api.name),
      types: [for (final slot in api.types) slot.type.name],
      baseStats: BaseStats(
        hp: stat('hp'),
        attack: stat('attack'),
        defense: stat('defense'),
        specialAttack: stat('special-attack'),
        specialDefense: stat('special-defense'),
        speed: stat('speed'),
      ),
      spriteUrl: api.sprites.frontDefault,
    );
  }
}
