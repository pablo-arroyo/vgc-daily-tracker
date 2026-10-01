import 'package:freezed_annotation/freezed_annotation.dart';

part 'type_chart.freezed.dart';

/// How much each attacking type hits each defending type for.
@freezed
abstract class TypeChart with _$TypeChart {
  /// [attacking] maps an attacking type to the defending types it doesn't
  /// hit for ×1, e.g. `{'fire': {'grass': 2, 'water': 0.5}}`.
  const factory TypeChart(Map<String, Map<String, double>> attacking) =
      _TypeChart;

  const TypeChart._();

  /// The 18 battle types, in the games' order.
  static const types = [
    'normal',
    'fighting',
    'flying',
    'poison',
    'ground',
    'rock',
    'bug',
    'ghost',
    'steel',
    'fire',
    'water',
    'grass',
    'electric',
    'psychic',
    'ice',
    'dragon',
    'dark',
    'fairy',
  ];

  /// [attackingType] against a Pokémon of [defendingTypes] (one or two):
  /// the multipliers combine, so ×4, ×¼ and ×0 all happen.
  double multiplier(String attackingType, List<String> defendingTypes) {
    final row = attacking[attackingType] ?? const {};
    return defendingTypes.fold(1, (total, type) => total * (row[type] ?? 1));
  }
}
