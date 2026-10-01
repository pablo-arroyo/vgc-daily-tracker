import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/domain/models/game_log.dart';
import 'package:vgc_daily_tracker/domain/models/matchup_note.dart';
import 'package:vgc_daily_tracker/domain/models/mistake_category.dart';
import 'package:vgc_daily_tracker/domain/models/pokemon_ref.dart';
import 'package:vgc_daily_tracker/domain/models/team.dart';
import 'package:vgc_daily_tracker/data/services/pokeapi/poke_api_exception.dart';
import 'package:vgc_daily_tracker/domain/stats/speed_order.dart';
import 'package:vgc_daily_tracker/domain/showdown/showdown_format.dart';
import 'package:vgc_daily_tracker/domain/models/pokemon_set.dart';
import 'package:vgc_daily_tracker/ui/log_game/view_models/log_game_view_model.dart';
import 'package:vgc_daily_tracker/utils/result.dart';

import '../../../../testing/fakes/fake_game_log_repository.dart';
import '../../../../testing/fakes/fake_id_generator.dart';
import '../../../../testing/fakes/fake_matchup_repository.dart';
import '../../../../testing/fakes/fake_pokemon_repository.dart';
import '../../../../testing/fakes/fake_team_repository.dart';
import '../../../../testing/showdown_pastes.dart';

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
  late FakeMatchupRepository matchups;

  setUp(() {
    games = FakeGameLogRepository();
    teams = FakeTeamRepository();
    matchups = FakeMatchupRepository();
  });

  LogGameViewModel create() {
    final viewModel = LogGameViewModel(
      gameLogRepository: games,
      teamRepository: teams,
      pokemonRepository: FakePokemonRepository(),
      matchupRepository: matchups,
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

  group('their team', () {
    final rival = Team(
      id: 'o1',
      name: 'Rival Grassy',
      side: TeamSide.opponent,
      pokemon: [
        for (final slug in [
          'rillaboom',
          'sneasler',
          'incineroar',
          'kingambit',
          'salamence',
          'grimmsnarl',
        ])
          FakePokemonRepository.sampleRef(slug),
      ],
    );
    final garchomp = FakePokemonRepository.sampleRef('garchomp');

    Future<LogGameViewModel> withRival() async {
      teams = FakeTeamRepository(teams: [bigSix, rival]);
      final viewModel = create();
      await pumpEventQueue();
      return viewModel;
    }

    test('offers only the saved opponent teams', () async {
      final viewModel = await withRival();

      expect(viewModel.opponentTeams, [rival]);
    });

    test('picking one fills their 6 slots and clears their brought and '
        'leads', () async {
      final viewModel = await withRival();
      viewModel.setOpponentSlot(0, garchomp);
      viewModel.toggleOpponentBrought(garchomp);

      viewModel.selectOpponentTeam(rival);

      expect(viewModel.selectedOpponentTeam, rival);
      expect(viewModel.opponentSlots, rival.pokemon);
      expect(viewModel.opponentTeam, rival.pokemon);
      expect(viewModel.opponentBrought, isEmpty);
    });

    test('its slots stay editable, and the game stays linked', () async {
      final viewModel = await withRival();
      viewModel.selectOpponentTeam(rival);

      viewModel.setOpponentSlot(5, garchomp);

      expect(viewModel.opponentTeam.last, garchomp);
      expect(viewModel.selectedOpponentTeam, rival);
    });

    test('picking none unlinks the team but keeps the Pokémon', () async {
      final viewModel = await withRival();
      viewModel.selectOpponentTeam(rival);

      viewModel.selectOpponentTeam(null);

      expect(viewModel.selectedOpponentTeam, isNull);
      expect(viewModel.opponentTeam, rival.pokemon);
    });

    test('the saved game records it, and the form resets', () async {
      final viewModel = await withRival();
      viewModel
        ..setResult(GameResult.win)
        ..selectOpponentTeam(rival);

      await viewModel.save.execute();

      final [game] = await games.watchAll().first;
      expect(game.opponentTeamId, 'o1');
      expect(game.opponentTeamName, 'Rival Grassy');
      expect(game.opponentTeam.first, 'rillaboom');
      expect(viewModel.selectedOpponentTeam, isNull);
      expect(viewModel.opponentSlots, everyElement(isNull));
    });
  });

  group('game plan', () {
    final rival = Team(
      id: 'o1',
      name: 'Rival Grassy',
      side: TeamSide.opponent,
      notes: 'Fake Out Sneasler turn 1.',
      pokemon: [FakePokemonRepository.sampleRef('rillaboom')],
    );
    final plan = MatchupNote(
      myTeamId: 't1',
      opponentTeamId: 'o1',
      notes: 'Lead Whimsicott.',
      updatedAt: DateTime.utc(2026, 9, 30),
    );

    Future<LogGameViewModel> ready({List<MatchupNote> notes = const []}) async {
      teams = FakeTeamRepository(teams: [bigSix, rival]);
      matchups = FakeMatchupRepository(notes: notes);
      final viewModel = create();
      await pumpEventQueue();
      return viewModel;
    }

    test('only once their team is picked, with its notes', () async {
      final viewModel = await ready();
      expect(viewModel.showGamePlan, isFalse);

      viewModel.selectOpponentTeam(rival);

      expect(viewModel.showGamePlan, isTrue);
      expect(viewModel.opponentTeamNotes, 'Fake Out Sneasler turn 1.');
      expect(viewModel.matchupNotes, isNull, reason: 'no team of yours yet');
    });

    test('with your team picked too, the plan for that matchup', () async {
      final viewModel = await ready(notes: [plan]);

      viewModel
        ..selectOpponentTeam(rival)
        ..selectTeam(bigSix);

      expect(viewModel.matchupTitle, 'Big Six vs Rival Grassy');
      expect(viewModel.matchupNotes, 'Lead Whimsicott.');
    });

    test('an empty plan when none was written yet', () async {
      final viewModel = await ready();

      viewModel
        ..selectOpponentTeam(rival)
        ..selectTeam(bigSix);

      expect(viewModel.matchupNotes, '');
    });

    test('notes saved elsewhere show up live', () async {
      final viewModel = await ready();
      viewModel
        ..selectOpponentTeam(rival)
        ..selectTeam(bigSix);

      await matchups.save(plan);
      await teams.save(rival.copyWith(notes: 'Watch for Trick Room.'));
      await pumpEventQueue();

      expect(viewModel.matchupNotes, 'Lead Whimsicott.');
      expect(viewModel.opponentTeamNotes, 'Watch for Trick Room.');
    });

    test('saving the matchup plan stores it for the pair, trimmed', () async {
      final viewModel = await ready();
      viewModel
        ..selectOpponentTeam(rival)
        ..selectTeam(bigSix);
      final now = DateTime.utc(2026, 10, 1, 9);

      await withClock(
        Clock.fixed(now),
        () => viewModel.saveMatchupNotes.execute('  Tailwind turn 1.  '),
      );
      await pumpEventQueue();

      expect(await matchups.watchAll().first, [
        MatchupNote(
          myTeamId: 't1',
          opponentTeamId: 'o1',
          notes: 'Tailwind turn 1.',
          updatedAt: now,
        ),
      ]);
      expect(viewModel.matchupNotes, 'Tailwind turn 1.');
    });
  });

  group("adding a game's notes to the plan", () {
    final rival = Team(
      id: 'o1',
      name: 'Rival Grassy',
      side: TeamSide.opponent,
      notes: 'Fake Out Sneasler turn 1.',
      pokemon: [FakePokemonRepository.sampleRef('rillaboom')],
    );
    // 2026-09-30 22:00 in UTC-6: already Oct 1 in UTC.
    final lateEvening = DateTime.utc(2026, 10, 1, 4);
    DateTime costaRica(DateTime utc) => utc.subtract(const Duration(hours: 6));

    LogGameViewModel withTeams({List<MatchupNote> notes = const []}) {
      teams = FakeTeamRepository(teams: [bigSix, rival]);
      matchups = FakeMatchupRepository(notes: notes);
      final viewModel = LogGameViewModel(
        gameLogRepository: games,
        teamRepository: teams,
        pokemonRepository: FakePokemonRepository(),
        matchupRepository: matchups,
        idGenerator: SequentialIdGenerator(),
        toLocal: costaRica,
      );
      addTearDown(viewModel.dispose);
      return viewModel;
    }

    /// Logs a loss against [rival], with your team when [withMine].
    Future<void> logAgainstRival(
      LogGameViewModel viewModel, {
      bool withMine = true,
      String notes = 'Lost the speed tie: Tailwind first.',
    }) async {
      await pumpEventQueue();
      viewModel
        ..setResult(GameResult.loss)
        ..selectOpponentTeam(rival)
        ..setNotes(notes);
      if (withMine) {
        viewModel.selectTeam(bigSix);
        for (final p in bigSix.pokemon.take(4)) {
          viewModel.toggleBrought(p);
        }
        for (final p in bigSix.pokemon.take(2)) {
          viewModel.toggleLead(p);
        }
      }
      await withClock(Clock.fixed(lateEvening), viewModel.save.execute);
      await pumpEventQueue();
    }

    test(
      'is offered after a game against a saved opponent team with notes',
      () async {
        final viewModel = withTeams();
        expect(viewModel.canAddLastGameToNotes, isFalse);

        await logAgainstRival(viewModel);

        expect(viewModel.canAddLastGameToNotes, isTrue);
        expect(viewModel.addToNotesLabel, 'Add to matchup notes');
      },
    );

    test('not for a game without notes', () async {
      final viewModel = withTeams();

      await logAgainstRival(viewModel, notes: '  ');

      expect(viewModel.canAddLastGameToNotes, isFalse);
    });

    test('appends the dated note to the matchup plan', () async {
      final viewModel = withTeams(
        notes: [
          MatchupNote(
            myTeamId: 't1',
            opponentTeamId: 'o1',
            notes: 'Lead Whimsicott.',
            updatedAt: DateTime.utc(2026, 9, 1),
          ),
        ],
      );
      await logAgainstRival(viewModel);

      await withClock(
        Clock.fixed(lateEvening),
        viewModel.addLastGameToNotes.execute,
      );

      expect(
        (viewModel.addLastGameToNotes.result! as Ok<String>).value,
        'Big Six vs Rival Grassy',
      );
      final [plan] = await matchups.watchAll().first;
      expect(
        plan.notes,
        'Lead Whimsicott.\n2026-09-30: Lost the speed tie: Tailwind first.',
      );
      expect(plan.updatedAt, lateEvening);
    });

    test('starts the plan when there was none', () async {
      final viewModel = withTeams();
      await logAgainstRival(viewModel);

      await viewModel.addLastGameToNotes.execute();

      expect(
        (await matchups.watchAll().first).single.notes,
        '2026-09-30: Lost the speed tie: Tailwind first.',
      );
    });

    test("without your team, it goes to their team's notes", () async {
      final viewModel = withTeams();
      await logAgainstRival(viewModel, withMine: false);
      expect(viewModel.addToNotesLabel, 'Add to their notes');

      await viewModel.addLastGameToNotes.execute();

      expect(
        (viewModel.addLastGameToNotes.result! as Ok<String>).value,
        "Rival Grassy's notes",
      );
      final saved = (await teams.watchAll().first).firstWhere(
        (t) => t.id == 'o1',
      );
      expect(
        saved,
        rival.copyWith(
          notes:
              'Fake Out Sneasler turn 1.\n'
              '2026-09-30: Lost the speed tie: Tailwind first.',
        ),
      );
      expect(await matchups.watchAll().first, isEmpty);
    });

    test('their team deleted meanwhile: says so, saves nothing', () async {
      final viewModel = withTeams();
      await logAgainstRival(viewModel, withMine: false);
      await teams.delete('o1');
      await pumpEventQueue();

      await viewModel.addLastGameToNotes.execute();

      expect(viewModel.addLastGameToNotes.error, isTrue);
      expect((await teams.watchAll().first).map((t) => t.id), ['t1']);
    });

    test('a failed save is an error', () async {
      final viewModel = withTeams();
      await logAgainstRival(viewModel);
      matchups.failWith = Exception('disk full');

      await viewModel.addLastGameToNotes.execute();

      expect(viewModel.addLastGameToNotes.error, isTrue);
    });
  });

  group('best-of-3', () {
    final rival = Team(
      id: 'o1',
      name: 'Rival Grassy',
      side: TeamSide.opponent,
      pokemon: [
        for (final slug in ['rillaboom', 'sneasler', 'incineroar'])
          FakePokemonRepository.sampleRef(slug),
      ],
    );

    Future<LogGameViewModel> ready() async {
      teams = FakeTeamRepository(teams: [bigSix, rival]);
      final viewModel = create();
      await pumpEventQueue();
      return viewModel;
    }

    /// Picks the result and, with your team picked, its 4 + 2, then saves.
    Future<void> play(LogGameViewModel viewModel, GameResult result) async {
      viewModel.setResult(result);
      if (viewModel.selectedTeam case final team?) {
        for (final p in team.pokemon.take(4)) {
          viewModel.toggleBrought(p);
        }
        for (final p in team.pokemon.take(2)) {
          viewModel.toggleLead(p);
        }
      }
      await viewModel.save.execute();
      await pumpEventQueue();
    }

    Future<List<GameLog>> logged() async =>
        (await games.watchAll().first).reversed.toList();

    test('game 1 starts a set, shown as open with its score', () async {
      final viewModel = await ready();
      viewModel
        ..setPartOfSet(true)
        ..selectTeam(bigSix)
        ..selectOpponentTeam(rival);

      await play(viewModel, GameResult.win);

      final [game] = await logged();
      expect(game.setId, isNotNull);
      expect(game.setGame, 1);
      expect(viewModel.openSetTitle, 'Best-of-3 vs Rival Grassy · 1–0');
      expect(viewModel.nextSetGame, 2);
      expect(viewModel.partOfSet, isFalse, reason: 'the form reset');
    });

    test('without the checkbox a game is a single game', () async {
      final viewModel = await ready();

      await play(viewModel, GameResult.win);

      expect((await logged()).single.setId, isNull);
      expect(viewModel.openSetTitle, isNull);
    });

    test(
      '"Log game 2" keeps both teams, clears the rest, continues the set',
      () async {
        final viewModel = await ready();
        viewModel
          ..setPartOfSet(true)
          ..selectTeam(bigSix)
          ..selectOpponentTeam(rival)
          ..setNotes('Game 1 notes');
        await play(viewModel, GameResult.win);

        await viewModel.logNextGame.execute();

        expect(viewModel.continuingSetGame, 2);
        expect(viewModel.selectedTeam, bigSix);
        expect(viewModel.selectedOpponentTeam, rival);
        expect(viewModel.opponentTeam, rival.pokemon);
        expect(viewModel.brought, isEmpty);
        expect(viewModel.result, isNull);
        expect(viewModel.notes, '');

        await play(viewModel, GameResult.loss);

        final [first, second] = await logged();
        expect(second.setId, first.setId);
        expect(second.setGame, 2);
        expect(viewModel.openSetTitle, 'Best-of-3 vs Rival Grassy · 1–1');
      },
    );

    test(
      "their typed Pokémon carry over when they aren't a saved team",
      () async {
        final viewModel = await ready();
        final typed = [
          FakePokemonRepository.sampleRef('garchomp'),
          FakePokemonRepository.sampleRef('kingambit'),
        ];
        viewModel
          ..setPartOfSet(true)
          ..setOpponentSlot(0, typed[0])
          ..setOpponentSlot(1, typed[1]);
        await play(viewModel, GameResult.win);
        expect(viewModel.openSetTitle, 'Best-of-3 · 1–0');

        await viewModel.logNextGame.execute();

        expect(viewModel.opponentTeam, typed);
        expect(viewModel.selectedOpponentTeam, isNull);
      },
    );

    test('the set closes itself at 2 wins, with the result', () async {
      final viewModel = await ready();
      viewModel.setPartOfSet(true);
      await play(viewModel, GameResult.win);
      await viewModel.logNextGame.execute();
      await play(viewModel, GameResult.loss);
      await viewModel.logNextGame.execute();

      await play(viewModel, GameResult.win);

      expect(viewModel.lastSetResult, 'Set won 2–1');
      expect(viewModel.openSetTitle, isNull);
    });

    test('2 losses lose the set', () async {
      final viewModel = await ready();
      viewModel.setPartOfSet(true);
      await play(viewModel, GameResult.loss);
      await viewModel.logNextGame.execute();

      await play(viewModel, GameResult.loss);

      expect(viewModel.lastSetResult, 'Set lost 0–2');
      expect(viewModel.openSetTitle, isNull);
    });

    test('"End set" closes it early', () async {
      final viewModel = await ready();
      viewModel.setPartOfSet(true);
      await play(viewModel, GameResult.win);

      await viewModel.endSet.execute();
      await pumpEventQueue();

      expect(viewModel.openSetTitle, isNull);
      expect((await logged()).single.endsSet, isTrue);
    });

    test('a single game in between leaves the set unfinished', () async {
      final viewModel = await ready();
      viewModel.setPartOfSet(true);
      await play(viewModel, GameResult.win);

      await play(viewModel, GameResult.loss);

      expect(viewModel.openSetTitle, isNull);
    });

    test('an open set is still open after a restart', () async {
      final first = await ready();
      first.setPartOfSet(true);
      await play(first, GameResult.win);

      final restarted = create();
      await pumpEventQueue();

      expect(restarted.openSetTitle, 'Best-of-3 · 1–0');
    });
  });

  group('speed matchups', () {
    const ref = FakePokemonRepository.sampleRef;
    final team1 = Team(
      id: 'w1',
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
    final rival = Team(
      id: 'o1',
      name: 'Rival Grassy',
      side: TeamSide.opponent,
      pokemon: [ref('sneasler'), ref('rillaboom')],
    );

    Future<LogGameViewModel> ready({FakePokemonRepository? pokemon}) async {
      teams = FakeTeamRepository(teams: [team1, rival]);
      final viewModel = LogGameViewModel(
        gameLogRepository: games,
        teamRepository: teams,
        pokemonRepository: pokemon ?? FakePokemonRepository(),
        matchupRepository: matchups,
        idGenerator: SequentialIdGenerator(),
      );
      addTearDown(viewModel.dispose);
      await pumpEventQueue();
      return viewModel;
    }

    List<String> names(LogGameViewModel viewModel) => [
      for (final e in viewModel.speedEntries) e.name,
    ];

    test('nothing until your team and their Pokémon are both there', () async {
      final viewModel = await ready();
      viewModel.selectTeam(team1);
      await pumpEventQueue();

      expect(viewModel.speedEntries, isEmpty);
    });

    test('both teams in Speed order, with Megas and ranges', () async {
      final viewModel = await ready();

      viewModel
        ..selectTeam(team1)
        ..selectOpponentTeam(rival);
      await pumpEventQueue();

      expect(names(viewModel), [
        'Raichu-Mega-Y',
        'Sneasler',
        'Whimsicott',
        'Metagross-Mega',
        'Rillaboom',
        'Kleavor',
        'Basculegion-Male',
        'Kingambit',
      ]);
      final sneasler = viewModel.speedEntries[1];
      expect(
        (sneasler.side, sneasler.min, sneasler.max),
        (SpeedSide.theirs, 140, 189),
      );
    });

    test('each row reads as one line: name, side, speed or range', () async {
      final viewModel = await ready();

      viewModel
        ..selectTeam(team1)
        ..selectOpponentTeam(rival);
      await pumpEventQueue();

      expect(viewModel.speedRows.take(2), [
        'Raichu-Mega-Y · yours · 200',
        'Sneasler · theirs · 140–189',
      ]);
    });

    test('the mode reorders: Trick Room puts the slowest first', () async {
      final viewModel = await ready();
      viewModel
        ..selectTeam(team1)
        ..selectOpponentTeam(rival);
      await pumpEventQueue();

      viewModel.setSpeedMode(SpeedMode.trickRoom);

      expect(viewModel.speedMode, SpeedMode.trickRoom);
      expect(names(viewModel).first, 'Kingambit');
    });

    test('recomputes when their Pokémon change', () async {
      final viewModel = await ready();
      viewModel
        ..selectTeam(team1)
        ..selectOpponentTeam(rival);
      await pumpEventQueue();

      viewModel.setOpponentSlot(2, ref('garchomp'));
      await pumpEventQueue();

      expect(names(viewModel), contains('Garchomp'));
    });

    test('a failed lookup says the speeds are unavailable', () async {
      final pokemon = FakePokemonRepository()
        ..failWith = const PokeApiNetworkUnavailable('/pokemon');
      final viewModel = await ready(pokemon: pokemon);

      viewModel
        ..selectTeam(team1)
        ..selectOpponentTeam(rival);
      await pumpEventQueue();

      expect(viewModel.speedEntries, isEmpty);
      expect(viewModel.speedUnavailable, isTrue);
    });
  });

  group('your team', () {
    test("never offers an opponent's team as yours", () async {
      final rival = bigSix.copyWith(
        id: 'o1',
        name: 'Rival',
        side: TeamSide.opponent,
      );
      teams = FakeTeamRepository(teams: [bigSix, rival]);
      final viewModel = create();
      await pumpEventQueue();

      expect(viewModel.teams, [bigSix]);
    });

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

    test('search passes a failure on, so the field can explain it', () async {
      final failing = FakePokemonRepository()..failWith = Exception('offline');
      final viewModel = LogGameViewModel(
        gameLogRepository: games,
        teamRepository: teams,
        pokemonRepository: failing,
        matchupRepository: matchups,
        idGenerator: SequentialIdGenerator(),
      );
      addTearDown(viewModel.dispose);

      expect(await viewModel.search('rilla'), isA<Failure<List<PokemonRef>>>());
    });

    test('search suggests Pokémon for the opponent slots', () async {
      final results = await create().search('rilla');

      expect((results as Ok<List<PokemonRef>>).value, [rilla]);
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
