import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/foundation.dart';

import '../../../data/repositories/game_log/game_log_repository.dart';
import '../../../data/repositories/pokemon/pokemon_names.dart';
import '../../../data/repositories/pokemon/pokemon_repository.dart';
import '../../../data/repositories/team/team_repository.dart';
import '../../../domain/models/game_log.dart';
import '../../../domain/models/mistake_category.dart';
import '../../../domain/models/pokemon_ref.dart';
import '../../../domain/models/team.dart';
import '../../../utils/command.dart';
import '../../../utils/id_generator.dart';
import '../../../utils/iso_date.dart';
import '../../../utils/result.dart';
import 'progress_stats.dart';

/// Why a game's opponent couldn't be saved as a team, in words the player
/// can act on.
class SaveOpponentTeamError implements Exception {
  const SaveOpponentTeamError(this.message);

  final String message;
}

/// State for the Progress tab: statistics recomputed from the game log each
/// time it changes (never in `build`).
class ProgressViewModel extends ChangeNotifier {
  ProgressViewModel({
    required GameLogRepository gameLogRepository,
    required this._teamRepository,
    required this._pokemonRepository,
    required this._idGenerator,
    DateTime Function(DateTime utc)? toLocal,
  }) : _gameLogRepository = gameLogRepository,
       _toLocal = toLocal ?? ((utc) => utc.toLocal()) {
    deleteGame = Command1(_deleteGame);
    undoDelete = Command0(_undoDelete);
    saveOpponentTeam = Command1(_saveOpponentTeam);
    _subscription = gameLogRepository.watchAll().listen((games) {
      _stats = _compute(games);
      _loaded = true;
      notifyListeners();
    });
  }

  final GameLogRepository _gameLogRepository;
  final TeamRepository _teamRepository;
  final PokemonRepository _pokemonRepository;
  final IdGenerator _idGenerator;

  static const _teamSize = 6;

  /// Saves a game's opponent Pokémon as a named opponent team, and links
  /// the game to it so its matchup record counts the game. Completes with
  /// the name it was saved under.
  late final Command1<String, ({GameLog game, String name})> saveOpponentTeam;

  /// Whether [game] can offer "Save their team": all 6 of their Pokémon
  /// were entered, and it isn't linked to a saved team yet.
  bool canSaveOpponentTeam(GameLog game) =>
      game.opponentTeam.length == _teamSize && game.opponentTeamId == null;

  Future<Result<String>> _saveOpponentTeam(
    ({GameLog game, String name}) request,
  ) async {
    final name = request.name.trim();
    if (name.isEmpty) {
      return const Result.failure(
        SaveOpponentTeamError('Give the team a name.'),
      );
    }
    // Games store slugs; a team needs each Pokémon's index entry.
    final pokemon = <PokemonRef>[];
    for (final slug in request.game.opponentTeam) {
      switch (await _pokemonRepository.resolve(slug)) {
        case Ok(:final value):
          pokemon.add(value);
        case Failure():
          return const Result.failure(
            SaveOpponentTeamError(
              "Couldn't look up their Pokémon. Check your connection and try "
              'again.',
            ),
          );
      }
    }
    final team = Team(
      id: _idGenerator.next(),
      name: name,
      pokemon: pokemon,
      side: TeamSide.opponent,
    );
    if (await _teamRepository.save(team) case Failure(:final error)) {
      return Result.failure(error);
    }
    final linked = await _gameLogRepository.add(
      request.game.copyWith(opponentTeamId: team.id, opponentTeamName: name),
    );
    return switch (linked) {
      Ok() => Result.ok(name),
      Failure(:final error) => Result.failure(error),
    };
  }

  late final StreamSubscription<List<GameLog>> _subscription;

  /// Deletes a logged game, remembering it so [undoDelete] can restore it.
  late final Command1<void, GameLog> deleteGame;

  /// Restores the game removed by the last [deleteGame].
  late final Command0<void> undoDelete;

  GameLog? _lastDeleted;

  Future<Result<void>> _deleteGame(GameLog game) {
    // Undo is only offered after a successful delete (see ProgressScreen).
    _lastDeleted = game;
    return _gameLogRepository.delete(game.id);
  }

  Future<Result<void>> _undoDelete() {
    final game = _lastDeleted!;
    _lastDeleted = null;
    return _gameLogRepository.add(game);
  }

  /// The game's local date, e.g. `2026-09-30`.
  String dateLabel(GameLog game) => isoDate(_localDay(game.playedAt));

  /// Display name for a stored slug, e.g. `Raichu-Mega-Y`.
  String pokemonName(String slug) => PokemonNames.displayName(slug);

  /// Converts a UTC instant to the player's local time (injectable so tests
  /// can pin a timezone).
  final DateTime Function(DateTime utc) _toLocal;

  bool _loaded = false;
  ProgressStats _stats = _empty;

  bool get loaded => _loaded;

  ProgressStats get stats => _stats;

  static const _empty = ProgressStats(
    totalGames: 0,
    winRatePercent: null,
    gamesLast7Days: 0,
    winRateLast7DaysPercent: null,
    dayStreak: 0,
    weeklyFocus: null,
    mistakeBreakdown: [],
    teamRecords: [],
    opponentLeads: [],
    recentGames: [],
  );

  ProgressStats _compute(List<GameLog> games) {
    final today = _localDay(clock.now().toUtc());
    final last7 = games.where((g) => _isWithinDays(g, today, 7)).toList();
    return _empty.copyWith(
      totalGames: games.length,
      winRatePercent: _winRate(games),
      gamesLast7Days: last7.length,
      winRateLast7DaysPercent: _winRate(last7),
      dayStreak: _dayStreak(games, today),
      weeklyFocus: _weeklyFocus(games, today),
      mistakeBreakdown: _mistakeBreakdown(games),
      teamRecords: _teamRecords(games),
      opponentLeads: _opponentLeads(games),
      // The repository already lists games newest first.
      recentGames: games,
    );
  }

  /// The 8 opponent leads seen most often, with your win % against each.
  /// Ties go to the lead seen most recently (the current meta).
  static List<LeadRecord> _opponentLeads(List<GameLog> games) {
    final seen = <String, List<GameLog>>{};
    for (final g in games) {
      for (final slug in g.opponentLeads) {
        (seen[slug] ??= []).add(g);
      }
    }
    DateTime lastSeen(String slug) => seen[slug]!
        .map((g) => g.playedAt)
        .reduce((a, b) => a.isAfter(b) ? a : b);
    final slugs = seen.keys.toList()
      ..sort(
        (a, b) => seen[a]!.length != seen[b]!.length
            ? seen[b]!.length.compareTo(seen[a]!.length)
            : lastSeen(b).compareTo(lastSeen(a)),
      );
    return [
      for (final slug in slugs.take(8))
        LeadRecord(
          slug: slug,
          timesSeen: seen[slug]!.length,
          winRatePercent: _winRate(seen[slug]!)!,
        ),
    ];
  }

  /// Record per team, grouped by id (the original grouped by name, so a
  /// rename split the stats). Shows the name from the team's most recent
  /// game; most games first, then by name.
  static List<TeamRecord> _teamRecords(List<GameLog> games) {
    final byTeam = <String, List<GameLog>>{};
    for (final g in games) {
      if (g.teamId case final id?) (byTeam[id] ??= []).add(g);
    }
    final records = [
      for (final MapEntry(key: id, value: teamGames) in byTeam.entries)
        TeamRecord(
          teamId: id,
          teamName: teamGames
              .reduce((a, b) => a.playedAt.isAfter(b.playedAt) ? a : b)
              .teamName!,
          wins: teamGames.where((g) => g.result == GameResult.win).length,
          losses: teamGames.where((g) => g.result == GameResult.loss).length,
          winRatePercent: _winRate(teamGames)!,
        ),
    ];
    int played(TeamRecord r) => r.wins + r.losses;
    return records..sort(
      (a, b) => played(a) != played(b)
          ? played(b).compareTo(played(a))
          : a.teamName.compareTo(b.teamName),
    );
  }

  /// Every picked category (including "played well"), all time, most common
  /// first; ties keep the original's option order.
  static List<MistakeCount> _mistakeBreakdown(List<GameLog> games) {
    final counts = <MistakeCategory, int>{};
    for (final mistake in games.map((g) => g.mistake).nonNulls) {
      counts[mistake] = (counts[mistake] ?? 0) + 1;
    }
    return [
      for (final mistake in MistakeCategory.values)
        if (counts[mistake] case final count?)
          MistakeCount(mistake: mistake, count: count),
    ]..sort(
      // Explicit tie-break: List.sort isn't guaranteed to be stable.
      (a, b) => b.count != a.count
          ? b.count.compareTo(a.count)
          : a.mistake.index.compareTo(b.mistake.index),
    );
  }

  /// The most common real mistake (not "played well") in the last 14 local
  /// days. A tie goes to the mistake seen most recently.
  WeeklyFocus? _weeklyFocus(List<GameLog> games, DateTime today) {
    final withMistakes = [
      for (final g in games)
        if (g.mistake case final mistake?
            when !mistake.isPlayedWell && _isWithinDays(g, today, 14))
          (mistake: mistake, at: g.playedAt),
    ];
    if (withMistakes.isEmpty) return null;
    final counts = <MistakeCategory, int>{};
    final lastSeen = <MistakeCategory, DateTime>{};
    for (final (:mistake, :at) in withMistakes) {
      counts[mistake] = (counts[mistake] ?? 0) + 1;
      final seen = lastSeen[mistake];
      if (seen == null || at.isAfter(seen)) lastSeen[mistake] = at;
    }
    final top = counts.keys.reduce((a, b) {
      final byCount = counts[a]!.compareTo(counts[b]!);
      if (byCount != 0) return byCount > 0 ? a : b;
      return lastSeen[a]!.isAfter(lastSeen[b]!) ? a : b;
    });
    return WeeklyFocus(
      mistake: top,
      count: counts[top]!,
      gamesWithMistakes: withMistakes.length,
    );
  }

  /// Consecutive local days with a game, counting back from today, or from
  /// yesterday when nothing is logged yet today (so the streak doesn't reset
  /// every morning).
  int _dayStreak(List<GameLog> games, DateTime today) {
    final played = {for (final g in games) _localDay(g.playedAt)};
    var day = played.contains(today)
        ? today
        : DateTime(today.year, today.month, today.day - 1);
    var streak = 0;
    while (played.contains(day)) {
      streak++;
      day = DateTime(day.year, day.month, day.day - 1);
    }
    return streak;
  }

  /// The local calendar day of a UTC instant (the original used UTC dates,
  /// so evening games landed on the next day).
  DateTime _localDay(DateTime utc) {
    final local = _toLocal(utc);
    return DateTime(local.year, local.month, local.day);
  }

  /// Played on [today] or one of the `days - 1` local days before it.
  bool _isWithinDays(GameLog game, DateTime today, int days) {
    final day = _localDay(game.playedAt);
    final first = DateTime(today.year, today.month, today.day - (days - 1));
    return !day.isBefore(first) && !day.isAfter(today);
  }

  /// Win % rounded like the original (`Math.round`); null with no games.
  static int? _winRate(Iterable<GameLog> games) {
    if (games.isEmpty) return null;
    final wins = games.where((g) => g.result == GameResult.win).length;
    return (wins * 100 / games.length).round();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
