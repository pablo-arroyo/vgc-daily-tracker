import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/domain/models/game_log.dart';
import 'package:vgc_daily_tracker/domain/models/mistake_category.dart';
import 'package:vgc_daily_tracker/domain/models/team.dart';
import 'package:vgc_daily_tracker/ui/log_game/view_models/log_game_view_model.dart';
import 'package:vgc_daily_tracker/utils/result.dart';

import '../../../../testing/fakes/fake_game_log_repository.dart';
import '../../../../testing/fakes/fake_id_generator.dart';
import '../../../../testing/fakes/fake_pokemon_repository.dart';
import '../../../../testing/fakes/fake_team_repository.dart';

final bigSix = Team(
  id: 't1',
  name: 'Big Six',
  pokemon: [
    for (final slug in [
      'kingambit',
      'whimsicott',
      'garchomp',
      'incineroar',
      'rillaboom',
      'charizard',
    ])
      FakePokemonRepository.sampleRef(slug),
  ],
);

void main() {
  late FakeGameLogRepository games;
  late FakeTeamRepository teams;

  setUp(() {
    games = FakeGameLogRepository();
    teams = FakeTeamRepository();
  });

  LogGameViewModel create() {
    final viewModel = LogGameViewModel(
      gameLogRepository: games,
      teamRepository: teams,
      pokemonRepository: FakePokemonRepository(),
      idGenerator: SequentialIdGenerator(),
    );
    addTearDown(viewModel.dispose);
    return viewModel;
  }

  String rejection(LogGameViewModel viewModel) =>
      ((viewModel.save.result! as Failure<void>).error
              as LogGameValidationError)
          .message;

  group('saving', () {
    test('needs Win or Loss first', () async {
      final viewModel = create();

      await viewModel.save.execute();

      expect(rejection(viewModel), 'Pick Win or Loss first.');
      expect(await games.watchAll().first, isEmpty);
    });

    test(
      'stores the game at the current UTC time, then resets the form',
      () async {
        final viewModel = create();
        viewModel.setResult(GameResult.win);

        await withClock(
          Clock.fixed(DateTime.utc(2026, 9, 30, 21, 15)),
          viewModel.save.execute,
        );

        expect(viewModel.save.completed, isTrue);
        expect(await games.watchAll().first, [
          GameLog(
            id: 'id-1',
            playedAt: DateTime.utc(2026, 9, 30, 21, 15),
            result: GameResult.win,
          ),
        ]);
        expect(viewModel.result, isNull, reason: 'form reset');
      },
    );
  });

  group('your team', () {
    test('offers the saved teams and lets you pick one or none', () async {
      teams = FakeTeamRepository(teams: [bigSix]);
      final viewModel = create();
      await pumpEventQueue();

      expect(viewModel.teams, [bigSix]);
      viewModel.selectTeam(bigSix);
      expect(viewModel.selectedTeam, bigSix);
      viewModel.selectTeam(null);
      expect(viewModel.selectedTeam, isNull);
    });

    test('brings up to 4; the 5th is refused', () async {
      final viewModel = create()..selectTeam(bigSix);
      final [a, b, c, d, e, _] = bigSix.pokemon;

      for (final p in [a, b, c, d]) {
        expect(viewModel.toggleBrought(p), isNull);
      }
      expect(viewModel.toggleBrought(e), 'Only 4 Pokémon can be brought.');

      expect(viewModel.brought, [a, b, c, d]);
    });

    test('tapping a brought Pokémon again un-brings it', () async {
      final viewModel = create()..selectTeam(bigSix);
      final kingambit = bigSix.pokemon.first;

      viewModel.toggleBrought(kingambit);
      viewModel.toggleBrought(kingambit);

      expect(viewModel.brought, isEmpty);
    });

    test('choosing another team clears the picks', () async {
      final viewModel = create()..selectTeam(bigSix);
      viewModel.toggleBrought(bigSix.pokemon.first);

      viewModel.selectTeam(null);

      expect(viewModel.brought, isEmpty);
    });

    group('leads', () {
      LogGameViewModel withFourBrought() {
        final viewModel = create()..selectTeam(bigSix);
        bigSix.pokemon.take(4).forEach(viewModel.toggleBrought);
        return viewModel;
      }

      test('need all 4 brought first, and come from them', () async {
        final viewModel = create()..selectTeam(bigSix);
        final [a, b, c, d, e, _] = bigSix.pokemon;
        viewModel.toggleBrought(a);

        expect(viewModel.toggleLead(a), 'Pick your 4 brought Pokémon first.');
        [b, c, d].forEach(viewModel.toggleBrought);
        expect(viewModel.toggleLead(e), 'Leads must be among the 4 brought.');
        expect(viewModel.toggleLead(a), isNull);
        expect(viewModel.leads, [a]);
      });

      test('up to 2; the 3rd is refused', () async {
        final viewModel = withFourBrought();
        final [a, b, c, _, _, _] = bigSix.pokemon;

        viewModel.toggleLead(a);
        viewModel.toggleLead(b);

        expect(viewModel.toggleLead(c), 'Only 2 Pokémon can lead.');
        expect(viewModel.leads, [a, b]);
      });

      test('un-bringing a lead also drops it as a lead', () async {
        final viewModel = withFourBrought();
        final kingambit = bigSix.pokemon.first;
        viewModel.toggleLead(kingambit);

        viewModel.toggleBrought(kingambit);

        expect(viewModel.leads, isEmpty);
      });

      test('choosing another team clears them', () async {
        final viewModel = withFourBrought();
        viewModel.toggleLead(bigSix.pokemon.first);

        viewModel.selectTeam(bigSix);

        expect(viewModel.leads, isEmpty);
      });
    });
  });

  group('saving with your team', () {
    test('needs exactly 4 brought, then exactly 2 leads', () async {
      final viewModel = create()
        ..setResult(GameResult.loss)
        ..selectTeam(bigSix);
      final [a, b, c, d, _, _] = bigSix.pokemon;
      [a, b, c].forEach(viewModel.toggleBrought);

      await viewModel.save.execute();
      expect(
        rejection(viewModel),
        'Pick exactly 4 brought Pokémon for your team.',
      );

      viewModel
        ..toggleBrought(d)
        ..toggleLead(a)
        ..toggleLead(b)
        ..toggleLead(b); // un-pick: back to one lead
      await viewModel.save.execute();
      expect(rejection(viewModel), 'Pick exactly 2 leads for your team.');
      expect(await games.watchAll().first, isEmpty);
    });

    test('stores the team id, its name and every pick as slugs', () async {
      final viewModel = create()
        ..setResult(GameResult.loss)
        ..selectTeam(bigSix);
      final [a, b, c, d, _, _] = bigSix.pokemon;
      [a, b, c, d].forEach(viewModel.toggleBrought);
      viewModel
        ..toggleLead(b)
        ..toggleLead(a);

      await withClock(
        Clock.fixed(DateTime.utc(2026, 9, 30, 21)),
        viewModel.save.execute,
      );

      final [saved] = await games.watchAll().first;
      expect(saved.teamId, 't1');
      expect(saved.teamName, 'Big Six');
      expect(saved.team, [for (final p in bigSix.pokemon) p.slug]);
      expect(saved.brought, [
        'kingambit',
        'whimsicott',
        'garchomp',
        'incineroar',
      ]);
      expect(saved.leads, ['whimsicott', 'kingambit']);
      expect(viewModel.selectedTeam, isNull, reason: 'form reset');
      expect(viewModel.brought, isEmpty);
    });
  });

  group('the opponent', () {
    final [rilla, incin, king, whim, garch, raichu] = [
      for (final slug in [
        'rillaboom',
        'incineroar',
        'kingambit',
        'whimsicott',
        'garchomp',
        'raichu-mega-y',
      ])
        FakePokemonRepository.sampleRef(slug),
    ];

    LogGameViewModel withFullOpponent() {
      final viewModel = create();
      for (final (i, p) in [rilla, incin, king, whim, garch, raichu].indexed) {
        viewModel.setOpponentSlot(i, p);
      }
      return viewModel;
    }

    test('has six slots; their team is the filled ones', () async {
      final viewModel = create()
        ..setOpponentSlot(0, rilla)
        ..setOpponentSlot(3, king);

      expect(viewModel.opponentTeam, [rilla, king]);
    });

    test('brought: up to 4, from their team', () async {
      final viewModel = withFullOpponent();

      for (final p in [rilla, incin, king, whim]) {
        expect(viewModel.toggleOpponentBrought(p), isNull);
      }
      expect(
        viewModel.toggleOpponentBrought(garch),
        'Only 4 can be marked as brought.',
      );
      expect(viewModel.opponentBrought, [rilla, incin, king, whim]);
    });

    test('leads: up to 2, from their brought', () async {
      final viewModel = withFullOpponent()
        ..toggleOpponentBrought(rilla)
        ..toggleOpponentBrought(incin)
        ..toggleOpponentBrought(king);

      expect(
        viewModel.toggleOpponentLead(garch),
        'Leads must be among the Pokémon they brought.',
      );
      viewModel
        ..toggleOpponentLead(rilla)
        ..toggleOpponentLead(incin);
      expect(
        viewModel.toggleOpponentLead(king),
        'Only 2 can be marked as lead.',
      );
      expect(viewModel.opponentLeads, [rilla, incin]);
    });

    test('clearing a slot drops that Pokémon from brought and leads', () async {
      final viewModel = withFullOpponent()
        ..toggleOpponentBrought(rilla)
        ..toggleOpponentLead(rilla);

      viewModel.setOpponentSlot(0, null);

      expect(viewModel.opponentTeam, isNot(contains(rilla)));
      expect(viewModel.opponentBrought, isEmpty);
      expect(viewModel.opponentLeads, isEmpty);
    });

    test('is stored as slugs', () async {
      final viewModel = withFullOpponent()
        ..setResult(GameResult.win)
        ..toggleOpponentBrought(rilla)
        ..toggleOpponentBrought(incin)
        ..toggleOpponentLead(rilla);

      await viewModel.save.execute();

      final [saved] = await games.watchAll().first;
      expect(saved.opponentTeam, [
        'rillaboom',
        'incineroar',
        'kingambit',
        'whimsicott',
        'garchomp',
        'raichu-mega-y',
      ]);
      expect(saved.opponentBrought, ['rillaboom', 'incineroar']);
      expect(saved.opponentLeads, ['rillaboom']);
      expect(viewModel.opponentTeam, isEmpty, reason: 'form reset');
    });

    test('un-marking a brought Pokémon also drops it as a lead', () async {
      final viewModel = withFullOpponent()
        ..toggleOpponentBrought(rilla)
        ..toggleOpponentLead(rilla);

      viewModel.toggleOpponentBrought(rilla);

      expect(viewModel.opponentLeads, isEmpty);
    });

    test('search returns nothing when it fails', () async {
      final failing = FakePokemonRepository()..failWith = Exception('offline');
      final viewModel = LogGameViewModel(
        gameLogRepository: games,
        teamRepository: teams,
        pokemonRepository: failing,
        idGenerator: SequentialIdGenerator(),
      );
      addTearDown(viewModel.dispose);

      expect(await viewModel.search('rilla'), isEmpty);
    });

    test('search suggests Pokémon for the opponent slots', () async {
      final results = await create().search('rilla');

      expect(results, [rilla]);
    });
  });

  group('mistake and notes', () {
    test('are optional, saved when set, and cleared after saving', () async {
      final viewModel = create()
        ..setResult(GameResult.loss)
        ..setMistake(MistakeCategory.speedCalc)
        ..setNotes('  Check Tailwind turns.  ');

      await viewModel.save.execute();

      final [saved] = await games.watchAll().first;
      expect(saved.mistake, MistakeCategory.speedCalc);
      expect(saved.notes, 'Check Tailwind turns.');
      expect(viewModel.mistake, isNull);
      expect(viewModel.notes, isEmpty);
    });
  });

  test('a failed save keeps everything entered', () async {
    games.failWith = Exception('disk full');
    final viewModel = create()
      ..setResult(GameResult.win)
      ..selectTeam(bigSix)
      ..setMistake(MistakeCategory.outplayed);
    bigSix.pokemon.take(4).forEach(viewModel.toggleBrought);
    viewModel
      ..toggleLead(bigSix.pokemon[0])
      ..toggleLead(bigSix.pokemon[1]);

    await viewModel.save.execute();

    expect(viewModel.save.error, isTrue);
    expect(viewModel.result, GameResult.win);
    expect(viewModel.selectedTeam, bigSix);
    expect(viewModel.brought, hasLength(4));
    expect(viewModel.mistake, MistakeCategory.outplayed);
  });
}
