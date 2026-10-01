import 'package:flutter/foundation.dart';

import '../../../data/repositories/item/item_repository.dart';
import '../../../data/repositories/pokemon/pokemon_names.dart';
import '../../../data/repositories/pokemon/pokemon_repository.dart';
import '../../../data/repositories/team/team_repository.dart';
import '../../../data/services/pokeapi/poke_api_exception.dart';
import '../../../domain/models/pokemon_ref.dart';
import '../../../domain/models/pokemon_set.dart';
import '../../../domain/models/team.dart';
import '../../../domain/showdown/showdown_format.dart';
import '../../../utils/command.dart';
import '../../../utils/id_generator.dart';
import '../../../utils/result.dart';

/// Why a paste can't be imported: every problem found, in words the player
/// can act on.
class TeamImportError implements Exception {
  const TeamImportError(this.problems);

  final List<String> problems;
}

/// State for importing a team from a Showdown paste: checks every species,
/// item and ability against PokéAPI, then saves the team with its sets.
class TeamImportViewModel extends ChangeNotifier {
  TeamImportViewModel({
    required this._teamRepository,
    required this._pokemonRepository,
    required this._itemRepository,
    required this._idGenerator,
  }) {
    import = Command0(_import);
  }

  final TeamRepository _teamRepository;
  final PokemonRepository _pokemonRepository;
  final ItemRepository _itemRepository;
  final IdGenerator _idGenerator;

  static const _teamSize = 6;

  /// Validates the paste and saves it as a new team.
  late final Command0<void> import;

  String _name = '';
  String _paste = '';

  void setName(String name) => _name = name;

  void setPaste(String paste) => _paste = paste;

  /// What stopped the last import, or empty.
  List<String> get problems => switch (import.result) {
    Failure(error: TeamImportError(:final problems)) => problems,
    _ => const [],
  };

  Future<Result<void>> _import() async {
    final name = _name.trim();
    if (name.isEmpty) return _problems(['Give the team a name.']);

    final List<PokemonSet> sets;
    switch (ShowdownFormat.parse(_paste)) {
      case Ok(:final value):
        sets = value;
      case Failure(error: ShowdownParseException(:final issues)):
        return _problems([
          for (final issue in issues) 'Line ${issue.line}: ${issue.message}',
        ]);
      case Failure(:final error):
        return Result.failure(error);
    }
    if (sets.length != _teamSize) {
      return _problems([
        'A team needs $_teamSize Pokémon; this paste has ${sets.length}.',
      ]);
    }

    final problems = <String>[];
    final checked = <_Checked>[];
    try {
      for (final set in sets) {
        final result = await _check(set, problems.add);
        if (result != null) checked.add(result);
      }
    } on _Unreachable {
      return _problems([
        "Couldn't reach PokéAPI to check the team. Try again.",
      ]);
    }
    final species = <String>{};
    for (final (:ref, :speciesSlug) in checked) {
      if (!species.add(speciesSlug)) {
        problems.add('${ref.displayName} is on the team twice.');
      }
    }
    if (problems.isNotEmpty) return _problems(problems);

    return _teamRepository.save(
      Team(
        id: _idGenerator.next(),
        name: name,
        pokemon: [for (final (:ref, speciesSlug: _) in checked) ref],
        sets: sets,
      ),
    );
  }

  /// Checks one set, reporting what's wrong with it. Returns its Pokémon
  /// (the base form, as picked in the editor) unless the species is unknown.
  /// Throws [_Unreachable] for anything but a clear "not found".
  Future<_Checked?> _check(PokemonSet set, void Function(String) report) async {
    final species = set.species;
    final base = _value(await _pokemonRepository.resolve(species));
    if (base == null) {
      report('"$species" isn\'t a Pokémon PokéAPI knows.');
      return null;
    }

    if (set.item case final item?) {
      if (_value(await _itemRepository.resolve(item)) == null) {
        report('$species: "$item" isn\'t an item PokéAPI knows.');
      }
    }

    final details = _required(await _pokemonRepository.getPokemon(base.slug));
    if (set.ability case final ability?
        when !details.abilities.contains(PokemonNames.normalize(ability))) {
      report("$species: $ability isn't one of its abilities.");
    }

    if (set.megaAbility case final megaAbility?) {
      final battle = _required(
        await _pokemonRepository.resolve(species, item: set.item),
      );
      if (battle.slug == base.slug) {
        report('$species: → $megaAbility needs its Mega Stone.');
      } else {
        final mega = _required(
          await _pokemonRepository.getPokemon(battle.slug),
        );
        if (!mega.abilities.contains(PokemonNames.normalize(megaAbility))) {
          report(
            "${battle.displayName}: $megaAbility isn't one of its abilities.",
          );
        }
      }
    }
    return (ref: base, speciesSlug: details.speciesSlug);
  }

  /// The value, or null when PokéAPI doesn't know it.
  static T? _value<T>(Result<T> result) => switch (result) {
    Ok(:final value) => value,
    Failure(error: PokeApiNotFound()) => null,
    Failure() => throw const _Unreachable(),
  };

  /// The value of a lookup that should always succeed for a known Pokémon.
  static T _required<T>(Result<T> result) => switch (result) {
    Ok(:final value) => value,
    Failure() => throw const _Unreachable(),
  };

  static Result<void> _problems(List<String> problems) =>
      Result.failure(TeamImportError(problems));
}

typedef _Checked = ({PokemonRef ref, String speciesSlug});

/// PokéAPI couldn't be asked (offline, server error): stop checking.
class _Unreachable implements Exception {
  const _Unreachable();
}
