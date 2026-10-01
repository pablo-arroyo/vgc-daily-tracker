import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/domain/models/stat.dart';
import 'package:vgc_daily_tracker/domain/models/stat_spread.dart';

void main() {
  test('stats default to 0 and total adds them up', () {
    const spread = StatSpread(hp: 4, atk: 252, spe: 252);

    expect(spread.def, 0);
    expect(spread.total, 508);
  });

  test('perfectIvs is 31 everywhere', () {
    expect(Stat.values.map(StatSpread.perfectIvs.of), everyElement(31));
  });

  test('of and withStat read and replace one stat', () {
    const spread = StatSpread(spa: 252);

    expect(spread.of(Stat.spa), 252);
    expect(spread.withStat(Stat.spd, 4), const StatSpread(spa: 252, spd: 4));
  });

  test('Stat full names are for screen readers', () {
    expect(Stat.values.map((s) => s.fullName), [
      'HP',
      'Attack',
      'Defense',
      'Special Attack',
      'Special Defense',
      'Speed',
    ]);
  });

  test('Stat labels are the Showdown ones', () {
    expect(Stat.values.map((s) => s.label), [
      'HP',
      'Atk',
      'Def',
      'SpA',
      'SpD',
      'Spe',
    ]);
  });
}
