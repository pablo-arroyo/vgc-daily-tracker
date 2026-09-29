import 'package:freezed_annotation/freezed_annotation.dart';

part 'pokemon.freezed.dart';

/// A Pokémon (or alternate form such as a Mega) as the app uses it.
@freezed
abstract class Pokemon with _$Pokemon {
  const factory Pokemon({
    required int id,

    /// PokéAPI identifier, e.g. `raichu-mega-y`.
    required String slug,

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
}
