import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/data/services/pokeapi/poke_api_exception.dart';
import 'package:vgc_daily_tracker/domain/models/matchup_note.dart';
import 'package:vgc_daily_tracker/domain/models/nature.dart';
import 'package:vgc_daily_tracker/domain/models/pokemon_set.dart';
import 'package:vgc_daily_tracker/domain/models/stat_spread.dart';
import 'package:vgc_daily_tracker/domain/models/team.dart';
import 'package:vgc_daily_tracker/domain/showdown/showdown_format.dart';
import 'package:vgc_daily_tracker/ui/teams/view_models/team_detail_view_model.dart';
import 'package:vgc_daily_tracker/utils/result.dart';

import '../../../../testing/fakes/fake_matchup_repository.dart';
import '../../../../testing/fakes/fake_pokemon_repository.dart';
import '../../../../testing/fakes/fake_team_repository.dart';
import '../../../../testing/showdown_pastes.dart';

void main() {
  const ref = FakePokemonRepository.sampleRef;

  final team1 = Team(
    id: 't1',
    name: 'Worlds Metagross',
    pokemon: [
      for (final slug in [
        'kingambit',
        'kleavor',
        'metagross',
        'whimsicott',
        'raichu',
        'basculegion-male',
      ])
        ref(slug),
    ],
    sets: (ShowdownFormat.parse(team1Paste) as Ok<List<PokemonSet>>).value,
  );

  late FakePokemonRepository pokemon;

  setUp(() => pokemon = FakePokemonRepository());

  Future<TeamDetailViewModel> load(Team team, {String? teamId}) async {
    final viewModel = TeamDetailViewModel(
      teamRepository: FakeTeamRepository(teams: [team]),
      pokemonRepository: pokemon,
      matchupRepository: FakeMatchupRepository(),
      teamId: teamId ?? team.id,
    );
    addTearDown(viewModel.dispose);
    await viewModel.load.execute();
    return viewModel;
  }

  test('shows each member in its battle form with its stats', () async {
    final viewModel = await load(team1);

    expect(viewModel.load.completed, isTrue);
    expect(viewModel.name, 'Worlds Metagross');
    final metagross = viewModel.members[2];
    expect(metagross.name, 'Metagross-Mega');
    expect(metagross.types, ['steel', 'psychic']);
    expect(metagross.set?.item, 'Metagrossite');
    expect(metagross.stats?.spe, 178);
    expect(viewModel.members[0].name, 'Kingambit');
    expect(viewModel.members[0].stats?.hp, 207);
    expect(viewModel.members[4].name, 'Raichu-Mega-Y');
  });

  test('writes the ability, with the Mega ability after an arrow', () async {
    final viewModel = await load(
      team1.copyWith(
        sets: [
          for (final set in team1.sets)
            set.species == 'Raichu'
                ? set.copyWith(megaAbility: 'No Guard')
                : set,
        ],
      ),
    );

    expect(viewModel.members[0].ability, 'Defiant');
    expect(viewModel.members[4].ability, 'Lightning Rod → No Guard');
  });

  test('lists Speed fastest first, with Mega speeds', () async {
    final viewModel = await load(team1);

    expect(
      [for (final tier in viewModel.speedOrder) (tier.name, tier.speed)],
      [
        ('Raichu-Mega-Y', 200),
        ('Whimsicott', 184),
        ('Metagross-Mega', 178),
        ('Kleavor', 137),
        ('Basculegion-Male', 130),
        ('Kingambit', 70),
      ],
    );
  });

  test('equal speeds keep team order', () async {
    // Base 85 Speed, 252 EVs, neutral nature: 137 each.
    const fast = PokemonSet(
      species: 'X',
      evs: StatSpread(spe: 252),
      nature: Nature.adamant,
    );
    Team team(List<String> slugs) => Team(
      id: 't',
      name: 'Tie',
      pokemon: [for (final slug in slugs) ref(slug)],
      sets: [for (final _ in slugs) fast],
    );

    final rillaFirst = await load(team(['rillaboom', 'kleavor']));
    final kleavorFirst = await load(team(['kleavor', 'rillaboom']));

    expect(rillaFirst.speedOrder.map((t) => t.name), ['Rillaboom', 'Kleavor']);
    expect(kleavorFirst.speedOrder.map((t) => t.name), [
      'Kleavor',
      'Rillaboom',
    ]);
  });

  test('a team without sets shows its Pokémon, no stats', () async {
    final picked = Team(
      id: 'p',
      name: 'Picked',
      pokemon: [ref('kingambit'), ref('charizard-mega-y')],
    );

    final viewModel = await load(picked);

    expect(viewModel.hasSets, isFalse);
    expect(viewModel.members.map((m) => m.name), [
      'Kingambit',
      'Charizard-Mega-Y',
    ]);
    expect(viewModel.members[1].types, ['fire', 'flying']);
    expect(viewModel.members.every((m) => m.stats == null), isTrue);
    expect(viewModel.speedOrder, isEmpty);
  });

  test('a team that no longer exists is missing', () async {
    final viewModel = await load(team1, teamId: 'gone');

    expect(viewModel.missing, isTrue);
    expect(viewModel.members, isEmpty);
  });

  test('a failed lookup is an error, and loading again recovers', () async {
    pokemon.failWith = const PokeApiNetworkUnavailable('/pokemon');
    final viewModel = await load(team1);
    expect(viewModel.load.error, isTrue);

    pokemon.failWith = null;
    await viewModel.load.execute();

    expect(viewModel.load.completed, isTrue);
    expect(viewModel.members, hasLength(6));
  });

  group('notes', () {
    late FakeTeamRepository teams;

    Future<TeamDetailViewModel> withTeam(Team team) async {
      teams = FakeTeamRepository(teams: [team]);
      final viewModel = TeamDetailViewModel(
        teamRepository: teams,
        pokemonRepository: pokemon,
        matchupRepository: FakeMatchupRepository(),
        teamId: team.id,
      );
      addTearDown(viewModel.dispose);
      await viewModel.load.execute();
      return viewModel;
    }

    test("loads the team's notes", () async {
      final viewModel = await withTeam(team1.copyWith(notes: 'Tailwind T1'));

      expect(viewModel.notes, 'Tailwind T1');
    });

    test('saves trimmed notes, keeping everything else on the team', () async {
      final viewModel = await withTeam(team1);

      await viewModel.saveNotes.execute('  Lead Raichu + Whimsicott.\n');

      expect(viewModel.saveNotes.completed, isTrue);
      expect(viewModel.notes, 'Lead Raichu + Whimsicott.');
      expect(await teams.watchAll().first, [
        team1.copyWith(notes: 'Lead Raichu + Whimsicott.'),
      ]);
    });

    test('a failed save keeps the old notes', () async {
      final viewModel = await withTeam(team1.copyWith(notes: 'Old'));
      teams.failWith = Exception('disk full');

      await viewModel.saveNotes.execute('New');

      expect(viewModel.saveNotes.error, isTrue);
      expect(viewModel.notes, 'Old');
    });
  });

  group('matchup notes', () {
    const mine = Team(id: 't1', name: 'Big Six', pokemon: []);
    const rival = Team(
      id: 'o1',
      name: 'Rival Grassy',
      pokemon: [],
      side: TeamSide.opponent,
    );
    const ladder = Team(
      id: 'o2',
      name: 'Ladder Rain',
      pokemon: [],
      side: TeamSide.opponent,
    );
    late FakeMatchupRepository matchups;

    Future<TeamDetailViewModel> open(
      String teamId, {
      List<MatchupNote> notes = const [],
    }) async {
      matchups = FakeMatchupRepository(notes: notes);
      final viewModel = TeamDetailViewModel(
        teamRepository: FakeTeamRepository(teams: [mine, rival, ladder]),
        pokemonRepository: pokemon,
        matchupRepository: matchups,
        teamId: teamId,
      );
      addTearDown(viewModel.dispose);
      await viewModel.load.execute();
      return viewModel;
    }

    final saved = MatchupNote(
      myTeamId: 't1',
      opponentTeamId: 'o1',
      notes: 'Tailwind turn 1.',
      updatedAt: DateTime.utc(2026, 9, 30),
    );

    test('from your team: every opponent team, with its notes', () async {
      final viewModel = await open('t1', notes: [saved]);

      expect(viewModel.matchups, [
        (
          teamId: 'o2',
          teamName: 'Ladder Rain',
          title: 'Big Six vs Ladder Rain',
          notes: '',
        ),
        (
          teamId: 'o1',
          teamName: 'Rival Grassy',
          title: 'Big Six vs Rival Grassy',
          notes: 'Tailwind turn 1.',
        ),
      ]);
    });

    test("from an opponent's team: every team of yours", () async {
      final viewModel = await open('o1', notes: [saved]);

      expect(viewModel.matchups, [
        (
          teamId: 't1',
          teamName: 'Big Six',
          title: 'Big Six vs Rival Grassy',
          notes: 'Tailwind turn 1.',
        ),
      ]);
    });

    test('saving from either side stores your team vs theirs', () async {
      final now = DateTime.utc(2026, 10, 1, 9);
      final fromMine = await open('t1');
      await withClock(
        Clock.fixed(now),
        () => fromMine.saveMatchupNotes.execute((
          teamId: 'o1',
          notes: '  Lead Whimsicott.  ',
        )),
      );

      expect(await matchups.watchAll().first, [
        MatchupNote(
          myTeamId: 't1',
          opponentTeamId: 'o1',
          notes: 'Lead Whimsicott.',
          updatedAt: now,
        ),
      ]);
      expect(fromMine.matchups.last.notes, 'Lead Whimsicott.');

      final fromTheirs = await open('o1');
      await fromTheirs.saveMatchupNotes.execute((teamId: 't1', notes: 'X'));

      final [stored] = await matchups.watchAll().first;
      expect((stored.myTeamId, stored.opponentTeamId), ('t1', 'o1'));
    });

    test('a failed save keeps the old notes', () async {
      final viewModel = await open('t1', notes: [saved]);
      matchups.failWith = Exception('disk full');

      await viewModel.saveMatchupNotes.execute((teamId: 'o1', notes: 'New'));

      expect(viewModel.saveMatchupNotes.error, isTrue);
      expect(viewModel.matchups.last.notes, 'Tailwind turn 1.');
    });
  });
}
