import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/foundation.dart';

import '../../../data/repositories/game_log/game_log_repository.dart';
import '../../../data/repositories/matchup/matchup_repository.dart';
import '../../../data/repositories/pokemon/pokemon_repository.dart';
import '../../../data/repositories/team/team_repository.dart';
import '../../../data/repositories/type/type_repository.dart';
import '../../../domain/models/game_log.dart';
import '../../../domain/models/matchup_note.dart';
import '../../../domain/models/mistake_category.dart';
import '../../../domain/models/pokemon_ref.dart';
import '../../../domain/models/pokemon_set.dart';
import '../../../domain/models/team.dart';
import '../../../domain/stats/speed_order.dart';
import '../../../domain/stats/type_matchups.dart';
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
    required this._typeRepository,
    required this._idGenerator,
    DateTime Function(DateTime utc)? toLocal,
  }) : _toLocal = toLocal ?? ((utc) => utc.toLocal()) {
    save = Command0(_save);
    addLastGameToNotes = Command0(_addLastGameToNotes);
    logNextGame = Command0(_logNextGame);
    endSet = Command0(_endSet);
    // Watched: the open best-of-3 is derived from the logged games, so it
    // survives a restart.
    _gamesSubscription = _gameLogRepository.watchAll().listen((games) {
      _games = games;
      notifyListeners();
    });
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
  late final StreamSubscription<List<GameLog>> _gamesSubscription;

  /// Every logged game, newest first.
  List<GameLog> _games = const [];

  static const _setWinsNeeded = 2;

  bool _partOfSet = false;

  /// "Part of a best-of-3" for the game being logged.
  bool get partOfSet => _partOfSet;

  void setPartOfSet(bool partOfSet) {
    _partOfSet = partOfSet;
    notifyListeners();
  }

  /// The set being continued by "Log game N", and that game's number.
  ({String setId, int game})? _continuing;

  /// Which game of the set is being logged, while continuing one.
  int? get continuingSetGame => _continuing?.game;

  /// The open best-of-3: the set of the latest logged game, while it's
  /// undecided and wasn't ended early.
  ({List<GameLog> games, int wins, int losses})? get _openSet {
    final setId = _games.firstOrNull?.setId;
    if (setId == null) return null;
    final games = [
      for (final g in _games)
        if (g.setId == setId) g,
    ];
    if (games.any((g) => g.endsSet)) return null;
    final (wins, losses) = _score(games);
    if (wins >= _setWinsNeeded || losses >= _setWinsNeeded) return null;
    return (games: games, wins: wins, losses: losses);
  }

  static (int, int) _score(Iterable<GameLog> games) => (
    games.where((g) => g.result == GameResult.win).length,
    games.where((g) => g.result == GameResult.loss).length,
  );

  /// `Best-of-3 vs Rival Grassy · 1–0`, while a set is open.
  String? get openSetTitle {
    final set = _openSet;
    if (set == null) return null;
    final against = switch (set.games.first.opponentTeamName) {
      final name? => ' vs $name',
      null => '',
    };
    return 'Best-of-3$against · ${set.wins}–${set.losses}';
  }

  /// The number of the open set's next game.
  int? get nextSetGame => switch (_openSet) {
    final set? => set.games.length + 1,
    null => null,
  };

  String? _lastSetResult;

  /// `Set won 2–1`, when the game just saved decided its set.
  String? get lastSetResult => _lastSetResult;

  /// Starts the open set's next game: both teams carried over, the rest
  /// cleared.
  late final Command0<void> logNextGame;

  /// Closes the open set early (a forfeit, or one you stopped logging).
  late final Command0<void> endSet;

  Future<Result<void>> _logNextGame() async {
    final set = _openSet!;
    final last = set.games.first;
    _reset();
    _continuing = (setId: last.setId!, game: set.games.length + 1);
    _selectedTeam = _teams.where((t) => t.id == last.teamId).firstOrNull;
    final theirs = _opponentTeams
        .where((t) => t.id == last.opponentTeamId)
        .firstOrNull;
    if (theirs != null) {
      selectOpponentTeam(theirs);
    } else {
      for (final (i, slug) in last.opponentTeam.take(6).indexed) {
        if (await _pokemonRepository.resolve(slug) case Ok(:final value)) {
          _opponentSlots[i] = value;
        }
      }
    }
    notifyListeners();
    unawaited(_refreshSpeed());
    return const Result.ok(null);
  }

  Future<Result<void>> _endSet() =>
      _gameLogRepository.add(_openSet!.games.first.copyWith(endsSet: true));
  final MatchupRepository _matchupRepository;
  final TypeRepository _typeRepository;

  List<String> _threatRows = const [];

  /// Their Pokémon's types as likely attacks against your team, strongest
  /// first: `Fighting → Kingambit ×4`. Empty until both sides are in.
  List<String> get threatRows => _threatRows;
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
    unawaited(_refreshSpeed());
  }

  SpeedMode _speedMode = SpeedMode.normal;
  List<SpeedInput> _speedInputs = const [];
  List<SpeedEntry> _speedEntries = const [];
  bool _speedUnavailable = false;

  /// Bumped per refresh, so a slow lookup can't overwrite a newer one.
  int _speedRequest = 0;

  /// Both teams in the order they move under [speedMode]; empty until your
  /// team is picked and their Pokémon are filled in.
  List<SpeedEntry> get speedEntries => _speedEntries;

  SpeedMode get speedMode => _speedMode;

  /// [speedEntries] as one line each: `Sneasler · theirs · 140–189`, with
  /// `· tie` when another Pokémon has the same exact Speed.
  List<String> get speedRows => [
    for (final e in _speedEntries)
      [
        e.name,
        e.side == SpeedSide.mine ? 'yours' : 'theirs',
        e.min == e.max ? '${e.min}' : '${e.min}–${e.max}',
        if (e.tie) 'tie',
      ].join(' · '),
  ];

  /// A Pokémon couldn't be looked up (e.g. offline), so there's no order.
  bool get speedUnavailable => _speedUnavailable;

  void setSpeedMode(SpeedMode mode) {
    _speedMode = mode;
    _speedEntries = speedOrder(_speedInputs, mode: mode);
    notifyListeners();
  }

  Future<void> _refreshSpeed() async {
    final request = ++_speedRequest;
    final mine = _selectedTeam;
    final theirs = _opponentSlots;
    final List<SpeedInput> inputs;
    if (mine == null || opponentTeam.isEmpty) {
      inputs = const [];
      _threatRows = const [];
    } else {
      final pending = [
        for (final (i, ref) in mine.pokemon.indexed)
          _speedInput(SpeedSide.mine, ref, _setAt(mine, i, ref)),
        for (final (i, ref) in theirs.indexed)
          if (ref != null)
            _speedInput(SpeedSide.theirs, ref, switch (_selectedOpponentTeam) {
              final team? => _setAt(team, i, ref),
              null => null,
            }),
      ];
      final results = await Future.wait(pending);
      if (request != _speedRequest) return; // a newer pick won
      if (results.contains(null)) {
        _speedUnavailable = true;
        _speedInputs = const [];
        _speedEntries = const [];
        notifyListeners();
        return;
      }
      final found = results.nonNulls.toList();
      inputs = [for (final r in found) r.input];
      _threatRows = await _threats(found);
      if (request != _speedRequest) return; // a newer pick won
    }
    _speedUnavailable = false;
    _speedInputs = inputs;
    _speedEntries = speedOrder(inputs, mode: _speedMode);
    notifyListeners();
  }

  /// Their members' types as attacks against yours, as one line each.
  Future<List<String>> _threats(
    List<({SpeedInput input, List<String> types})> found,
  ) async {
    if (await _typeRepository.chart() case Ok(value: final chart)) {
      return [
        for (final t in threats(
          chart,
          [
            for (final f in found)
              if (f.input.side == SpeedSide.theirs) ...f.types,
          ],
          [
            for (final f in found)
              if (f.input.side == SpeedSide.mine)
                (name: f.input.name, types: f.types),
          ],
        ))
          '${t.type[0].toUpperCase()}${t.type.substring(1)} → '
              '${[for (final h in t.hits) '${h.name} ×${h.multiplier.toInt()}'].join(', ')}',
      ];
    }
    return const [];
  }

  /// [team]'s imported set for slot [i], while that slot still holds the
  /// team's Pokémon.
  static PokemonSet? _setAt(Team team, int i, PokemonRef ref) =>
      i < team.sets.length && i < team.pokemon.length && team.pokemon[i] == ref
      ? team.sets[i]
      : null;

  /// [ref] in its battle form (its Mega when [set] holds the stone), with
  /// its types, or null when it can't be looked up.
  Future<({SpeedInput input, List<String> types})?> _speedInput(
    SpeedSide side,
    PokemonRef ref,
    PokemonSet? set,
  ) async {
    final form = await _pokemonRepository.resolve(ref.slug, item: set?.item);
    if (form case Ok(:final value)) {
      if (await _pokemonRepository.getPokemon(value.slug) case Ok(
        value: final pokemon,
      )) {
        return (
          input: (
            side: side,
            name: pokemon.displayName,
            base: pokemon.baseStats,
            set: set,
          ),
          types: pokemon.types,
        );
      }
    }
    return null;
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
    unawaited(_refreshSpeed());
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
    unawaited(_refreshSpeed());
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
    final continuing = _continuing;
    final setId =
        continuing?.setId ?? (_partOfSet ? _idGenerator.next() : null);
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
      setId: setId,
      setGame: continuing?.game ?? (setId == null ? null : 1),
    );
    final saved = await _gameLogRepository.add(game);
    if (saved is Ok) {
      _lastSaved = game;
      _lastSetResult = setId == null ? null : _setResult(setId, game);
      _reset();
    }
    return saved;
  }

  /// `Set won 2–1` if [game] decided its set, else null.
  String? _setResult(String setId, GameLog game) {
    final (wins, losses) = _score([
      game,
      for (final g in _games)
        if (g.setId == setId && g.id != game.id) g,
    ]);
    if (wins >= _setWinsNeeded) return 'Set won $wins–$losses';
    if (losses >= _setWinsNeeded) return 'Set lost $wins–$losses';
    return null;
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
    _gamesSubscription.cancel();
    // A speed lookup still in flight is now stale: it won't notify.
    _speedRequest++;
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
    _partOfSet = false;
    _continuing = null;
    notifyListeners();
    unawaited(_refreshSpeed());
  }
}
