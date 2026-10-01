import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/domain/models/nature.dart';
import 'package:vgc_daily_tracker/domain/models/pokemon.dart';
import 'package:vgc_daily_tracker/domain/models/pokemon_set.dart';
import 'package:vgc_daily_tracker/domain/models/stat.dart';
import 'package:vgc_daily_tracker/domain/models/stat_spread.dart';
import 'package:vgc_daily_tracker/domain/stats/stat_calculator.dart';

/// Base 100 everywhere keeps the arithmetic easy to follow:
/// 2 × 100 + 31 IVs = 231 before EVs.
const flat = BaseStats(
  hp: 100,
  attack: 100,
  defense: 100,
  specialAttack: 100,
  specialDefense: 100,
  speed: 100,
);

StatSpread statsOf(PokemonSet set, [BaseStats base = flat]) =>
    calculateStats(base, set);

void main() {
  test('BaseStats.of reads each stat', () {
    const base = BaseStats(
      hp: 1,
      attack: 2,
      defense: 3,
      specialAttack: 4,
      specialDefense: 5,
      speed: 6,
    );

    expect(Stat.values.map(base.of), [1, 2, 3, 4, 5, 6]);
  });

  test('0 EVs at level 50: HP adds level + 10, others add 5', () {
    // 231 × 50 / 100 = 115.5, rounded down to 115.
    final stats = statsOf(const PokemonSet(species: 'X'));

    expect(stats.hp, 115 + 60);
    expect(stats.atk, 115 + 5);
    expect(stats.spe, 120);
  });

  test('252 EVs add 63 points before scaling', () {
    final stats = statsOf(
      const PokemonSet(species: 'X', evs: StatSpread(hp: 252, spe: 252)),
    );

    // (231 + 63) × 50 / 100 = 147.
    expect(stats.hp, 147 + 60);
    expect(stats.spe, 147 + 5);
  });

  test('only every 4th EV counts', () {
    final stats = statsOf(
      const PokemonSet(species: 'X', evs: StatSpread(atk: 3, def: 4, spe: 7)),
    );

    expect(stats.atk, 120);
    // (231 + 1) × 50 / 100 = 116.
    expect(stats.def, 121);
    expect(stats.spe, 121);
  });

  test('IVs below 31 lower the stat', () {
    final stats = statsOf(
      PokemonSet(species: 'X', ivs: StatSpread.perfectIvs.copyWith(spe: 0)),
    );

    // 200 × 50 / 100 = 100.
    expect(stats.spe, 105);
  });

  test('the nature adds or removes 10 %, rounded down', () {
    final stats = statsOf(
      const PokemonSet(
        species: 'X',
        nature: Nature.jolly, // +Spe, -SpA
        evs: StatSpread(spa: 252, spe: 252, atk: 4),
      ),
    );

    expect(stats.spe, 167); // 152 × 1.1 = 167.2
    expect(stats.spa, 136); // 152 × 0.9 = 136.8
    expect(stats.atk, 121); // 4 EVs = +1, and no nature change
  });

  test('the level comes from the set', () {
    final stats = statsOf(const PokemonSet(species: 'X', level: 100));

    expect(stats.hp, 231 + 110);
    expect(stats.spe, 231 + 5);
  });
}
