import 'package:flutter/foundation.dart';

import '../../../data/repositories/pokemon/pokemon_repository.dart';
import '../../../data/repositories/team/team_repository.dart';
import '../../../domain/models/pokemon.dart';
import '../../../domain/models/pokemon_ref.dart';
import '../../../domain/models/pokemon_set.dart';
import '../../../domain/models/stat_spread.dart';
import '../../../domain/stats/stat_calculator.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';

/// One team member as the detail screen shows it.
@immutable
class TeamMemberView {
  const TeamMemberView({
    required this.name,
    required this.spriteUrl,
    required this.types,
    this.set,
    this.stats,
    this.ability,
  });

  /// The battle form's name: `Metagross-Mega` when holding Metagrossite.
  final String name;
  final String spriteUrl;
  final List<String> types;

  /// The imported build, or null for a team built by picking Pokémon.
  final PokemonSet? set;

  /// Actual stats in battle (the Mega's, for a Mega), when there's a set.
  final StatSpread? stats;

  /// `Lightning Rod → No Guard`: the ability, then the Mega's if given.
  final String? ability;
}

/// One line of the Speed order list.
typedef SpeedTier = ({String name, int speed});

/// State for a team's detail screen: each member's battle form, stats, and
/// the team's Speed order.
class TeamDetailViewModel extends ChangeNotifier {
  TeamDetailViewModel({
    required this._teamRepository,
    required this._pokemonRepository,
    required this._teamId,
  }) {
    load = Command0(_load)..addListener(notifyListeners);
  }

  final TeamRepository _teamRepository;
  final PokemonRepository _pokemonRepository;
  final String _teamId;

  /// Loads the team and looks up each member. Run it again to retry.
  late final Command0<void> load;

  String _name = '';
  bool _missing = false;
  List<TeamMemberView> _members = const [];
  List<SpeedTier> _speedOrder = const [];

  String get name => _name;

  /// True when the team no longer exists (e.g. deleted elsewhere).
  bool get missing => _missing;

  List<TeamMemberView> get members => _members;

  /// Whether the team was imported with full sets.
  bool get hasSets => _members.any((m) => m.set != null);

  /// Fastest first; equal speeds keep team order.
  List<SpeedTier> get speedOrder => _speedOrder;

  Future<Result<void>> _load() async {
    final teams = await _teamRepository.watchAll().first;
    final team = teams.where((t) => t.id == _teamId).firstOrNull;
    if (team == null) {
      _missing = true;
      return const Result.ok(null);
    }

    final members = <TeamMemberView>[];
    for (final (i, ref) in team.pokemon.indexed) {
      final set = i < team.sets.length ? team.sets[i] : null;
      switch (await _battleForm(ref, set)) {
        case Ok(value: final pokemon):
          members.add(
            TeamMemberView(
              name: pokemon.displayName,
              spriteUrl: pokemon.spriteUrl,
              types: pokemon.types,
              set: set,
              stats: set == null
                  ? null
                  : calculateStats(pokemon.baseStats, set),
              ability: switch (set) {
                PokemonSet(:final ability?, :final megaAbility?) =>
                  '$ability → $megaAbility',
                PokemonSet(:final ability) => ability,
                null => null,
              },
            ),
          );
        case Failure(:final error):
          return Result.failure(error);
      }
    }
    _name = team.name;
    _members = members;
    _speedOrder = _sortedBySpeed(members);
    return const Result.ok(null);
  }

  /// The Pokémon as it battles: its Mega when [set] holds the stone.
  Future<Result<Pokemon>> _battleForm(PokemonRef ref, PokemonSet? set) async {
    final form = await _pokemonRepository.resolve(ref.slug, item: set?.item);
    return switch (form) {
      Ok(:final value) => _pokemonRepository.getPokemon(value.slug),
      Failure(:final error) => Result.failure(error),
    };
  }

  static List<SpeedTier> _sortedBySpeed(List<TeamMemberView> members) {
    final tiers = [
      for (final (i, member) in members.indexed)
        if (member.stats case final stats?)
          (index: i, name: member.name, speed: stats.spe),
    ];
    // Explicit tie-break: List.sort isn't guaranteed to be stable.
    tiers.sort(
      (a, b) => a.speed != b.speed
          ? b.speed.compareTo(a.speed)
          : a.index.compareTo(b.index),
    );
    return [for (final t in tiers) (name: t.name, speed: t.speed)];
  }
}
