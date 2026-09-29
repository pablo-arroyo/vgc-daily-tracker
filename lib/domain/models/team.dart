import 'package:freezed_annotation/freezed_annotation.dart';

import 'pokemon_ref.dart';

part 'team.freezed.dart';
part 'team.g.dart';

/// One of the player's saved teams.
@freezed
abstract class Team with _$Team {
  const factory Team({
    required String id,
    required String name,
    required List<PokemonRef> pokemon,
  }) = _Team;

  factory Team.fromJson(Map<String, Object?> json) => _$TeamFromJson(json);
}
