import '../../../domain/models/type_chart.dart';
import '../../../utils/result.dart';
import '../../services/pokeapi/models/type_api_model.dart';
import '../../services/pokeapi/poke_api_service.dart';
import '../../services/storage/local_storage_service.dart';
import 'type_repository.dart';

/// [TypeRepository] on PokéAPI. The chart barely ever changes, so once
/// built it's kept in memory and on the device: later launches, and
/// offline ones, don't fetch the 18 types again.
class TypeRepositoryRemote implements TypeRepository {
  TypeRepositoryRemote({required this._service, required this._storage});

  final PokeApiService _service;
  final LocalStorageService _storage;

  static const _cacheStore = 'cache';
  static const _chartKey = 'type_chart';

  TypeChart? _chart;

  @override
  Future<Result<TypeChart>> chart() async {
    if (_chart case final chart?) return Result.ok(chart);
    if (await _stored() case final stored?) return Result.ok(_chart = stored);

    final results = await Future.wait(TypeChart.types.map(_service.getType));
    final attacking = <String, Map<String, double>>{};
    for (final result in results) {
      switch (result) {
        case Ok(:final value):
          attacking[value.name] = _row(value.damageRelations);
        case Failure(:final error):
          // Never a partial chart: a missing row would read as ×1.
          return Result.failure(error);
      }
    }
    final chart = TypeChart(attacking);
    await _storage.put(_cacheStore, _chartKey, {'attacking': attacking});
    return Result.ok(_chart = chart);
  }

  static Map<String, double> _row(DamageRelationsApiModel hits) => {
    for (final t in hits.doubleDamageTo) t.name: 2,
    for (final t in hits.halfDamageTo) t.name: 0.5,
    for (final t in hits.noDamageTo) t.name: 0,
  };

  Future<TypeChart?> _stored() async {
    final stored = await _storage.get(_cacheStore, _chartKey);
    if (stored case Ok(value: final document?)) {
      final attacking = document['attacking']! as Map<String, Object?>;
      return TypeChart({
        for (final MapEntry(key: type, value: row) in attacking.entries)
          type: {
            for (final MapEntry(key: target, value: factor)
                in (row! as Map<String, Object?>).entries)
              target: (factor! as num).toDouble(),
          },
      });
    }
    return null;
  }
}
