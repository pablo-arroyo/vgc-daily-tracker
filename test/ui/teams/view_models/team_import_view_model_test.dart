import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/data/services/pokeapi/poke_api_exception.dart';
import 'package:vgc_daily_tracker/domain/models/team.dart';
import 'package:vgc_daily_tracker/domain/use_cases/import_team_use_case.dart';
import 'package:vgc_daily_tracker/ui/teams/view_models/team_import_view_model.dart';

import '../../../../testing/fakes/fake_id_generator.dart';
import '../../../../testing/fakes/fake_item_repository.dart';
import '../../../../testing/fakes/fake_pokemon_repository.dart';
import '../../../../testing/fakes/fake_team_repository.dart';
import '../../../../testing/showdown_pastes.dart';

void main() {
  late FakeTeamRepository teams;
  late FakePokemonRepository pokemon;
  late FakeItemRepository items;

  setUp(() {
    teams = FakeTeamRepository();
    pokemon = FakePokemonRepository();
    items = FakeItemRepository();
  });

  TeamImportViewModel create() {
    final viewModel = TeamImportViewModel(
      teamRepository: teams,
      importTeam: ImportTeamUseCase(
        pokemonRepository: pokemon,
        itemRepository: items,
        idGenerator: SequentialIdGenerator(),
      ),
    );
    addTearDown(viewModel.dispose);
    return viewModel;
  }

  Future<List<Team>> saved() => teams.watchAll().first;

  /// Imports [paste] as "Worlds" and returns the problems found.
  Future<List<String>> import(String paste, {String name = 'Worlds'}) async {
    final viewModel = create()
      ..setName(name)
      ..setPaste(paste);
    await viewModel.import.execute();
    return viewModel.problems;
  }

  test('imports Team 1: base forms on the team, the sets alongside', () async {
    final viewModel = create()
      ..setName('  Worlds Metagross ')
      ..setPaste(team1Paste);

    await viewModel.import.execute();

    expect(viewModel.import.completed, isTrue);
    expect(viewModel.problems, isEmpty);
    final [team] = await saved();
    expect(team.id, 'id-1');
    expect(team.name, 'Worlds Metagross');
    expect(team.pokemon.map((p) => p.slug), [
      'kingambit',
      'kleavor',
      'metagross',
      'whimsicott',
      'raichu',
      'basculegion-male',
    ]);
    expect(team.sets.map((s) => s.species), [
      'Kingambit',
      'Kleavor',
      'Metagross',
      'Whimsicott',
      'Raichu',
      'Basculegion',
    ]);
    expect(team.sets[2].item, 'Metagrossite');
  });

  test('needs a name', () async {
    expect(await import(team1Paste, name: '  '), ['Give the team a name.']);
    expect(await saved(), isEmpty);
  });

  test('reports paste errors with their line numbers', () async {
    final problems = await import(
      team1Paste.replaceFirst('Jolly Nature', 'Grumpy Nature'),
    );

    expect(problems, ['Line 25: Unknown nature "Grumpy"']);
    expect(await saved(), isEmpty);
  });

  test('needs exactly 6 Pokémon', () async {
    final oneSet = team1Paste.split('\n\n').first;

    expect(await import(oneSet), ['A team needs 6 Pokémon; this paste has 1.']);
  });

  test('checks every species, item and ability, reporting them all', () async {
    final problems = await import(
      team1Paste
          .replaceFirst('Kingambit @', 'Kingamby @')
          .replaceFirst('Focus Sash', 'Focus Sasch')
          .replaceFirst('Clear Body', 'Clear Bod'),
    );

    expect(problems, [
      '"Kingamby" isn\'t a Pokémon PokéAPI knows.',
      'Kleavor: "Focus Sasch" isn\'t an item PokéAPI knows.',
      'Metagross: Clear Bod isn\'t one of its abilities.',
    ]);
    expect(await saved(), isEmpty);
  });

  test("checks a Mega ability against the Mega's own abilities", () async {
    final valid = await import(
      team1Paste.replaceFirst('Lightning Rod', 'Lightning Rod → No Guard'),
    );
    final invalid = await import(
      team1Paste.replaceFirst('Lightning Rod', 'Lightning Rod → Levitate'),
    );

    expect(valid, isEmpty);
    expect(invalid, ["Raichu-Mega-Y: Levitate isn't one of its abilities."]);
  });

  test('a Mega ability without the Mega Stone is a problem', () async {
    final problems = await import(
      team1Paste
          .replaceFirst('Metagrossite', 'Life Orb')
          .replaceFirst('Clear Body', 'Clear Body → Tough Claws'),
    );

    expect(problems, ['Metagross: → Tough Claws needs its Mega Stone.']);
  });

  test('two of one species break the species clause', () async {
    final problems = await import(
      team1Paste
          .replaceFirst('Kleavor @', 'Kingambit @')
          .replaceFirst('Ability: Sharpness', 'Ability: Defiant'),
    );

    expect(problems, ['Kingambit is on the team twice.']);
  });

  test('offline: one clear problem, nothing saved', () async {
    pokemon.failWith = const PokeApiNetworkUnavailable('/pokemon');
    items.failWith = const PokeApiNetworkUnavailable('/item');

    expect(await import(team1Paste), [
      "Couldn't reach PokéAPI to check the team. Try again.",
    ]);
    expect(await saved(), isEmpty);
  });

  test('losing the connection mid-check is the same clear problem', () async {
    // Names still resolve from the cached index; details can't be fetched.
    pokemon.failWith = const PokeApiNetworkUnavailable('/pokemon/kingambit');

    expect(await import(team1Paste), [
      "Couldn't reach PokéAPI to check the team. Try again.",
    ]);
    expect(await saved(), isEmpty);
  });

  test('a failed save is an error without problems to list', () async {
    teams.failWith = Exception('disk full');
    final viewModel = create()
      ..setName('Worlds')
      ..setPaste(team1Paste);

    await viewModel.import.execute();

    expect(viewModel.import.error, isTrue);
    expect(viewModel.problems, isEmpty);
  });
}
