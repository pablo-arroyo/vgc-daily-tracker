import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/foundation.dart';

import '../../../data/repositories/game_log/game_log_repository.dart';
import '../../../data/repositories/matchup/matchup_repository.dart';
import '../../../data/repositories/pokemon/pokemon_repository.dart';
import '../../../data/repositories/team/team_repository.dart';
import '../../../domain/models/game_log.dart';
import '../../../domain/models/matchup_note.dart';
import '../../../domain/models/mistake_category.dart';
import '../../../domain/models/pokemon_ref.dart';
import '../../../domain/models/team.dart';
import '../../../utils/command.dart';
import '../../../utils/id_generator.dart';
import '../../../utils/iso_date.dart';
import '../../../utils/result.dart';

/// Why a game can't be logged yet, in the original tracker's words.
class LogGameValidationError implements Exception {
  const LogGameValidationError(this.message);

  final String message;
}

/// State for the Log Game tab: the rules for logging one game.
class LogGameViewModel extends ChangeNotifier {
  LogGameViewModel({
    required this._gameLogRepository,
    required this._teamRepository,
    required this._pokemonRepository,
    required this._matchupRepository,
    required this._idGenerator,
    DateTime Function(DateTime utc)? toLocal,
  }) : _toLocal = toLocal ?? ((utc) => utc.toLocal()) {
    save = Command0(_save);
    addLastGameToNotes = Command0(_addLastGameToNotes);
    saveMatchupNotes = Command1(_saveMatchupNotes);
    // Watched, so plans edited elsewhere show up while logging.
    _matchupsSubscription = _matchupRepository.watchAll().listen((notes) {
      _matchupNotes = {for (final n in notes) n.key: n.notes};
      notifyListeners();
    });
    _teamsSubscription = _teamRepository.watchAll().listen((teams) {
      // Only the player's own teams can be "your team used".
      _teams = [
        for (final team in teams)
          if (team.side == TeamSide.mine) team,
      ];
      _opponentTeams = [
        for (final team in teams)
          if (team.side == TeamSide.opponent) team,
      ];
      notifyListeners();
    });
  }

  late final StreamSubscription<List<Team>> _teamsSubscription;
  late final StreamSubscription<List<MatchupNote>> _matchupsSubscription;
  final MatchupRepository _matchupRepository;
  Map<String, String> _matchupNotes = const {};

  /// Saves the plan for the picked pair of teams, trimmed.
  late final Command1<void, String> saveMatchupNotes;

  /// The game plan card shows once their team is picked.
  bool get showGamePlan => _selectedOpponentTeam != null;

  /// The picked opponent team as currently saved (its notes may have been
  /// edited since it was picked).
  Team? get _currentOpponentTeam {
    final picked = _selectedOpponentTeam;
    if (picked == null) return null;
    return _opponentTeams.where((t) => t.id == picked.id).firstOrNull ?? picked;
  }

  /// Their team's notes; empty when none were written.
  String get opponentTeamNotes => _currentOpponentTeam?.notes ?? '';

  /// `Big Six vs Rival Grassy`, once both teams are picked.
  String? get matchupTitle => switch ((_selectedTeam, _currentOpponentTeam)) {
    (final mine?, final theirs?) => '${mine.name} vs ${theirs.name}',
    _ => null,
  };

  /// The plan for the picked pair: empty when none was written, null until
  /// both teams are picked.
  String? get matchupNotes => switch ((_selectedTeam, _selectedOpponentTeam)) {
    (final mine?, final theirs?) =>
      _matchupNotes[MatchupNote.keyOf(mine.id, theirs.id)] ?? '',
    _ => null,
  };

  Future<Result<void>> _saveMatchupNotes(String notes) =>
      _matchupRepository.save(
        MatchupNote(
          myTeamId: _selectedTeam!.id,
          opponentTeamId: _selectedOpponentTeam!.id,
          notes: notes.trim(),
          updatedAt: clock.now().toUtc(),
        ),
      );

  final GameLogRepository _gameLogRepository;
  final TeamRepository _teamRepository;
  final DateTime Function(DateTime utc) _toLocal;
  final PokemonRepository _pokemonRepository;
  final IdGenerator _idGenerator;

  /// Validates the form, saves the game and resets the form.
  late final Command0<void> save;

  GameResult? _result;
  List<Team> _teams = const [];
  Team? _selectedTeam;

  /// Your saved teams, to pick the one used (or none).
  List<Team> get teams => _teams;

  Team? get selectedTeam => _selectedTeam;

  void selectTeam(Team? team) {
    _selectedTeam = team;
    _brought.clear();
    _leads.clear();
    notifyListeners();
  }

  final List<PokemonRef> _brought = [];

  /// Your 4 brought Pokémon, in the order picked.
  List<PokemonRef> get brought => List.unmodifiable(_brought);

  /// Brings or un-brings [pokemon]. Returns why it was refused, if it was.
  String? toggleBrought(PokemonRef pokemon) {
    if (_brought.remove(pokemon)) {
      _leads.remove(pokemon);
    } else {
      if (_brought.length == 4) return 'Only 4 Pokémon can be brought.';
      _brought.add(pokemon);
    }
    notifyListeners();
    return null;
  }

  final List<PokemonRef> _leads = [];

  /// Your 2 leads, from the brought 4.
  List<PokemonRef> get leads => List.unmodifiable(_leads);

  /// Picks or un-picks [pokemon] as a lead. Returns why it was refused.
  String? toggleLead(PokemonRef pokemon) {
    if (!_leads.remove(pokemon)) {
      if (_brought.length < 4) return 'Pick your 4 brought Pokémon first.';
      if (!_brought.contains(pokemon)) {
        return 'Leads must be among the 4 brought.';
      }
      if (_leads.length == 2) return 'Only 2 Pokémon can lead.';
      _leads.add(pokemon);
    }
    notifyListeners();
    return null;
  }

  GameResult? get result => _result;

  void setResult(GameResult result) {
    _result = result;
    notifyListeners();
  }

  final List<PokemonRef?> _opponentSlots = List.filled(6, null);
  List<Team> _opponentTeams = const [];
  Team? _selectedOpponentTeam;

  /// Saved opponent teams, to fill their slots in one pick.
  List<Team> get opponentTeams => _opponentTeams;

  /// The saved opponent team this game is against, if one was picked.
  Team? get selectedOpponentTeam => _selectedOpponentTeam;

  /// Their 6 slots as entered, empty ones included.
  List<PokemonRef?> get opponentSlots => List.unmodifiable(_opponentSlots);

  /// Links the game to [team] and fills their slots with its Pokémon (they
  /// can still be edited). Their brought and leads start over, since they
  /// were picked from the old slots. None unlinks, keeping the slots.
  void selectOpponentTeam(Team? team) {
    _selectedOpponentTeam = team;
    if (team != null) {
      _opponentSlots.fillRange(0, 6, null);
      _opponentSlots.setAll(0, team.pokemon.take(6));
      _opponentBrought.clear();
      _opponentLeads.clear();
    }
    notifyListeners();
  }

  final List<PokemonRef> _opponentBrought = [];
  final List<PokemonRef> _opponentLeads = [];

  /// Their team from Team Preview: whichever of the 6 slots are filled.
  List<PokemonRef> get opponentTeam => _opponentSlots.nonNulls.toList();

  /// Up to 4 of their team, as far as you remember.
  List<PokemonRef> get opponentBrought => List.unmodifiable(_opponentBrought);

  /// Up to 2 of their brought.
  List<PokemonRef> get opponentLeads => List.unmodifiable(_opponentLeads);

  /// Sets one opponent slot; a Pokémon that leaves their team also leaves
  /// their brought and leads.
  void setOpponentSlot(int index, PokemonRef? pokemon) {
    _opponentSlots[index] = pokemon;
    final team = opponentTeam;
    _opponentBrought.removeWhere((p) => !team.contains(p));
    _opponentLeads.removeWhere((p) => !team.contains(p));
    notifyListeners();
  }

  /// Marks or unmarks one of their Pokémon as brought. Returns why it was
  /// refused.
  String? toggleOpponentBrought(PokemonRef pokemon) {
    if (_opponentBrought.remove(pokemon)) {
      _opponentLeads.remove(pokemon);
    } else {
      if (_opponentBrought.length == 4) {
        return 'Only 4 can be marked as brought.';
      }
      _opponentBrought.add(pokemon);
    }
    notifyListeners();
    return null;
  }

  /// Marks or unmarks one of their brought Pokémon as a lead. Returns why it
  /// was refused.
  String? toggleOpponentLead(PokemonRef pokemon) {
    if (!_opponentLeads.remove(pokemon)) {
      if (!_opponentBrought.contains(pokemon)) {
        return 'Leads must be among the Pokémon they brought.';
      }
      if (_opponentLeads.length == 2) return 'Only 2 can be marked as lead.';
      _opponentLeads.add(pokemon);
    }
    notifyListeners();
    return null;
  }

  /// Suggestions for a Pokémon field. A failure (e.g. offline with no
  /// cached index) is passed on, so the field can say why it's empty.
  Future<Result<List<PokemonRef>>> search(String query) =>
      _pokemonRepository.search(query);

  MistakeCategory? _mistake;
  String _notes = '';

  /// "What decided this game?" (optional).
  MistakeCategory? get mistake => _mistake;

  String get notes => _notes;

  void setMistake(MistakeCategory? mistake) {
    _mistake = mistake;
    notifyListeners();
  }

  void setNotes(String notes) => _notes = notes;

  Future<Result<void>> _save() async {
    final result = _result;
    if (result == null) {
      return const Result.failure(
        LogGameValidationError('Pick Win or Loss first.'),
      );
    }
    final team = _selectedTeam;
    if (team != null && _brought.length != 4) {
      return const Result.failure(
        LogGameValidationError('Pick exactly 4 brought Pokémon for your team.'),
      );
    }
    if (team != null && _leads.length != 2) {
      return const Result.failure(
        LogGameValidationError('Pick exactly 2 leads for your team.'),
      );
    }
    List<String> slugs(Iterable<PokemonRef> pokemon) => [
      for (final p in pokemon) p.slug,
    ];
    final game = GameLog(
      id: _idGenerator.next(),
      playedAt: clock.now().toUtc(),
      result: result,
      teamId: team?.id,
      teamName: team?.name,
      team: slugs(team?.pokemon ?? const []),
      brought: slugs(_brought),
      leads: slugs(_leads),
      opponentTeamId: _selectedOpponentTeam?.id,
      opponentTeamName: _selectedOpponentTeam?.name,
      opponentTeam: slugs(opponentTeam),
      opponentBrought: slugs(_opponentBrought),
      opponentLeads: slugs(_opponentLeads),
      mistake: _mistake,
      notes: _notes.trim(),
    );
    final saved = await _gameLogRepository.add(game);
    if (saved is Ok) {
      _lastSaved = game;
      _reset();
    }
    return saved;
  }

  /// The game saved last, for "Add to matchup notes".
  GameLog? _lastSaved;

  /// Whether the game just saved can add its notes to the plan: it was
  /// against a saved opponent team and has notes.
  bool get canAddLastGameToNotes =>
      _lastSaved?.opponentTeamId != null &&
      (_lastSaved?.notes.isNotEmpty ?? false);

  /// Where the notes would go: the matchup plan when your team was picked,
  /// otherwise their team's notes.
  String get addToNotesLabel => _lastSaved?.teamId != null
      ? 'Add to matchup notes'
      : 'Add to their notes';

  /// Appends the last game's notes, dated by its local day, to the plan
  /// (or their team's notes). Completes with where they went.
  late final Command0<String> addLastGameToNotes;

  Future<Result<String>> _addLastGameToNotes() async {
    final game = _lastSaved!;
    final entry = '${isoDate(_toLocal(game.playedAt))}: ${game.notes}';
    String appended(String existing) =>
        existing.isEmpty ? entry : '$existing\n$entry';

    if (game.teamId case final myTeamId?) {
      final key = MatchupNote.keyOf(myTeamId, game.opponentTeamId!);
      final saved = await _matchupRepository.save(
        MatchupNote(
          myTeamId: myTeamId,
          opponentTeamId: game.opponentTeamId!,
          notes: appended(_matchupNotes[key] ?? ''),
          updatedAt: clock.now().toUtc(),
        ),
      );
      return switch (saved) {
        Ok() => Result.ok('${game.teamName} vs ${game.opponentTeamName}'),
        Failure(:final error) => Result.failure(error),
      };
    }
    final theirs = _opponentTeams
        .where((t) => t.id == game.opponentTeamId)
        .firstOrNull;
    if (theirs == null) {
      return const Result.failure(
        LogGameValidationError('Their team is no longer saved.'),
      );
    }
    final saved = await _teamRepository.save(
      theirs.copyWith(notes: appended(theirs.notes)),
    );
    return switch (saved) {
      Ok() => Result.ok("${theirs.name}'s notes"),
      Failure(:final error) => Result.failure(error),
    };
  }

  @override
  void dispose() {
    _teamsSubscription.cancel();
    _matchupsSubscription.cancel();
    super.dispose();
  }

  void _reset() {
    _result = null;
    _selectedTeam = null;
    _brought.clear();
    _leads.clear();
    _opponentSlots.fillRange(0, 6, null);
    _selectedOpponentTeam = null;
    _opponentBrought.clear();
    _opponentLeads.clear();
    _mistake = null;
    _notes = '';
    notifyListeners();
  }
}
