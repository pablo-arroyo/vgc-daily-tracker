import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/domain/models/pokemon.dart';
import 'package:vgc_daily_tracker/domain/models/stat_spread.dart';
import 'package:vgc_daily_tracker/domain/showdown/showdown_format.dart';
import 'package:vgc_daily_tracker/domain/stats/stat_calculator.dart';
import 'package:vgc_daily_tracker/utils/result.dart';

import '../../../testing/fixtures.dart';

/// PokéAPI base stats (checked 2026-09-30). Megas use the Mega's own.
const base = {
  'Kingambit': BaseStats(
    hp: 100,
    attack: 135,
    defense: 120,
    specialAttack: 60,
    specialDefense: 85,
    speed: 50,
  ),
  'Kleavor': BaseStats(
    hp: 70,
    attack: 135,
    defense: 95,
    specialAttack: 45,
    specialDefense: 70,
    speed: 85,
  ),
  'Metagross': BaseStats(
    // metagross-mega
    hp: 80,
    attack: 145,
    defense: 150,
    specialAttack: 105,
    specialDefense: 110,
    speed: 110,
  ),
  'Whimsicott': BaseStats(
    hp: 60,
    attack: 67,
    defense: 85,
    specialAttack: 77,
    specialDefense: 75,
    speed: 116,
  ),
  'Raichu': BaseStats(
    // raichu-mega-y
    hp: 60,
    attack: 100,
    defense: 55,
    specialAttack: 160,
    specialDefense: 80,
    speed: 130,
  ),
  'Basculegion': BaseStats(
    // basculegion-male
    hp: 120,
    attack: 112,
    defense: 65,
    specialAttack: 80,
    specialDefense: 75,
    speed: 78,
  ),
};

void main() {
  test("Team 1's sets give the Reg M-C artifact's level 50 numbers", () {
    final sets = switch (ShowdownFormat.parse(
      fixture('showdown/team1_metagross.txt'),
    )) {
      Ok(:final value) => {for (final set in value) set.species: set},
      Failure(:final error) => fail('$error'),
    };
    StatSpread stats(String species) =>
        calculateStats(base[species]!, sets[species]!);

    expect(stats('Kingambit').hp, 207);
    expect(stats('Kleavor').spe, 137);
    expect(stats('Metagross').spe, 178);
    expect(stats('Whimsicott').spe, 184);
    expect(stats('Raichu').spe, 200);
    expect(stats('Basculegion').spe, 130);
  });
}
