import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/data/repositories/type/type_repository_remote.dart';
import 'package:vgc_daily_tracker/data/services/pokeapi/poke_api_exception.dart';
import 'package:vgc_daily_tracker/data/services/storage/local_storage_service.dart';
import 'package:vgc_daily_tracker/domain/models/type_chart.dart';
import 'package:vgc_daily_tracker/utils/result.dart';

import '../../../../testing/fakes/fake_poke_api_service.dart';
import '../../../../testing/fakes/fake_type_repository.dart';
import '../../../../testing/storage.dart';

void main() {
  late FakePokeApiService service;
  late LocalStorageService storage;

  setUp(() async {
    service = FakePokeApiService()..useTypeFixtures();
    storage = await memoryStorage();
  });

  TypeChart chartOf(Result<TypeChart> result) =>
      (result as Ok<TypeChart>).value;

  test('builds the chart from the 18 types', () async {
    final chart = chartOf(
      await TypeRepositoryRemote(service: service, storage: storage).chart(),
    );

    expect(chart.multiplier('fire', ['grass']), 2);
    expect(chart.multiplier('normal', ['ghost']), 0);
    expect(chart.multiplier('ground', ['fire', 'steel']), 4);
    expect(chart.multiplier('ground', ['flying', 'steel']), 0);
    expect(chart.multiplier('fairy', ['dragon', 'dark']), 4);
    expect(service.typeRequests, hasLength(18));
  });

  test(
    'a second call is served from memory, without storage or network',
    () async {
      final repository = TypeRepositoryRemote(
        service: service,
        storage: storage,
      );
      await repository.chart();
      await storage.delete('cache', 'type_chart');
      service.offline = true;

      final again = await repository.chart();

      expect(again, isA<Ok<TypeChart>>());
      expect(service.typeRequests, hasLength(18));
    },
  );

  test('kept on the device: works offline after one load', () async {
    await TypeRepositoryRemote(service: service, storage: storage).chart();
    service.offline = true;

    final restarted = TypeRepositoryRemote(service: service, storage: storage);
    final chart = chartOf(await restarted.chart());

    expect(chart.multiplier('water', ['fire']), 2);
  });

  test(
    'offline before it ever loaded: fails, rather than a partial chart',
    () async {
      service.offline = true;

      final result = await TypeRepositoryRemote(
        service: service,
        storage: storage,
      ).chart();

      expect(
        (result as Failure<TypeChart>).error,
        isA<PokeApiNetworkUnavailable>(),
      );
    },
  );

  test('one type missing fails the whole chart', () async {
    service.types.remove('fairy');

    final result = await TypeRepositoryRemote(
      service: service,
      storage: storage,
    ).chart();

    expect(result, isA<Failure<TypeChart>>());
  });

  test("the fake's chart is exactly what the real repository builds", () async {
    final real = chartOf(
      await TypeRepositoryRemote(service: service, storage: storage).chart(),
    );

    expect(FakeTypeRepository.realChart, real);
  });
}
