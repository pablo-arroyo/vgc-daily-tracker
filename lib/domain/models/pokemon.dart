import 'package:freezed_annotation/freezed_annotation.dart';

import 'stat.dart';

part 'pokemon.freezed.dart';

/// A Pokémon (or alternate form such as a Mega) as the app uses it.
@freezed
abstract class Pokemon with _$Pokemon {
  const factory Pokemon({
    required int id,

    /// PokéAPI identifier, e.g. `raichu-mega-y`.
    required String slug,

    /// The species it belongs to, e.g. `raichu` for `raichu-mega-y`. Two
    /// forms of one species can't share a team (the VGC species clause).
    required String speciesSlug,

    /// Human-readable name, e.g. `Raichu-Mega-Y`.
    required String displayName,

    /// Type names in slot order, e.g. `['dark', 'steel']`.
    required List<String> types,
    required BaseStats baseStats,
    required String spriteUrl,
  }) = _Pokemon;
}

@freezed
abstract class BaseStats with _$BaseStats {
  const factory BaseStats({
    required int hp,
    required int attack,
    required int defense,
    required int specialAttack,
    required int specialDefense,
    required int speed,
  }) = _BaseStats;

  const BaseStats._();

  int of(Stat stat) => switch (stat) {
    Stat.hp => hp,
    Stat.atk => attack,
    Stat.def => defense,
    Stat.spa => specialAttack,
    Stat.spd => specialDefense,
    Stat.spe => speed,
  };
}
