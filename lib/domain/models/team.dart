import 'package:freezed_annotation/freezed_annotation.dart';

import 'pokemon_ref.dart';
import 'pokemon_set.dart';

part 'team.freezed.dart';
part 'team.g.dart';

/// One of the player's saved teams.
@freezed
abstract class Team with _$Team {
  const factory Team({
    required String id,
    required String name,
    required List<PokemonRef> pokemon,

    /// Full builds from a Showdown import, one per [pokemon] in the same
    /// order, or empty for a team built by picking Pokémon.
    @Default([]) List<PokemonSet> sets,
  }) = _Team;

  factory Team.fromJson(Map<String, Object?> json) => _$TeamFromJson(json);
}
