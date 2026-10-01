import '../models/pokemon.dart';
import '../models/pokemon_set.dart';
import '../models/stat.dart';
import '../models/stat_spread.dart';

/// [set]'s actual stats at its level, with the games' formula. Pass a
/// Mega's own [base] stats to get its stats after Mega Evolving.
StatSpread calculateStats(BaseStats base, PokemonSet set) {
  var stats = const StatSpread();
  for (final stat in Stat.values) {
    final scaled =
        (2 * base.of(stat) + set.ivs.of(stat) + set.evs.of(stat) ~/ 4) *
        set.level ~/
        100;
    stats = stats.withStat(
      stat,
      stat == Stat.hp
          ? scaled + set.level + 10
          : _withNature(scaled + 5, stat, set),
    );
  }
  return stats;
}

/// ±10 %, rounded down, in whole numbers so 1.1 never rounds wrong.
int _withNature(int value, Stat stat, PokemonSet set) {
  if (stat == set.nature.raised) return value * 11 ~/ 10;
  if (stat == set.nature.lowered) return value * 9 ~/ 10;
  return value;
}
