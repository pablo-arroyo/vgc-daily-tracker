import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/domain/stats/type_matchups.dart';

import '../../../testing/fakes/fake_type_repository.dart';

void main() {
  const chart = FakeTypeRepository.realChart;

  // The Reg M-C artifact's Team 1, in battle form.
  const team1 = [
    (name: 'Kingambit', types: ['dark', 'steel']),
    (name: 'Kleavor', types: ['bug', 'rock']),
    (name: 'Metagross-Mega', types: ['steel', 'psychic']),
    (name: 'Whimsicott', types: ['grass', 'fairy']),
    (name: 'Raichu-Mega-Y', types: ['electric']),
    (name: 'Basculegion-Male', types: ['water', 'ghost']),
  ];

  group('teamWeaknesses', () {
    final coverage = {
      for (final c in teamWeaknesses(chart, [for (final m in team1) m.types]))
        c.type: c,
    };

    test('counts who is weak, who resists and who is immune', () {
      expect(coverage['fire'], (type: 'fire', weak: 3, resist: 1, immune: 0));
      expect(coverage['ground'], (
        type: 'ground',
        weak: 3,
        resist: 1,
        immune: 0,
      ));
      // Normal can't touch Basculegion (Ghost).
      expect(coverage['normal']!.immune, 1);
      // Fighting hits Kingambit (Dark/Steel) ×4: still one weak member.
      expect(coverage['fighting']!.weak, 1);
    });

    test('most weaknesses first; ties keep the games’ type order', () {
      final order = teamWeaknesses(chart, [
        for (final m in team1) m.types,
      ]).map((c) => c.type);

      expect(order.take(2), ['ground', 'fire']);
      expect(order, hasLength(18));
    });
  });

  group('threats', () {
    test("their types against yours: each type's super-effective hits, "
        'strongest first', () {
      final rows = threats(chart, ['fighting', 'poison', 'grass'], team1);

      // Records compare lists by identity, so compare a readable form.
      expect(
        [
          for (final r in rows)
            '${r.type}: ${[for (final h in r.hits) '${h.name} ×${h.multiplier}'].join(', ')}',
        ],
        [
          'fighting: Kingambit ×4.0',
          'poison: Whimsicott ×4.0',
          'grass: Basculegion-Male ×2.0',
        ],
      );
    });

    test('types that hit nobody super-effectively are left out', () {
      expect(threats(chart, ['normal'], team1), isEmpty);
    });
  });
}
