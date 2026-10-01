import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:vgc_daily_tracker/data/services/pokeapi/poke_api_exception.dart';
import 'package:vgc_daily_tracker/domain/models/pokemon_set.dart';
import 'package:vgc_daily_tracker/domain/models/team.dart';
import 'package:vgc_daily_tracker/domain/showdown/showdown_format.dart';
import 'package:vgc_daily_tracker/ui/core/type_badge.dart';
import 'package:vgc_daily_tracker/ui/core/theme/app_theme.dart';
import 'package:vgc_daily_tracker/ui/teams/view_models/team_detail_view_model.dart';
import 'package:vgc_daily_tracker/ui/teams/widgets/team_detail_screen.dart';
import 'package:vgc_daily_tracker/utils/result.dart';

import '../../../../testing/fakes/fake_matchup_repository.dart';
import '../../../../testing/fakes/fake_pokemon_repository.dart';
import '../../../../testing/fakes/fake_team_repository.dart';
import '../../../../testing/fakes/fake_type_repository.dart';
import '../../../../testing/showdown_pastes.dart';
import '../../../../testing/team_import_actions.dart';

void main() {
  const ref = FakePokemonRepository.sampleRef;
  final slugs = [
    'kingambit',
    'kleavor',
    'metagross',
    'whimsicott',
    'raichu',
    'basculegion-male',
  ];
  final imported = Team(
    id: 't1',
    name: 'Worlds Metagross',
    pokemon: [for (final slug in slugs) ref(slug)],
    sets: (ShowdownFormat.parse(team1Paste) as Ok<List<PokemonSet>>).value,
  );
  final picked = Team(
    id: 't2',
    name: 'Picked',
    pokemon: [for (final slug in slugs) ref(slug)],
  );

  Future<FakePokemonRepository> pumpDetail(
    WidgetTester tester, {
    String teamId = 't1',
    FakePokemonRepository? pokemon,
    FakeTeamRepository? teams,
    FakeMatchupRepository? matchups,
    FakeTypeRepository? types,
  }) async {
    tester.view.physicalSize = const Size(1200, 4000);
    // Logical pixels: tall enough to build every lazy row.
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final repository = pokemon ?? FakePokemonRepository();
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: ChangeNotifierProvider(
          create: (_) => TeamDetailViewModel(
            teamRepository:
                teams ?? FakeTeamRepository(teams: [imported, picked]),
            pokemonRepository: repository,
            matchupRepository: matchups ?? FakeMatchupRepository(),
            typeRepository: types ?? FakeTypeRepository(),
            teamId: teamId,
          )..load.execute(),
          child: const TeamDetailScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return repository;
  }

  testWidgets('each member: battle form, types, item, ability, moves, '
      'stats', (tester) async {
    await pumpDetail(tester);

    expect(find.text('Worlds Metagross'), findsOneWidget);
    final metagross = find.ancestor(
      of: find.text('Metagross-Mega').first,
      matching: find.byType(Card),
    );
    Finder inMetagross(Finder finder) =>
        find.descendant(of: metagross, matching: finder);
    expect(inMetagross(find.byType(TypeBadge)), findsNWidgets(2));
    expect(inMetagross(find.text('Metagrossite')), findsOneWidget);
    expect(inMetagross(find.text('Clear Body')), findsOneWidget);
    expect(inMetagross(find.text('Psychic Fangs')), findsOneWidget);
    expect(inMetagross(find.text('178')), findsOneWidget);
    expect(find.text('207'), findsOneWidget); // Kingambit's HP
  });

  testWidgets('screen readers hear each stat in full', (tester) async {
    final semantics = tester.ensureSemantics();
    await pumpDetail(tester);

    expect(find.bySemanticsLabel('Speed 178'), findsOneWidget);
    expect(find.bySemanticsLabel('HP 207'), findsOneWidget);
    semantics.dispose();
  });

  group('matchup notes', () {
    final rival = Team(
      id: 'o1',
      name: 'Rival Grassy',
      side: TeamSide.opponent,
      pokemon: [ref('rillaboom')],
    );

    testWidgets("lists the other side's teams; tapping one edits its notes", (
      tester,
    ) async {
      final matchups = FakeMatchupRepository();
      await pumpDetail(
        tester,
        teams: FakeTeamRepository(teams: [imported, rival]),
        matchups: matchups,
      );
      final row = find.widgetWithText(ListTile, 'Rival Grassy');
      expect(
        find.descendant(of: row, matching: find.text('No notes yet')),
        findsOneWidget,
      );

      await tester.tap(row);
      await tester.pumpAndSettle();
      expect(find.text('Worlds Metagross vs Rival Grassy'), findsOneWidget);
      await tester.enterText(
        find.widgetWithText(TextField, 'Game plan'),
        'Fake Out Rillaboom turn 1.',
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Save'));
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: row,
          matching: find.text('Fake Out Rillaboom turn 1.'),
        ),
        findsOneWidget,
      );
      expect(
        (await matchups.watchAll().first).single.notes,
        'Fake Out Rillaboom turn 1.',
      );
    });

    testWidgets('no teams on the other side: says how to start', (
      tester,
    ) async {
      await pumpDetail(tester);

      expect(
        find.text('Save an opponent team to keep matchup notes against it.'),
        findsOneWidget,
      );
    });
  });

  group('weaknesses', () {
    testWidgets('lists the types that hit the team, with their badges', (
      tester,
    ) async {
      await pumpDetail(tester);

      expect(find.text('Weaknesses'), findsOneWidget);
      final row = find.ancestor(
        of: find.text('Ground · 3 weak · 1 resists'),
        matching: find.byType(Row),
      );
      expect(
        find.descendant(of: row, matching: find.byType(TypeBadge)),
        findsOneWidget,
      );
      expect(
        find.text("Types only: abilities like Levitate aren't counted."),
        findsOneWidget,
      );
    });

    testWidgets('a team without sets has weaknesses too', (tester) async {
      await pumpDetail(tester, teamId: 't2');

      expect(find.text('Weaknesses'), findsOneWidget);
    });

    testWidgets('says so when the type chart is unavailable', (tester) async {
      await pumpDetail(
        tester,
        types: FakeTypeRepository()..failWith = Exception('offline'),
      );

      expect(
        find.text("Couldn't load the type chart. Check your connection."),
        findsOneWidget,
      );
    });
  });

  group('notes', () {
    TextField field(WidgetTester tester) =>
        tester.widget<TextField>(find.widgetWithText(TextField, 'Notes'));

    testWidgets('shows saved notes; Save notes saves them and confirms', (
      tester,
    ) async {
      final teams = FakeTeamRepository(
        teams: [imported.copyWith(notes: 'Tailwind turn 1.')],
      );
      await pumpDetail(tester, teams: teams);
      expect(field(tester).controller?.text, 'Tailwind turn 1.');

      await tester.enterText(
        find.widgetWithText(TextField, 'Notes'),
        'Lead Raichu + Whimsicott.',
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Save notes'));
      await tester.pumpAndSettle();

      expect(find.text('Notes saved'), findsOneWidget);
      expect(
        (await teams.watchAll().first).single.notes,
        'Lead Raichu + Whimsicott.',
      );
    });

    testWidgets('a team without sets has notes too', (tester) async {
      await pumpDetail(tester, teamId: 't2');

      expect(find.widgetWithText(TextField, 'Notes'), findsOneWidget);
    });

    testWidgets('a failed save says so', (tester) async {
      final teams = FakeTeamRepository(teams: [imported]);
      await pumpDetail(tester, teams: teams);
      teams.failWith = Exception('disk full');

      await tester.enterText(find.widgetWithText(TextField, 'Notes'), 'X');
      await tester.tap(find.widgetWithText(FilledButton, 'Save notes'));
      await tester.pumpAndSettle();

      expect(find.text("Couldn't save the notes. Try again."), findsOneWidget);
    });
  });

  testWidgets('a mega ability shows after an arrow', (tester) async {
    final withMegaAbility = imported.copyWith(
      sets: [
        for (final set in imported.sets)
          set.species == 'Raichu' ? set.copyWith(megaAbility: 'No Guard') : set,
      ],
    );
    tester.view.physicalSize = const Size(1200, 4000);
    // Logical pixels: tall enough to build every lazy row.
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider(
          create: (_) => TeamDetailViewModel(
            teamRepository: FakeTeamRepository(teams: [withMegaAbility]),
            pokemonRepository: FakePokemonRepository(),
            matchupRepository: FakeMatchupRepository(),
            typeRepository: FakeTypeRepository(),
            teamId: 't1',
          )..load.execute(),
          child: const TeamDetailScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Lightning Rod → No Guard'), findsOneWidget);
  });

  testWidgets('the Speed order lists the team fastest first', (tester) async {
    await pumpDetail(tester);

    expect(find.text('Speed order'), findsOneWidget);
    final speeds = find.byKey(const ValueKey('speed'));
    expect(
      [for (final e in speeds.evaluate()) (e.widget as Text).data],
      ['200', '184', '178', '137', '130', '70'],
    );
    expect(tester.widget<Text>(speedTier('Metagross-Mega')).data, '178');
  });

  testWidgets('a team without sets shows its Pokémon and how to get more', (
    tester,
  ) async {
    await pumpDetail(tester, teamId: 't2');

    expect(find.text('Metagross'), findsOneWidget);
    expect(
      find.text(
        'Import this team from Showdown to see its sets, stats and '
        'Speed order.',
      ),
      findsOneWidget,
    );
    expect(find.text('Speed order'), findsNothing);
  });

  testWidgets('a deleted team says so', (tester) async {
    await pumpDetail(tester, teamId: 'gone');

    expect(find.text('This team no longer exists.'), findsOneWidget);
  });

  testWidgets('a failed lookup offers Retry', (tester) async {
    final pokemon = FakePokemonRepository()
      ..failWith = const PokeApiNetworkUnavailable('/pokemon');
    await pumpDetail(tester, pokemon: pokemon);
    expect(find.text("Couldn't load this team."), findsOneWidget);

    pokemon.failWith = null;
    await tester.tap(find.widgetWithText(FilledButton, 'Retry'));
    await tester.pumpAndSettle();

    expect(find.text('Speed order'), findsOneWidget);
  });
}
