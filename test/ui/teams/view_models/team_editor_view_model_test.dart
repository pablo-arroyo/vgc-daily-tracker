import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/domain/models/pokemon_ref.dart';
import 'package:vgc_daily_tracker/domain/models/team.dart';
import 'package:vgc_daily_tracker/ui/teams/view_models/team_editor_view_model.dart';
import 'package:vgc_daily_tracker/utils/result.dart';

import '../../../../testing/fakes/fake_id_generator.dart';
import '../../../../testing/fakes/fake_pokemon_repository.dart';
import '../../../../testing/fakes/fake_team_repository.dart';

void main() {
  PokemonRef ref(String slug) {
    final p = FakePokemonRepository.samplePokemon.singleWhere(
      (p) => p.slug == slug,
    );
    return PokemonRef(id: p.id, slug: p.slug, displayName: p.displayName);
  }

  final bigSix = [
    ref('kingambit'),
    ref('whimsicott'),
    ref('garchomp'),
    ref('incineroar'),
    ref('rillaboom'),
    ref('charizard'),
  ];

  late FakeTeamRepository teams;
  late FakePokemonRepository pokemon;

  setUp(() {
    teams = FakeTeamRepository();
    pokemon = FakePokemonRepository();
  });

  TeamEditorViewModel create({String? teamId}) {
    final viewModel = TeamEditorViewModel(
      teamRepository: teams,
      pokemonRepository: pokemon,
      idGenerator: SequentialIdGenerator(),
      teamId: teamId,
    );
    addTearDown(viewModel.dispose);
    return viewModel;
  }

  void fill(TeamEditorViewModel viewModel, String name, List<PokemonRef?> six) {
    viewModel.setName(name);
    for (final (i, pick) in six.indexed) {
      viewModel.setSlot(i, pick);
    }
  }

  test('saves a new team with a generated id', () async {
    final viewModel = create();
    fill(viewModel, 'Big Six', bigSix);

    await viewModel.save.execute();

    expect(viewModel.save.completed, isTrue);
    expect(await teams.watchAll().first, [
      Team(id: 'id-1', name: 'Big Six', pokemon: bigSix),
    ]);
  });

  group('rejects an invalid team without saving it', () {
    Future<String> rejectionOf(TeamEditorViewModel viewModel) async {
      await viewModel.save.execute();
      expect(await teams.watchAll().first, isEmpty, reason: 'nothing saved');
      final error = (viewModel.save.result! as Failure<void>).error;
      return (error as TeamValidationError).message;
    }

    test('a blank name', () async {
      final viewModel = create();
      fill(viewModel, '   ', bigSix);

      expect(await rejectionOf(viewModel), 'Give the team a name.');
    });

    test('fewer than six Pokémon', () async {
      final viewModel = create();
      fill(viewModel, 'Big Six', [...bigSix.take(5), null]);

      expect(await rejectionOf(viewModel), 'Pick all 6 Pokémon.');
    });

    test('the same Pokémon twice', () async {
      final viewModel = create();
      fill(viewModel, 'Big Six', [...bigSix.take(5), ref('kingambit')]);

      expect(await rejectionOf(viewModel), 'Kingambit is on the team twice.');
    });

    test('two forms of one species (the species clause)', () async {
      final viewModel = create();
      fill(viewModel, 'Big Six', [...bigSix.take(5), ref('charizard-mega-y')]);
      viewModel.setSlot(0, ref('charizard'));

      expect(
        await rejectionOf(viewModel),
        'Charizard-Mega-Y is the same species as Charizard.',
      );
    });
  });

  test(
    'offline, skips the species check rather than blocking the save',
    () async {
      pokemon.failWith = Exception('offline');
      final viewModel = create();
      fill(viewModel, 'Big Six', [...bigSix.take(5), ref('charizard-mega-y')]);
      viewModel.setSlot(0, ref('charizard'));

      await viewModel.save.execute();

      expect(viewModel.save.completed, isTrue);
    },
  );

  group('search', () {
    test('returns matching Pokémon for the autocomplete', () async {
      final viewModel = create();

      final results = await viewModel.search('chariz');

      expect(results.map((r) => r.slug), ['charizard', 'charizard-mega-y']);
    });

    test('returns nothing when search fails', () async {
      pokemon.failWith = Exception('offline');
      final viewModel = create();

      expect(await viewModel.search('chariz'), isEmpty);
    });
  });

  group('editing an existing team', () {
    final existing = Team(id: 't9', name: 'Big Six', pokemon: bigSix);

    test('a new team is ready at once', () {
      expect(create().loaded, isTrue);
    });

    test('loads the team and pre-fills the form', () async {
      teams = FakeTeamRepository(teams: [existing]);
      final viewModel = create(teamId: 't9');
      expect(viewModel.loaded, isFalse);

      await pumpEventQueue();

      expect(viewModel.loaded, isTrue);
      expect(viewModel.name, 'Big Six');
      expect(viewModel.slots, bigSix);
    });

    test('saving replaces the team under the same id', () async {
      teams = FakeTeamRepository(teams: [existing]);
      final viewModel = create(teamId: 't9');
      await pumpEventQueue();

      viewModel.setName('Big Six (Worlds)');
      await viewModel.save.execute();

      expect(await teams.watchAll().first, [
        existing.copyWith(name: 'Big Six (Worlds)'),
      ]);
    });

    test('a team that no longer exists is reported, not a crash', () async {
      final viewModel = create(teamId: 'deleted');

      await pumpEventQueue();

      expect(viewModel.loaded, isTrue);
      expect(viewModel.missing, isTrue);
    });
  });
}
