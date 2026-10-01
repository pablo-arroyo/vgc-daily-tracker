import 'dart:async';
import 'dart:convert';

import 'package:vgc_daily_tracker/data/services/pokeapi/models/item_api_model.dart';
import 'package:vgc_daily_tracker/data/services/pokeapi/models/pokemon_detail_api_model.dart';
import 'package:vgc_daily_tracker/data/services/pokeapi/models/pokemon_list_api_model.dart';
import 'package:vgc_daily_tracker/data/services/pokeapi/poke_api_exception.dart';
import 'package:vgc_daily_tracker/data/services/pokeapi/poke_api_service.dart';
import 'package:vgc_daily_tracker/utils/result.dart';

import '../fixtures.dart';

/// In-memory [PokeApiService]: serves recorded fixtures, records every call,
/// and can pretend the network is down.
class FakePokeApiService implements PokeApiService {
  /// Pokémon available from `getPokemon`, keyed by slug.
  final details = <String, PokemonDetailApiModel>{};

  /// Slugs passed to `getPokemon`, in call order.
  final detailRequests = <String>[];

  /// Items available from `getItem`, keyed by slug.
  final items = <String, ItemApiModel>{};

  /// Slugs passed to `getItem`, in call order.
  final itemRequests = <String>[];

  /// The name index served by `getPokemonList`.
  PokemonListApiModel? index;

  /// How many times `getPokemonList` was called.
  int indexRequests = 0;

  /// When set, `getPokemonList` waits for it, so a test can overlap calls.
  Completer<void>? indexGate;

  /// When true, every call fails with [PokeApiNetworkUnavailable].
  bool offline = false;

  /// Serves the real, full recorded index (1,351 entries).
  void useFullIndexFixture() {
    index = PokemonListApiModel.fromJson(
      jsonDecode(fixture('pokeapi/pokemon_list_full.json'))
          as Map<String, Object?>,
    );
  }

  /// Adds `testing/fixtures/pokeapi/pokemon_<slug>.json` to [details].
  void addDetailFixture(String slug) {
    details[slug] = PokemonDetailApiModel.fromJson(
      jsonDecode(fixture('pokeapi/pokemon_$slug.json')) as Map<String, Object?>,
    );
  }

  @override
  Future<Result<PokemonDetailApiModel>> getPokemon(String slug) async {
    detailRequests.add(slug);
    if (offline) return Result.failure(PokeApiNetworkUnavailable(slug));
    final detail = details[slug];
    return detail == null
        ? Result.failure(PokeApiNotFound(slug))
        : Result.ok(detail);
  }

  @override
  Future<Result<ItemApiModel>> getItem(String slug) async {
    itemRequests.add(slug);
    if (offline) return Result.failure(PokeApiNetworkUnavailable(slug));
    final item = items[slug];
    return item == null
        ? Result.failure(PokeApiNotFound(slug))
        : Result.ok(item);
  }

  @override
  Future<Result<PokemonListApiModel>> getPokemonList({
    required int limit,
  }) async {
    indexRequests++;
    await indexGate?.future;
    if (offline) {
      return const Result.failure(PokeApiNetworkUnavailable('/pokemon'));
    }
    return Result.ok(index!);
  }
}
