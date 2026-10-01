import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/domain/models/nature.dart';
import 'package:vgc_daily_tracker/domain/models/pokemon_set.dart';
import 'package:vgc_daily_tracker/domain/models/stat_spread.dart';

void main() {
  const metagross = PokemonSet(
    species: 'Metagross',
    nickname: 'Big Steel',
    gender: 'F',
    item: 'Metagrossite',
    ability: 'Clear Body',
    megaAbility: 'Tough Claws',
    evs: StatSpread(hp: 4, atk: 252, spe: 252),
    ivs: StatSpread(hp: 31, atk: 31, def: 31, spa: 0, spd: 31, spe: 31),
    nature: Nature.jolly,
    moves: ['Protect', 'Iron Head'],
  );
  const json = {
    'species': 'Metagross',
    'nickname': 'Big Steel',
    'gender': 'F',
    'item': 'Metagrossite',
    'ability': 'Clear Body',
    'mega_ability': 'Tough Claws',
    'level': 50,
    'evs': {'hp': 4, 'atk': 252, 'def': 0, 'spa': 0, 'spd': 0, 'spe': 252},
    'ivs': {'hp': 31, 'atk': 31, 'def': 31, 'spa': 0, 'spd': 31, 'spe': 31},
    'nature': 'jolly',
    'moves': ['Protect', 'Iron Head'],
  };

  test('serializes to plain JSON storage can hold', () {
    expect(metagross.toJson(), json);
  });

  test('round-trips through JSON', () {
    expect(PokemonSet.fromJson(json), metagross);
  });
}
