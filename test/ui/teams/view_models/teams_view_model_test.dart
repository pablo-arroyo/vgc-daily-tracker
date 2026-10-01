import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/config/format_config.dart';
import 'package:vgc_daily_tracker/data/services/pokeapi/poke_api_exception.dart';
import 'package:vgc_daily_tracker/domain/use_cases/import_team_use_case.dart';
import 'package:vgc_daily_tracker/domain/models/team.dart';
import 'package:vgc_daily_tracker/ui/teams/view_models/teams_view_model.dart';

import '../../../../testing/fakes/fake_id_generator.dart';
import '../../../../testing/fakes/fake_item_repository.dart';
import '../../../../testing/fakes/fake_pokemon_repository.dart';
import '../../../../testing/fakes/fake_team_repository.dart';

/// A Teams view model over [teams], with the real import use case over
/// fake PokéAPI data and the Reg M-C sample teams.
TeamsViewModel create(FakeTeamRepository teams, {FakeItemRepository? items}) =>
    TeamsViewModel(
      teamRepository: teams,
      importTeam: ImportTeamUseCase(
        pokemonRepository: FakePokemonRepository(),
        itemRepository: items ?? FakeItemRepository(),
        idGenerator: SequentialIdGenerator(),
      ),
      format: FormatConfig.regMC,
    );

void main() {
  const bigSix = Team(id: 't1', name: 'Big Six', pokemon: []);
  const metagross = Team(id: 't2', name: 'Mega Metagross', pokemon: []);

  late FakeTeamRepository repository;
  late TeamsViewModel viewModel;

  setUp(() {
    repository = FakeTeamRepository(teams: [metagross, bigSix]);
    viewModel = create(repository);
  });
  tearDown(() => viewModel.dispose());

  test('is not loaded until the teams arrive, then lists them', () async {
    // Created here, not in setUp: the first emission lands before the test
    // body would run.
    final fresh = create(repository);
    addTearDown(fresh.dispose);
    expect(fresh.loaded, isFalse);

    await pumpEventQueue();

    expect(fresh.loaded, isTrue);
    expect(fresh.teams, [bigSix, metagross]);
  });

  test('deleteTeam removes a team and undoDelete brings it back', () async {
    await pumpEventQueue();

    await viewModel.deleteTeam.execute(bigSix);
    await pumpEventQueue();
    expect(viewModel.deleteTeam.completed, isTrue);
    expect(viewModel.teams, [metagross]);

    await viewModel.undoDelete.execute();
    await pumpEventQueue();
    expect(viewModel.teams, [bigSix, metagross]);
  });

  test('a failed delete reports an error and keeps the team', () async {
    await pumpEventQueue();
    repository.failWith = Exception('disk full');

    await viewModel.deleteTeam.execute(bigSix);
    await pumpEventQueue();

    expect(viewModel.deleteTeam.error, isTrue);
    expect(viewModel.teams, [bigSix, metagross]);
  });

  group('sample teams', () {
    test("labels the action with the format's name", () {
      expect(viewModel.sampleTeamsLabel, 'Add Reg M-C sample teams');
    });

    test('adds every sample team, checked, with full sets', () async {
      final empty = FakeTeamRepository();
      final teams = create(empty);
      addTearDown(teams.dispose);

      await teams.addSampleTeams.execute();

      expect(teams.addSampleTeams.completed, isTrue);
      final saved = await empty.watchAll().first;
      expect(saved.map((t) => t.name), [
        'Big Six',
        'Mega Metagross (Worlds 2026)',
        'Rillaboom / Sneasler Grassy Offense',
      ]);
      expect(saved.every((t) => t.pokemon.length == 6), isTrue);
      expect(saved.every((t) => t.sets.length == 6), isTrue);
    });

    test('saves none when any of them fails the checks', () async {
      final empty = FakeTeamRepository();
      final teams = create(
        empty,
        // Only the last sample (Big Six's Garchomp @ Sitrus Berry) fails,
        // so the first two must not have been saved along the way.
        items: FakeItemRepository(
          slugs: {...FakeItemRepository.sampleItems}..remove('sitrus-berry'),
        ),
      );
      addTearDown(teams.dispose);

      await teams.addSampleTeams.execute();

      expect(teams.addSampleTeams.error, isTrue);
      expect(await empty.watchAll().first, isEmpty);
    });

    test('offline: an error, nothing saved', () async {
      final empty = FakeTeamRepository();
      final teams = create(
        empty,
        items: FakeItemRepository()
          ..failWith = const PokeApiNetworkUnavailable('/item'),
      );
      addTearDown(teams.dispose);

      await teams.addSampleTeams.execute();

      expect(teams.addSampleTeams.error, isTrue);
      expect(await empty.watchAll().first, isEmpty);
    });
  });
}
