import 'package:freezed_annotation/freezed_annotation.dart';

import 'nature.dart';
import 'stat_spread.dart';

part 'pokemon_set.freezed.dart';

/// One Pokémon's full build, as a Showdown paste describes it. Names are
/// kept as written; mapping them to PokéAPI happens in the data layer.
@freezed
abstract class PokemonSet with _$PokemonSet {
  const factory PokemonSet({
    required String species,
    String? nickname,

    /// `M` or `F`, when the paste gives one.
    String? gender,
    String? item,
    String? ability,

    /// The ability after Mega Evolving, from the artifact's `A → B`.
    String? megaAbility,

    /// VGC plays at level 50, so that's the default.
    @Default(50) int level,
    @Default(StatSpread()) StatSpread evs,
    @Default(StatSpread.perfectIvs) StatSpread ivs,

    /// Showdown's choice when a paste names no nature.
    @Default(Nature.serious) Nature nature,
    @Default([]) List<String> moves,
  }) = _PokemonSet;
}
