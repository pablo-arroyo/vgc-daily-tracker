import 'package:freezed_annotation/freezed_annotation.dart';

import 'pokemon_ref.dart';
import 'pokemon_set.dart';

part 'team.freezed.dart';
part 'team.g.dart';

/// Whose team it is: the player's own, or one they play against.
enum TeamSide { mine, opponent }

/// A saved team: one of the player's, or an opponent's (see [side]).
@freezed
abstract class Team with _$Team {
  const factory Team({
    required String id,
    required String name,
    required List<PokemonRef> pokemon,

    /// Full builds from a Showdown import, one per [pokemon] in the same
    /// order, or empty for a team built by picking Pokémon.
    @Default([]) List<PokemonSet> sets,

    /// Teams saved before sides existed are the player's own.
    @Default(TeamSide.mine) TeamSide side,
  }) = _Team;

  factory Team.fromJson(Map<String, Object?> json) => _$TeamFromJson(json);
}
