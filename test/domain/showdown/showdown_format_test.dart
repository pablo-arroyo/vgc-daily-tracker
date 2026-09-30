import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/domain/models/nature.dart';
import 'package:vgc_daily_tracker/domain/models/pokemon_set.dart';
import 'package:vgc_daily_tracker/domain/models/stat_spread.dart';
import 'package:vgc_daily_tracker/domain/showdown/showdown_format.dart';
import 'package:vgc_daily_tracker/utils/result.dart';

List<PokemonSet> parsed(String paste) => switch (ShowdownFormat.parse(paste)) {
  Ok(:final value) => value,
  Failure(:final error) => fail('$error'),
};

PokemonSet single(String paste) => parsed(paste).single;

List<ShowdownIssue> issues(String paste) =>
    switch (ShowdownFormat.parse(paste)) {
      Ok() => fail('expected the paste to be rejected'),
      Failure(:final error) => (error as ShowdownParseException).issues,
    };

void main() {
  group('parse: the first line', () {
    test('species alone', () {
      expect(single('Pikachu\n- Thunderbolt').species, 'Pikachu');
    });

    test('species and item', () {
      final set = single('Kleavor @ Focus Sash\n- Stone Axe');

      expect(set.species, 'Kleavor');
      expect(set.item, 'Focus Sash');
      expect(set.nickname, isNull);
    });

    test('a nickname puts the species in brackets', () {
      final set = single('Big Steel (Metagross) @ Metagrossite\n- Iron Head');

      expect(set.nickname, 'Big Steel');
      expect(set.species, 'Metagross');
      expect(set.item, 'Metagrossite');
    });

    test('gender, with and without a nickname', () {
      final plain = single('Basculegion (F) @ Life Orb\n- Wave Crash');
      final nicknamed = single('Fishy (Basculegion) (M)\n- Wave Crash');

      expect(plain.species, 'Basculegion');
      expect(plain.gender, 'F');
      expect(plain.nickname, isNull);
      expect(nicknamed.nickname, 'Fishy');
      expect(nicknamed.species, 'Basculegion');
      expect(nicknamed.gender, 'M');
      expect(nicknamed.item, isNull);
    });
  });

  group('parse: the other lines', () {
    test('missing lines take Showdown VGC defaults', () {
      final set = single('Pikachu\n- Thunderbolt');

      expect(set.level, 50);
      expect(set.evs, const StatSpread());
      expect(set.ivs, StatSpread.perfectIvs);
      expect(set.nature, Nature.serious);
      expect(set.ability, isNull);
      expect(set.megaAbility, isNull);
    });

    test('IVs replace only the stats they list', () {
      final set = single('Pikachu\nIVs: 0 Atk / 30 Spe\n- Thunderbolt');

      expect(set.ivs, StatSpread.perfectIvs.copyWith(atk: 0, spe: 30));
    });

    test('the mega ability arrow can also be typed as ->', () {
      final set = single('Charizard\nAbility: Blaze -> Drought\n- Heat Wave');

      expect(set.ability, 'Blaze');
      expect(set.megaAbility, 'Drought');
    });

    test('stat names and natures ignore case and extra spaces', () {
      final set = single(
        'Pikachu\nEVs:  252 spa /4 HP\n  timid   Nature\n- Thunderbolt',
      );

      expect(set.evs, const StatSpread(hp: 4, spa: 252));
      expect(set.nature, Nature.timid);
    });

    test('Showdown extras this app does not use are skipped', () {
      final set = single(
        'Pikachu\nShiny: Yes\nTera Type: Electric\nHappiness: 0\n'
        '- Thunderbolt',
      );

      expect(set.moves, ['Thunderbolt']);
    });
  });

  group('parse: layout', () {
    test('any number of blank lines separate sets, CRLF included', () {
      final sets = parsed(
        '\n\nPikachu\r\n- Thunderbolt\r\n\r\n\r\n   \nRaichu\n- Fake Out\n\n',
      );

      expect(sets.map((s) => s.species), ['Pikachu', 'Raichu']);
    });

    test('an empty paste is an error', () {
      expect(issues('  \n\n'), [
        const ShowdownIssue(line: 1, message: 'No Pokémon found'),
      ]);
    });
  });

  group('parse: errors carry their line number', () {
    test('more than 510 EVs in total', () {
      expect(
        issues('Pikachu\nEVs: 252 HP / 252 Atk / 8 Spe\n- Thunderbolt\n'),
        [const ShowdownIssue(line: 2, message: 'EVs add up to 512 (max 510)')],
      );
    });

    test('more than 252 EVs on one stat', () {
      expect(issues('Pikachu\nEVs: 253 Spe\n- Thunderbolt'), [
        const ShowdownIssue(line: 2, message: '253 Spe EVs (max 252)'),
      ]);
    });

    test('an unknown nature', () {
      expect(issues('Pikachu\nGrumpy Nature\n- Thunderbolt'), [
        const ShowdownIssue(line: 2, message: 'Unknown nature "Grumpy"'),
      ]);
    });

    test('more than 4 moves, reported on the 5th', () {
      expect(issues('Pikachu\n- A\n- B\n- C\n- D\n- E'), [
        const ShowdownIssue(line: 6, message: 'More than 4 moves'),
      ]);
    });

    test('an unknown stat or a bad number', () {
      expect(issues('Pikachu\nEVs: 252 Luck / lots Spe\n- Thunderbolt'), [
        const ShowdownIssue(line: 2, message: 'Unreadable stat "252 Luck"'),
        const ShowdownIssue(line: 2, message: 'Unreadable stat "lots Spe"'),
      ]);
    });

    test('IVs over 31 and a level outside 1-100', () {
      expect(issues('Pikachu\nLevel: 101\nIVs: 32 Spe\n- Thunderbolt'), [
        const ShowdownIssue(line: 2, message: 'Level 101 (must be 1-100)'),
        const ShowdownIssue(line: 3, message: '32 Spe IVs (max 31)'),
      ]);
    });

    test('a line the parser does not recognise', () {
      expect(issues('Pikachu\nHolding hands\n- Thunderbolt'), [
        const ShowdownIssue(
          line: 2,
          message: 'Unrecognised line "Holding hands"',
        ),
      ]);
    });

    test('errors from every set are reported together', () {
      expect(issues('Pikachu\nGrumpy Nature\n\nRaichu\nEVs: 300 Spe'), [
        const ShowdownIssue(line: 2, message: 'Unknown nature "Grumpy"'),
        const ShowdownIssue(line: 5, message: '300 Spe EVs (max 252)'),
      ]);
    });

    test('the exception message lists them', () {
      final failure = ShowdownFormat.parse('Pikachu\nGrumpy Nature') as Failure;

      expect('${failure.error}', 'Line 2: Unknown nature "Grumpy"');
    });
  });

  group('export', () {
    test('writes nickname, gender and item on the first line', () {
      const set = PokemonSet(
        nickname: 'Fishy',
        species: 'Basculegion',
        gender: 'M',
        item: 'Life Orb',
        moves: ['Wave Crash'],
      );

      expect(
        ShowdownFormat.export([set]),
        'Fishy (Basculegion) (M) @ Life Orb\n'
        'Level: 50\n'
        'Serious Nature\n'
        '- Wave Crash\n',
      );
    });

    test('lists only non-zero EVs and IVs below 31', () {
      final set = PokemonSet(
        species: 'Pikachu',
        ability: 'Static',
        evs: const StatSpread(spa: 252, hp: 4),
        ivs: StatSpread.perfectIvs.copyWith(atk: 0),
        nature: Nature.modest,
        moves: const ['Thunderbolt'],
      );

      expect(
        ShowdownFormat.export([set]),
        'Pikachu\n'
        'Ability: Static\n'
        'Level: 50\n'
        'EVs: 4 HP / 252 SpA\n'
        'Modest Nature\n'
        'IVs: 0 Atk\n'
        '- Thunderbolt\n',
      );
    });

    test('a parsed paste with every field survives a round trip', () {
      const paste =
          'Big Steel (Metagross) (F) @ Metagrossite\n'
          'Ability: Clear Body → Tough Claws\n'
          'Level: 42\n'
          'EVs: 4 HP / 252 Atk / 252 Spe\n'
          'Jolly Nature\n'
          'IVs: 0 SpA\n'
          '- Protect\n'
          '- Iron Head\n';

      expect(ShowdownFormat.export(parsed(paste)), paste);
      expect(parsed(ShowdownFormat.export(parsed(paste))), parsed(paste));
    });
  });
}
