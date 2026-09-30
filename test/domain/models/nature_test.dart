import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/domain/models/nature.dart';
import 'package:vgc_daily_tracker/domain/models/stat.dart';

void main() {
  test('there are 25 natures', () {
    expect(Nature.values, hasLength(25));
  });

  test('a nature raises one stat and lowers another', () {
    expect(Nature.adamant.raised, Stat.atk);
    expect(Nature.adamant.lowered, Stat.spa);
    expect(Nature.timid.raised, Stat.spe);
    expect(Nature.timid.lowered, Stat.atk);
    expect(Nature.careful.raised, Stat.spd);
    expect(Nature.careful.lowered, Stat.spa);
  });

  test('the 5 neutral natures change nothing', () {
    final neutral = Nature.values.where((n) => n.raised == null);

    expect(neutral, [
      Nature.hardy,
      Nature.docile,
      Nature.serious,
      Nature.bashful,
      Nature.quirky,
    ]);
    expect(neutral.every((n) => n.lowered == null), isTrue);
  });

  test('every other nature raises and lowers different stats, never HP', () {
    for (final nature in Nature.values.where((n) => n.raised != null)) {
      expect(nature.raised, isNot(nature.lowered), reason: nature.name);
      expect([nature.raised, nature.lowered], isNot(contains(Stat.hp)));
    }
  });

  test('byName finds a nature by its Showdown name, ignoring case', () {
    expect(Nature.byName('Jolly'), Nature.jolly);
    expect(Nature.byName('modest'), Nature.modest);
    expect(Nature.byName('Sassy '), Nature.sassy);
    expect(Nature.byName('Grumpy'), isNull);
  });

  test('label is the capitalized Showdown name', () {
    expect(Nature.adamant.label, 'Adamant');
  });
}
