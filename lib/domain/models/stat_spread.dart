import 'package:freezed_annotation/freezed_annotation.dart';

import 'stat.dart';

part 'stat_spread.freezed.dart';

/// A value per stat, used for EVs and IVs.
@freezed
abstract class StatSpread with _$StatSpread {
  const factory StatSpread({
    @Default(0) int hp,
    @Default(0) int atk,
    @Default(0) int def,
    @Default(0) int spa,
    @Default(0) int spd,
    @Default(0) int spe,
  }) = _StatSpread;

  const StatSpread._();

  /// IVs when a paste doesn't list any.
  static const perfectIvs = StatSpread(
    hp: 31,
    atk: 31,
    def: 31,
    spa: 31,
    spd: 31,
    spe: 31,
  );

  int of(Stat stat) => switch (stat) {
    Stat.hp => hp,
    Stat.atk => atk,
    Stat.def => def,
    Stat.spa => spa,
    Stat.spd => spd,
    Stat.spe => spe,
  };

  StatSpread withStat(Stat stat, int value) => switch (stat) {
    Stat.hp => copyWith(hp: value),
    Stat.atk => copyWith(atk: value),
    Stat.def => copyWith(def: value),
    Stat.spa => copyWith(spa: value),
    Stat.spd => copyWith(spd: value),
    Stat.spe => copyWith(spe: value),
  };

  int get total => hp + atk + def + spa + spd + spe;
}
