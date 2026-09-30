import 'package:flutter/foundation.dart';

import '../../../data/repositories/pokemon/pokemon_repository.dart';
import '../../../data/repositories/team/team_repository.dart';
import '../../../domain/models/pokemon.dart';
import '../../../domain/models/pokemon_ref.dart';
import '../../../domain/models/team.dart';
import '../../../utils/command.dart';
import '../../../utils/id_generator.dart';
import '../../../utils/result.dart';

/// Why a team can't be saved, in words the player can act on.
class TeamValidationError implements Exception {
  const TeamValidationError(this.message);

  final String message;
}

/// State for creating or editing a team: a name and six Pokémon.
class TeamEditorViewModel extends ChangeNotifier {
  TeamEditorViewModel({
    required this._teamRepository,
    required this._pokemonRepository,
    required this._idGenerator,
    String? teamId,
  }) : _teamId = teamId,
       _loaded = teamId == null {
    save = Command0(_save);
    if (teamId != null) _load(teamId);
  }

  /// The team being edited, or null when creating a new one.
  final String? _teamId;

  bool get isEditing => _teamId != null;

  final TeamRepository _teamRepository;
  final PokemonRepository _pokemonRepository;
  final IdGenerator _idGenerator;

  /// Validates and saves the team.
  late final Command0<void> save;

  bool _loaded;

  /// False while an existing team is being loaded into the form.
  bool get loaded => _loaded;

  String _name = '';
  final List<PokemonRef?> _slots = List.filled(6, null);

  String get name => _name;
  List<PokemonRef?> get slots => List.unmodifiable(_slots);

  void setName(String name) => _name = name;

  void setSlot(int index, PokemonRef? pokemon) => _slots[index] = pokemon;

  /// Suggestions for a Pokémon field; empty if search fails (e.g. offline
  /// with no cached index), so the field just shows no suggestions.
  Future<List<PokemonRef>> search(String query) async =>
      switch (await _pokemonRepository.search(query)) {
        Ok(:final value) => value,
        Failure() => const [],
      };

  bool _missing = false;

  /// True when the team being edited no longer exists (e.g. an old link).
  bool get missing => _missing;

  Future<void> _load(String teamId) async {
    final teams = await _teamRepository.watchAll().first;
    final team = teams.where((t) => t.id == teamId).firstOrNull;
    if (team == null) {
      _missing = true;
    } else {
      _name = team.name;
      _slots.setAll(0, team.pokemon);
    }
    _loaded = true;
    notifyListeners();
  }

  Future<Result<void>> _save() async {
    final name = _name.trim();
    if (name.isEmpty) {
      return const Result.failure(TeamValidationError('Give the team a name.'));
    }
    final pokemon = _slots.nonNulls.toList();
    if (pokemon.length < 6) {
      return const Result.failure(TeamValidationError('Pick all 6 Pokémon.'));
    }
    final duplicateError = await _duplicateError(pokemon);
    if (duplicateError != null) return Result.failure(duplicateError);
    return _teamRepository.save(
      Team(id: _teamId ?? _idGenerator.next(), name: name, pokemon: pokemon),
    );
  }

  /// The same Pokémon twice, or two forms of one species (VGC's species
  /// clause). Species need each Pokémon's details; if any lookup fails (e.g.
  /// offline), only exact duplicates are checked rather than blocking the
  /// save.
  Future<TeamValidationError?> _duplicateError(List<PokemonRef> pokemon) async {
    final seen = <String>{};
    for (final p in pokemon) {
      if (!seen.add(p.slug)) {
        return TeamValidationError('${p.displayName} is on the team twice.');
      }
    }

    final details = await Future.wait(
      pokemon.map((p) => _pokemonRepository.getPokemon(p.slug)),
    );
    final bySpecies = <String, PokemonRef>{};
    for (final (i, detail) in details.indexed) {
      if (detail is! Ok<Pokemon>) return null;
      final first = bySpecies.putIfAbsent(
        detail.value.speciesSlug,
        () => pokemon[i],
      );
      if (first != pokemon[i]) {
        return TeamValidationError(
          '${pokemon[i].displayName} is the same species as '
          '${first.displayName}.',
        );
      }
    }
    return null;
  }
}
