import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/domain/models/nature.dart';
import 'package:vgc_daily_tracker/domain/models/pokemon_set.dart';
import 'package:vgc_daily_tracker/domain/models/stat_spread.dart';
import 'package:vgc_daily_tracker/domain/showdown/showdown_format.dart';
import 'package:vgc_daily_tracker/utils/result.dart';

import '../../../testing/fixtures.dart';

/// The Reg M-C artifact's three pastes, saved verbatim.
const teams = [
  'showdown/team1_metagross.txt',
  'showdown/team2_grassy.txt',
  'showdown/team3_big_six.txt',
];

List<PokemonSet> parsed(String paste) => switch (ShowdownFormat.parse(paste)) {
  Ok(:final value) => value,
  Failure(:final error) => fail('$error'),
};

void main() {
  for (final team in teams) {
    test('$team parses into 6 sets and exports back to the same paste', () {
      final paste = fixture(team);

      final sets = parsed(paste);

      expect(sets, hasLength(6));
      expect(sets.every((set) => set.moves.length == 4), isTrue);
      expect(ShowdownFormat.export(sets), paste);
    });
  }

  test('Team 1 Metagross reads every field', () {
    final metagross = parsed(fixture(teams[0]))[2];

    expect(
      metagross,
      const PokemonSet(
        species: 'Metagross',
        item: 'Metagrossite',
        ability: 'Clear Body',
        level: 50,
        evs: StatSpread(hp: 4, atk: 252, spe: 252),
        nature: Nature.jolly,
        moves: ['Protect', 'Iron Head', 'Psychic Fangs', 'Ice Punch'],
      ),
    );
  });

  test("Team 2 Salamence keeps the artifact's mega ability notation", () {
    final salamence = parsed(fixture(teams[1]))[4];

    expect(salamence.ability, 'Intimidate');
    expect(salamence.megaAbility, 'Aerilate');
  });
}
