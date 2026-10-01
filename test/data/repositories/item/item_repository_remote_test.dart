import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/data/repositories/item/item_repository_remote.dart';
import 'package:vgc_daily_tracker/data/services/pokeapi/models/item_api_model.dart';
import 'package:vgc_daily_tracker/data/services/pokeapi/poke_api_exception.dart';
import 'package:vgc_daily_tracker/domain/models/item.dart';
import 'package:vgc_daily_tracker/utils/result.dart';

import '../../../../testing/fakes/fake_poke_api_service.dart';

void main() {
  late FakePokeApiService service;
  late ItemRepositoryRemote repository;

  setUp(() {
    service = FakePokeApiService()
      ..items['raichunite-y'] = const ItemApiModel(
        id: 2601,
        name: 'raichunite-y',
      )
      ..items['kings-rock'] = const ItemApiModel(id: 221, name: 'kings-rock');
    repository = ItemRepositoryRemote(service: service);
  });

  test('resolves a Showdown item name to its PokéAPI item', () async {
    final result = await repository.resolve('Raichunite Y');

    expect(
      (result as Ok<Item>).value,
      const Item(id: 2601, slug: 'raichunite-y'),
    );
    expect(service.itemRequests, ['raichunite-y']);
  });

  test('normalizes punctuation the way Pokémon names are', () async {
    final result = await repository.resolve("King's Rock");

    expect((result as Ok<Item>).value.slug, 'kings-rock');
  });

  test('serves a second lookup from the cache', () async {
    await repository.resolve('Raichunite Y');
    await repository.resolve('raichunite-y');

    expect(service.itemRequests, hasLength(1));
  });

  test('an unknown item fails with PokeApiNotFound', () async {
    final result = await repository.resolve('Metagrosite');

    expect((result as Failure<Item>).error, isA<PokeApiNotFound>());
  });

  test('offline fails with PokeApiNetworkUnavailable and retries later',
      () async {
    service.offline = true;
    final offline = await repository.resolve('Raichunite Y');
    service.offline = false;
    final online = await repository.resolve('Raichunite Y');

    expect(
      (offline as Failure<Item>).error,
      isA<PokeApiNetworkUnavailable>(),
    );
    expect(online, isA<Ok<Item>>());
  });
}
