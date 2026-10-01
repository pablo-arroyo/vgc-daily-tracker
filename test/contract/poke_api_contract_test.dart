/// Contract tests: the live PokéAPI still returns what our API models parse.
/// The slugs match the recorded fixtures in `testing/fixtures/pokeapi/`, so
/// a failure here means the fixtures (and the models) need updating.
///
/// Skipped by default. Run with:
///   flutter test --tags network --run-skipped
@Tags(['network'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:vgc_daily_tracker/data/services/pokeapi/models/item_api_model.dart';
import 'package:vgc_daily_tracker/data/services/pokeapi/models/pokemon_detail_api_model.dart';
import 'package:vgc_daily_tracker/data/services/pokeapi/models/pokemon_list_api_model.dart';
import 'package:vgc_daily_tracker/data/services/pokeapi/models/type_api_model.dart';
import 'package:vgc_daily_tracker/data/services/pokeapi/poke_api_service.dart';
import 'package:vgc_daily_tracker/utils/result.dart';

void main() {
  late http.Client client;
  late PokeApiService service;

  setUp(() {
    client = http.Client();
    service = PokeApiService(client: client);
  });
  tearDown(() => client.close());

  for (final slug in ['kingambit', 'raichu-mega-y', 'basculegion-male']) {
    test('live /pokemon/$slug parses', () async {
      final result = await service.getPokemon(slug);

      expect(result, isA<Ok<PokemonDetailApiModel>>(), reason: '$result');
      final pokemon = (result as Ok<PokemonDetailApiModel>).value;
      expect(pokemon.name, slug);
      expect(pokemon.stats, hasLength(6));
    });
  }

  test('live /item/metagrossite parses', () async {
    final result = await service.getItem('metagrossite');

    expect(result, isA<Ok<ItemApiModel>>(), reason: '$result');
    expect((result as Ok<ItemApiModel>).value.name, 'metagrossite');
  });

  test('live /type/ghost parses', () async {
    final result = await service.getType('ghost');

    expect(result, isA<Ok<TypeApiModel>>(), reason: '$result');
    final hits = (result as Ok<TypeApiModel>).value.damageRelations;
    expect(hits.noDamageTo.map((t) => t.name), ['normal']);
  });

  test('live /pokemon?limit=N parses the name index', () async {
    final result = await service.getPokemonList(limit: 3);

    expect(result, isA<Ok<PokemonListApiModel>>(), reason: '$result');
    expect((result as Ok<PokemonListApiModel>).value.results, hasLength(3));
  });
}
