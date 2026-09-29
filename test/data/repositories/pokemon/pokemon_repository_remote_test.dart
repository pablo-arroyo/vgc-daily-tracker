import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/data/repositories/pokemon/pokemon_repository_remote.dart';
import 'package:vgc_daily_tracker/data/services/pokeapi/poke_api_exception.dart';
import 'package:vgc_daily_tracker/domain/models/pokemon.dart';
import 'package:vgc_daily_tracker/domain/models/pokemon_ref.dart';
import 'package:vgc_daily_tracker/utils/result.dart';

import '../../../../testing/fakes/fake_poke_api_service.dart';
import '../../../../testing/storage.dart';

void main() {
  late FakePokeApiService service;
  late PokemonRepositoryRemote repository;

  setUp(() async {
    service = FakePokeApiService();
    repository = PokemonRepositoryRemote(
      service: service,
      storage: await memoryStorage(),
    );
  });

  group('getPokemon', () {
    test('maps the API model into a domain Pokemon', () async {
      service.addDetailFixture('kingambit');

      final result = await repository.getPokemon('kingambit');

      expect(
        (result as Ok<Pokemon>).value,
        const Pokemon(
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
      );
    });

    test('names alternate forms Showdown-style', () async {
      service.addDetailFixture('raichu-mega-y');

      final result = await repository.getPokemon('raichu-mega-y');

      expect((result as Ok<Pokemon>).value.displayName, 'Raichu-Mega-Y');
    });

    test('serves a second lookup from the cache', () async {
      service.addDetailFixture('kingambit');

      await repository.getPokemon('kingambit');
      final second = await repository.getPokemon('kingambit');

      expect(second, isA<Ok<Pokemon>>());
      expect(service.detailRequests, ['kingambit']);
    });

    test('passes a service failure through and retries next time', () async {
      final first = await repository.getPokemon('kingambit');
      service.addDetailFixture('kingambit');
      final second = await repository.getPokemon('kingambit');

      expect((first as Failure<Pokemon>).error, isA<PokeApiNotFound>());
      expect(second, isA<Ok<Pokemon>>());
    });
  });

  group('search', () {
    setUp(() => service.useFullIndexFixture());

    test('ranks prefix matches before substring matches, each in '
        'PokéAPI order', () async {
      final result = await repository.search('king');

      expect((result as Ok<List<PokemonRef>>).value.map((r) => r.slug), [
        'kingler',
        'kingdra',
        'kingambit',
        'kingler-gmax',
        'nidoking',
        'seaking',
        'slowking',
        'slaking',
        'walking-wake',
        'slowking-galar',
      ]);
    });

    test('fetches the index once for repeated searches', () async {
      await repository.search('k');
      await repository.search('ki');
      await repository.search('kin');

      expect(service.indexRequests, 1);
    });

    test('concurrent searches share one in-flight index request', () async {
      service.indexGate = Completer<void>();

      final searches = [
        repository.search('k'),
        repository.search('ki'),
        repository.search('kin'),
      ];
      service.indexGate!.complete();
      final results = await Future.wait(searches);

      expect(service.indexRequests, 1);
      expect(results, everyElement(isA<Ok<List<PokemonRef>>>()));
    });

    test('refetches the index once it is older than 24 hours', () async {
      final loadedAt = DateTime(2026, 9, 29, 12);

      await withClock(Clock.fixed(loadedAt), () => repository.search('k'));
      await withClock(
        Clock.fixed(loadedAt.add(const Duration(hours: 23, minutes: 59))),
        () => repository.search('k'),
      );
      expect(service.indexRequests, 1, reason: 'still fresh');

      await withClock(
        Clock.fixed(loadedAt.add(const Duration(hours: 24, seconds: 1))),
        () => repository.search('k'),
      );
      expect(service.indexRequests, 2, reason: 'expired');
    });

    test('falls back to the expired index when offline', () async {
      final loadedAt = DateTime(2026, 9, 29, 12);
      await withClock(Clock.fixed(loadedAt), () => repository.search('k'));

      service.offline = true;
      final result = await withClock(
        Clock.fixed(loadedAt.add(const Duration(days: 3))),
        () => repository.search('kingam'),
      );

      expect(service.indexRequests, 2, reason: 'it did try to refresh');
      expect((result as Ok<List<PokemonRef>>).value.map((r) => r.slug), [
        'kingambit',
      ]);
    });

    test('fails when offline and no index was ever loaded', () async {
      service.offline = true;

      final result = await repository.search('k');

      expect(
        (result as Failure<List<PokemonRef>>).error,
        isA<PokeApiNetworkUnavailable>(),
      );
    });

    test('normalizes the query the way people type names', () async {
      Future<List<String>> slugs(String query) async =>
          ((await repository.search(query)) as Ok<List<PokemonRef>>).value
              .map((r) => r.slug)
              .toList();

      expect(await slugs('Mr. M'), ['mr-mime', 'mr-mime-galar']);
      expect((await slugs('TAPU K')).first, 'tapu-koko');
      expect(await slugs('  '), isEmpty);
    });
  });

  group('resolve', () {
    setUp(() => service.useFullIndexFixture());

    Future<String> slugOf(String name) async =>
        ((await repository.resolve(name)) as Ok<PokemonRef>).value.slug;

    test('matches exact names and slugs, ignoring case', () async {
      expect(await slugOf('Kingambit'), 'kingambit');
      expect(await slugOf('Raichu-Mega-Y'), 'raichu-mega-y');
      expect(await slugOf('raichu-mega-y'), 'raichu-mega-y');
    });

    test('picks the default form when the species has no bare slug, and '
        'expands Showdown suffixes', () async {
      final cases = {
        // Default form = the lowest-id entry starting with "<name>-".
        'Basculegion': 'basculegion-male',
        'Urshifu': 'urshifu-single-strike',
        'Lycanroc': 'lycanroc-midday',
        // Showdown abbreviations of the same thing.
        'Basculegion-F': 'basculegion-female',
        'Indeedee-F': 'indeedee-female',
        'Indeedee-M': 'indeedee-male',
        'Ogerpon-Wellspring': 'ogerpon-wellspring-mask',
      };
      for (final MapEntry(key: name, value: slug) in cases.entries) {
        expect(await slugOf(name), slug, reason: name);
      }
    });

    test('handles punctuation, accents and gender symbols in names', () async {
      final cases = {
        'Mr. Mime': 'mr-mime',
        'Farfetch’d-Galar': 'farfetchd-galar',
        "Farfetch'd": 'farfetchd',
        'Type: Null': 'type-null',
        'Flabébé': 'flabebe',
        'Tapu Koko': 'tapu-koko',
        'Nidoran♀': 'nidoran-f',
        'Nidoran♂': 'nidoran-m',
        // Real slugs that end in -f / -m must not be "expanded".
        'Nidoran-F': 'nidoran-f',
        'Nidoran-M': 'nidoran-m',
      };
      for (final MapEntry(key: name, value: slug) in cases.entries) {
        final result = await repository.resolve(name);
        expect(result, isA<Ok<PokemonRef>>(), reason: name);
        expect((result as Ok<PokemonRef>).value.slug, slug, reason: name);
      }
    });

    test('fails on unknown or partial names instead of guessing', () async {
      for (final name in ['Missingno', 'Char', 'Kingamb']) {
        final result = await repository.resolve(name);
        expect(
          (result as Failure<PokemonRef>).error,
          isA<PokeApiNotFound>(),
          reason: name,
        );
      }
    });

    test('fails when offline and no index was ever loaded', () async {
      service.offline = true;

      final result = await repository.resolve('Kingambit');

      expect(
        (result as Failure<PokemonRef>).error,
        isA<PokeApiNetworkUnavailable>(),
      );
    });
  });

  group('persisted index', () {
    test('a new repository instance (an app restart) reuses the stored '
        'index without a network call', () async {
      final storage = await memoryStorage();
      service.useFullIndexFixture();
      final firstLaunch = PokemonRepositoryRemote(
        service: service,
        storage: storage,
      );
      await firstLaunch.search('king');

      final secondLaunch = PokemonRepositoryRemote(
        service: service,
        storage: storage,
      );
      final result = await secondLaunch.search('kingam');

      expect(service.indexRequests, 1, reason: 'only the first launch');
      expect((result as Ok<List<PokemonRef>>).value.map((r) => r.slug), [
        'kingambit',
      ]);
    });

    test(
      'after a restart, an expired stored index still works offline',
      () async {
        final storage = await memoryStorage();
        service.useFullIndexFixture();
        final loadedAt = DateTime(2026, 9, 29, 12);
        await withClock(
          Clock.fixed(loadedAt),
          () => PokemonRepositoryRemote(
            service: service,
            storage: storage,
          ).search('king'),
        );

        service.offline = true;
        final result = await withClock(
          Clock.fixed(loadedAt.add(const Duration(days: 5))),
          () => PokemonRepositoryRemote(
            service: service,
            storage: storage,
          ).search('kingam'),
        );

        expect(service.indexRequests, 2, reason: 'it did try to refresh');
        expect((result as Ok<List<PokemonRef>>).value.map((r) => r.slug), [
          'kingambit',
        ]);
      },
    );
  });
}
