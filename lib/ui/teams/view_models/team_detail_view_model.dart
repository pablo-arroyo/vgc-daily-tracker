import 'package:clock/clock.dart';
import 'package:flutter/foundation.dart';

import '../../../data/repositories/matchup/matchup_repository.dart';
import '../../../data/repositories/pokemon/pokemon_repository.dart';
import '../../../data/repositories/team/team_repository.dart';
import '../../../data/repositories/type/type_repository.dart';
import '../../../domain/models/matchup_note.dart';
import '../../../domain/models/pokemon.dart';
import '../../../domain/models/pokemon_ref.dart';
import '../../../domain/models/pokemon_set.dart';
import '../../../domain/models/stat_spread.dart';
import '../../../domain/models/team.dart';
import '../../../domain/stats/stat_calculator.dart';
import '../../../domain/stats/type_matchups.dart';
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

/// Matchup notes against one team on the other side: [title] reads
/// "your team vs their team"; [notes] is empty when none were saved.
typedef MatchupView = ({
  String teamId,
  String teamName,
  String title,
  String notes,
});

/// State for a team's detail screen: each member's battle form, stats, and
/// the team's Speed order.
class TeamDetailViewModel extends ChangeNotifier {
  TeamDetailViewModel({
    required this._teamRepository,
    required this._pokemonRepository,
    required this._matchupRepository,
    required this._typeRepository,
    required this._teamId,
  }) {
    load = Command0(_load)..addListener(notifyListeners);
    saveNotes = Command1(_saveNotes);
    saveMatchupNotes = Command1(_saveMatchupNotes);
  }

  final TeamRepository _teamRepository;
  final PokemonRepository _pokemonRepository;
  final MatchupRepository _matchupRepository;
  final TypeRepository _typeRepository;

  List<({String type, String label})> _weaknessRows = const [];
  bool _typesUnavailable = false;

  /// Attacking types that hit at least one member super-effectively, most
  /// weaknesses first: `Ground · 3 weak · 1 resists`.
  List<({String type, String label})> get weaknessRows => _weaknessRows;

  /// The type chart couldn't be loaded (e.g. offline), so no weaknesses.
  bool get typesUnavailable => _typesUnavailable;

  Future<void> _loadWeaknesses(List<TeamMemberView> members) async {
    switch (await _typeRepository.chart()) {
      case Ok(value: final chart):
        _typesUnavailable = false;
        _weaknessRows = [
          for (final c in teamWeaknesses(chart, [
            for (final m in members) m.types,
          ]))
            if (c.weak > 0)
              (
                type: c.type,
                label: [
                  _capitalized(c.type),
                  '${c.weak} weak',
                  if (c.resist > 0) '${c.resist} resists',
                  if (c.immune > 0) '${c.immune} immune',
                ].join(' · '),
              ),
        ];
      case Failure():
        _typesUnavailable = true;
        _weaknessRows = const [];
    }
  }

  static String _capitalized(String type) =>
      type[0].toUpperCase() + type.substring(1);
  final String _teamId;

  /// Loads the team and looks up each member. Run it again to retry.
  late final Command0<void> load;

  /// Saves the team's notes, trimmed.
  late final Command1<void, String> saveNotes;

  /// Saves the matchup notes against the other-side team [teamId], trimmed.
  late final Command1<void, ({String teamId, String notes})> saveMatchupNotes;

  List<MatchupView> _matchups = const [];

  /// Every team on the other side, in name order, with the matchup notes.
  List<MatchupView> get matchups => _matchups;

  /// Whose team this is, so the screen can say which side to add teams to.
  TeamSide get side => _team?.side ?? TeamSide.mine;

  Future<Result<void>> _saveMatchupNotes(
    ({String teamId, String notes}) request,
  ) async {
    final team = _team!;
    final mine = team.side == TeamSide.mine;
    final notes = request.notes.trim();
    final saved = await _matchupRepository.save(
      MatchupNote(
        myTeamId: mine ? team.id : request.teamId,
        opponentTeamId: mine ? request.teamId : team.id,
        notes: notes,
        updatedAt: clock.now().toUtc(),
      ),
    );
    if (saved is Ok) {
      _matchups = [
        for (final m in _matchups)
          m.teamId == request.teamId
              ? (
                  teamId: m.teamId,
                  teamName: m.teamName,
                  title: m.title,
                  notes: notes,
                )
              : m,
      ];
      notifyListeners();
    }
    return saved;
  }

  /// The other side's teams, each with the notes saved for its matchup
  /// with [team].
  Future<List<MatchupView>> _matchupsOf(Team team, List<Team> teams) async {
    final mine = team.side == TeamSide.mine;
    final notes = {
      for (final n in await _matchupRepository.watchAll().first) n.key: n.notes,
    };
    return [
      for (final other in teams)
        if (other.side != team.side)
          (
            teamId: other.id,
            teamName: other.name,
            title: mine
                ? '${team.name} vs ${other.name}'
                : '${other.name} vs ${team.name}',
            notes:
                notes[MatchupNote.keyOf(
                  mine ? team.id : other.id,
                  mine ? other.id : team.id,
                )] ??
                '',
          ),
    ];
  }

  Team? _team;

  /// The team's notes: scouting notes, or your own game plan.
  String get notes => _team?.notes ?? '';

  Future<Result<void>> _saveNotes(String notes) async {
    final updated = _team!.copyWith(notes: notes.trim());
    final saved = await _teamRepository.save(updated);
    if (saved is Ok) {
      _team = updated;
      notifyListeners();
    }
    return saved;
  }

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
    _team = team;
    _matchups = await _matchupsOf(team, teams);
    _name = team.name;
    _members = members;
    _speedOrder = _sortedBySpeed(members);
    await _loadWeaknesses(members);
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
