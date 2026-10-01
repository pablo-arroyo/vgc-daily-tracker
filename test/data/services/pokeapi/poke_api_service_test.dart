import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:vgc_daily_tracker/data/services/pokeapi/models/item_api_model.dart';
import 'package:vgc_daily_tracker/data/services/pokeapi/models/pokemon_detail_api_model.dart';
import 'package:vgc_daily_tracker/data/services/pokeapi/models/pokemon_list_api_model.dart';
import 'package:vgc_daily_tracker/data/services/pokeapi/poke_api_exception.dart';
import 'package:vgc_daily_tracker/data/services/pokeapi/poke_api_service.dart';
import 'package:vgc_daily_tracker/utils/result.dart';

import '../../../../testing/fixtures.dart';

void main() {
  final requested = <Uri>[];

  /// A client that serves recorded fixtures by path, and 404s otherwise.
  http.Client fixtureClient() => MockClient((request) async {
    requested.add(request.url);
    // /api/v2/<resource>/<slug> → fixtures/pokeapi/<resource>_<slug>.json
    final [_, _, resource, slug, ...] = request.url.pathSegments;
    try {
      return http.Response(fixture('pokeapi/${resource}_$slug.json'), 200);
    } on Exception {
      return http.Response('{"status":404,"message":"Not Found"}', 404);
    }
  });

  setUp(requested.clear);

  group('getPokemonList', () {
    test('fetches /pokemon?limit=N and parses the name index', () async {
      final service = PokeApiService(
        client: MockClient((request) async {
          requested.add(request.url);
          return http.Response(
            fixture('pokeapi/pokemon_list_limit_3.json'),
            200,
          );
        }),
      );

      final result = await service.getPokemonList(limit: 3);

      expect(
        requested.single.toString(),
        'https://pokeapi.co/api/v2/pokemon?limit=3',
      );
      final list = (result as Ok<PokemonListApiModel>).value;
      expect(list.count, 1351);
      expect(list.results.map((r) => r.name), [
        'bulbasaur',
        'ivysaur',
        'venusaur',
      ]);
      expect(list.results.first.url, 'https://pokeapi.co/api/v2/pokemon/1/');
    });
  });

  group('getPokemon', () {
    final cases = {
      'kingambit': (
        id: 983,
        species: 'kingambit',
        types: ['dark', 'steel'],
        speed: 50,
        ability: 'defiant',
      ),
      'raichu-mega-y': (
        id: 10305,
        species: 'raichu',
        types: ['electric'],
        speed: 130,
        ability: 'no-guard',
      ),
      'basculegion-male': (
        id: 902,
        species: 'basculegion',
        types: ['water', 'ghost'],
        speed: 78,
        ability: 'swift-swim',
      ),
    };

    for (final MapEntry(key: slug, value: expected) in cases.entries) {
      test('fetches /pokemon/$slug and parses the recorded response', () async {
        final service = PokeApiService(client: fixtureClient());

        final result = await service.getPokemon(slug);

        expect(
          requested.single.toString(),
          'https://pokeapi.co/api/v2/pokemon/$slug',
        );
        final pokemon = (result as Ok<PokemonDetailApiModel>).value;
        expect(pokemon.id, expected.id);
        expect(pokemon.name, slug);
        expect(pokemon.species.name, expected.species);
        expect(pokemon.types.map((t) => t.type.name), expected.types);
        expect(
          pokemon.stats.singleWhere((s) => s.stat.name == 'speed').baseStat,
          expected.speed,
        );
        expect(pokemon.abilities.first.ability.name, expected.ability);
        expect(pokemon.abilities.last.isHidden, slug != 'raichu-mega-y');
        expect(pokemon.sprites.frontDefault, endsWith('/${expected.id}.png'));
        expect(
          pokemon.sprites.other?.officialArtwork?.frontDefault,
          endsWith('/official-artwork/${expected.id}.png'),
        );
      });
    }
  });

  group('getItem', () {
    test('fetches /item/{slug} and parses the recorded response', () async {
      final service = PokeApiService(client: fixtureClient());

      final result = await service.getItem('metagrossite');

      expect(
        requested.single.toString(),
        'https://pokeapi.co/api/v2/item/metagrossite',
      );
      final item = (result as Ok<ItemApiModel>).value;
      expect(item.id, 799);
      expect(item.name, 'metagrossite');
    });

    test('an unknown item is a Failure with PokeApiNotFound', () async {
      final service = PokeApiService(client: fixtureClient());

      final result = await service.getItem('metagrosite');

      expect((result as Failure).error, isA<PokeApiNotFound>());
    });
  });

  group('errors', () {
    test('an unknown slug (404) is a Failure with PokeApiNotFound', () async {
      final service = PokeApiService(client: fixtureClient());

      final result = await service.getPokemon('missingno');

      expect(
        (result as Failure<PokemonDetailApiModel>).error,
        isA<PokeApiNotFound>(),
      );
    });

    test('a server error (500) is a Failure with PokeApiBadResponse', () async {
      final service = PokeApiService(
        client: MockClient(
          (_) async => http.Response('{"detail":"Server Error"}', 500),
        ),
      );

      final result = await service.getPokemon('kingambit');

      final error = (result as Failure<PokemonDetailApiModel>).error;
      expect(error, isA<PokeApiBadResponse>());
      expect((error as PokeApiBadResponse).statusCode, 500);
    });

    final malformedBodies = {
      'not JSON': '<html>Bad Gateway</html>',
      'the wrong JSON shape': '{"id": 983, "name": "kingambit"}',
      'a JSON list': '[]',
    };
    for (final MapEntry(key: label, value: body) in malformedBodies.entries) {
      test('a 200 with $label is a Failure with PokeApiBadResponse', () async {
        final service = PokeApiService(
          client: MockClient((_) async => http.Response(body, 200)),
        );

        final result = await service.getPokemon('kingambit');

        final error = (result as Failure<PokemonDetailApiModel>).error;
        expect(error, isA<PokeApiBadResponse>());
        expect((error as PokeApiBadResponse).statusCode, 200);
      });
    }

    test('no connection is a Failure with PokeApiNetworkUnavailable', () async {
      final service = PokeApiService(
        client: MockClient(
          (_) async => throw http.ClientException('Failed host lookup'),
        ),
      );

      final result = await service.getPokemon('kingambit');

      expect(
        (result as Failure<PokemonDetailApiModel>).error,
        isA<PokeApiNetworkUnavailable>(),
      );
    });

    test('a server that never answers times out as '
        'PokeApiNetworkUnavailable', () async {
      final service = PokeApiService(
        client: MockClient((_) => Completer<http.Response>().future),
        timeout: const Duration(milliseconds: 50),
      );

      final result = await service.getPokemon('kingambit');

      expect(
        (result as Failure<PokemonDetailApiModel>).error,
        isA<PokeApiNetworkUnavailable>(),
      );
    });
  });
}
