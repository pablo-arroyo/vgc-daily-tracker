import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/domain/models/nature.dart';
import 'package:vgc_daily_tracker/domain/models/pokemon.dart';
import 'package:vgc_daily_tracker/domain/models/pokemon_set.dart';
import 'package:vgc_daily_tracker/domain/models/stat_spread.dart';
import 'package:vgc_daily_tracker/domain/stats/speed_order.dart';

BaseStats speed(int value) => BaseStats(
  hp: 80,
  attack: 80,
  defense: 80,
  specialAttack: 80,
  specialDefense: 80,
  speed: value,
);

/// 252 Speed EVs; [nature] decides the 10 %.
PokemonSet fast({Nature nature = Nature.jolly, String? item}) => PokemonSet(
  species: 'X',
  evs: const StatSpread(spe: 252),
  nature: nature,
  item: item,
);

SpeedInput mine(String name, int base, PokemonSet? set) =>
    (side: SpeedSide.mine, name: name, base: speed(base), set: set);
SpeedInput theirs(String name, int base, [PokemonSet? set]) =>
    (side: SpeedSide.theirs, name: name, base: speed(base), set: set);

String row(SpeedEntry e) =>
    '${e.name} ${e.min == e.max ? '${e.min}' : '${e.min}–${e.max}'}'
    '${e.tie ? ' tie' : ''}';

void main() {
  test("a known set's exact Speed: Mega Metagross is 178", () {
    final [entry] = speedOrder([mine('Metagross-Mega', 110, fast())]);

    expect((entry.min, entry.max), (178, 178));
  });

  test('Choice Scarf ×1.5, Iron Ball and Macho Brace ×½, rounded down', () {
    // Base 85, 252 EVs, neutral: 137 (Kleavor).
    const neutral = Nature.adamant;
    final order = speedOrder([
      mine('Scarf', 85, fast(nature: neutral, item: 'choice scarf')),
      mine('Ball', 85, fast(nature: neutral, item: 'Iron Ball')),
      mine('Brace', 85, fast(nature: neutral, item: 'Macho Brace')),
      mine('None', 85, fast(nature: neutral, item: 'Life Orb')),
    ]);

    expect(order.map(row), [
      'Scarf 205',
      'None 137',
      'Ball 68 tie',
      'Brace 68 tie',
    ]);
  });

  test('without a set: 0 EVs neutral up to 252 EVs with +Speed', () {
    final [entry] = speedOrder([theirs('Sneasler', 120)]);

    expect((entry.min, entry.max), (140, 189));
  });

  test('normal order: fastest first by the top of each range; equal exact '
      'speeds are ties, kept in input order', () {
    final order = speedOrder([
      mine('A', 85, fast(nature: Nature.adamant)), // 137
      theirs('Sneasler', 120), // 140–189
      mine('B', 85, fast(nature: Nature.adamant)), // 137
    ]);

    expect(order.map(row), ['Sneasler 140–189', 'A 137 tie', 'B 137 tie']);
  });

  test('Tailwind doubles one side only', () {
    final inputs = [
      mine('Kleavor', 85, fast(nature: Nature.adamant)), // 137
      theirs('Sneasler', 120), // 140–189
    ];

    expect(speedOrder(inputs, mode: SpeedMode.tailwindMine).map(row), [
      'Kleavor 274',
      'Sneasler 140–189',
    ]);
    expect(speedOrder(inputs, mode: SpeedMode.tailwindTheirs).map(row), [
      'Sneasler 280–378',
      'Kleavor 137',
    ]);
  });

  test('Trick Room: slowest first, by the bottom of each range', () {
    final order = speedOrder([
      mine('Kleavor', 85, fast(nature: Nature.adamant)), // 137
      theirs('Rillaboom', 85), // 105–150
      mine('Kingambit', 50, null), // 70–? range
    ], mode: SpeedMode.trickRoom);

    expect(order.map((e) => e.name), ['Kingambit', 'Rillaboom', 'Kleavor']);
  });
}
