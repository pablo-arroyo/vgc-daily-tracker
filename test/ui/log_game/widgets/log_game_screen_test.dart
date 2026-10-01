import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:vgc_daily_tracker/domain/models/game_log.dart';
import 'package:vgc_daily_tracker/domain/models/mistake_category.dart';
import 'package:vgc_daily_tracker/domain/models/team.dart';
import 'package:vgc_daily_tracker/ui/core/theme/app_theme.dart';
import 'package:vgc_daily_tracker/ui/log_game/view_models/log_game_view_model.dart';
import 'package:vgc_daily_tracker/ui/log_game/widgets/log_game_screen.dart';

import '../../../../testing/fakes/fake_game_log_repository.dart';
import '../../../../testing/fakes/fake_id_generator.dart';
import '../../../../testing/fakes/fake_matchup_repository.dart';
import '../../../../testing/fakes/fake_pokemon_repository.dart';
import '../../../../testing/fakes/fake_team_repository.dart';
import '../../../../testing/log_game_actions.dart';
import '../../../../testing/team_editor_actions.dart';

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

  Future<LogGameViewModel> pumpScreen(
    WidgetTester tester, {
    List<Team> extraTeams = const [],
    FakeMatchupRepository? matchups,
  }) async {
    games = FakeGameLogRepository();
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: ChangeNotifierProvider(
          create: (_) => LogGameViewModel(
            gameLogRepository: games,
            teamRepository: FakeTeamRepository(teams: [bigSix, ...extraTeams]),
            pokemonRepository: FakePokemonRepository(),
            matchupRepository: matchups ?? FakeMatchupRepository(),
            idGenerator: SequentialIdGenerator(),
          ),
          child: const LogGameScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return tester.element(find.byType(LogGameScreen)).read<LogGameViewModel>();
  }

  group('result and team', () {
    testWidgets('Win and Loss set the result', (tester) async {
      final viewModel = await pumpScreen(tester);

      await tester.tap(find.text('Loss'));
      await tester.pumpAndSettle();

      expect(viewModel.result, GameResult.loss);
    });

    testWidgets('picking a team shows its brought chips and the hints', (
      tester,
    ) async {
      await pumpScreen(tester);
      expect(find.byKey(const ValueKey('your-brought')), findsNothing);

      await selectDropdownItem(tester, 'Your team used', 'Big Six');

      expect(find.text('0 / 4 selected'), findsOneWidget);
      expect(find.text('Select 4 brought first'), findsOneWidget);
      for (final p in bigSix.pokemon) {
        expect(
          find.descendant(
            of: find.byKey(const ValueKey('your-brought')),
            matching: find.text(p.displayName),
          ),
          findsOneWidget,
        );
      }
    });
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
    String slotText(WidgetTester tester, int n) => tester
        .widget<TextField>(find.widgetWithText(TextField, 'Opp. Pokémon $n'))
        .controller!
        .text;

    testWidgets('no saved opponent teams: no picker', (tester) async {
      await pumpScreen(tester);

      expect(find.text('Their team'), findsNothing);
    });

    testWidgets('picking one fills the six opponent fields, which stay '
        'editable', (tester) async {
      final viewModel = await pumpScreen(tester, extraTeams: [rival]);

      await selectDropdownItem(tester, 'Their team', 'Rival Grassy');

      for (final (i, p) in rival.pokemon.indexed) {
        expect(slotText(tester, i + 1), p.displayName);
      }
      final opponentBrought = find.byKey(const ValueKey('opponent-brought'));
      expect(
        find.descendant(of: opponentBrought, matching: find.text('Sneasler')),
        findsOneWidget,
      );

      await pickPokemon(
        tester,
        label: 'Opp. Pokémon 6',
        query: 'garch',
        option: 'Garchomp',
      );
      expect(viewModel.opponentTeam.last.slug, 'garchomp');
      expect(viewModel.selectedOpponentTeam, rival);
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

    testWidgets('hidden until their team is picked', (tester) async {
      await pumpScreen(tester, extraTeams: [rival]);

      expect(find.text('Game plan'), findsNothing);
    });

    testWidgets('their notes, then a hint to pick your team', (tester) async {
      await pumpScreen(tester, extraTeams: [rival]);

      await selectDropdownItem(tester, 'Their team', 'Rival Grassy');

      expect(find.text('Game plan'), findsOneWidget);
      expect(find.text('Fake Out Sneasler turn 1.'), findsOneWidget);
      expect(
        find.text('Pick your team to see your plan for this matchup.'),
        findsOneWidget,
      );
    });

    testWidgets('with both teams: the matchup plan, editable in place', (
      tester,
    ) async {
      final matchups = FakeMatchupRepository();
      await pumpScreen(tester, extraTeams: [rival], matchups: matchups);
      await selectDropdownItem(tester, 'Their team', 'Rival Grassy');
      await selectDropdownItem(tester, 'Your team used', 'Big Six');

      expect(find.text('Big Six vs Rival Grassy'), findsOneWidget);
      expect(find.text('No plan yet for this matchup.'), findsOneWidget);

      final edit = find.byTooltip('Edit the matchup plan');
      await tester.ensureVisible(edit);
      await tester.pumpAndSettle();
      await tester.tap(edit);
      await tester.pumpAndSettle();
      await tester.enterText(
        find.widgetWithText(TextField, 'Game plan'),
        'Tailwind turn 1.',
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Save'));
      await tester.pumpAndSettle();

      expect(find.text('Tailwind turn 1.'), findsOneWidget);
      expect(
        (await matchups.watchAll().first).single.notes,
        'Tailwind turn 1.',
      );
    });
  });

  group("after saving, the game's notes can join the plan", () {
    final rival = Team(
      id: 'o1',
      name: 'Rival Grassy',
      side: TeamSide.opponent,
      pokemon: [FakePokemonRepository.sampleRef('rillaboom')],
    );

    Future<void> logLossVsRival(
      WidgetTester tester, {
      String notes = '',
    }) async {
      await tester.tap(find.text('Loss'));
      await tester.pumpAndSettle();
      await selectDropdownItem(tester, 'Their team', 'Rival Grassy');
      await tester.enterText(find.widgetWithText(TextField, 'Notes'), notes);
      await tester.tap(find.widgetWithText(FilledButton, 'Save game'));
      await tester.pumpAndSettle();
    }

    testWidgets('the snackbar offers it, and confirms where it went', (
      tester,
    ) async {
      await pumpScreen(tester, extraTeams: [rival]);

      await logLossVsRival(tester, notes: 'Watch for Trick Room.');
      await tester.tap(
        find.widgetWithText(SnackBarAction, 'Add to their notes'),
      );
      await tester.pumpAndSettle();

      expect(find.text("Added to Rival Grassy's notes"), findsOneWidget);
    });

    testWidgets('a game without notes gets no offer', (tester) async {
      await pumpScreen(tester, extraTeams: [rival]);

      await logLossVsRival(tester);

      expect(find.text('Game logged ✓'), findsOneWidget);
      expect(find.byType(SnackBarAction), findsNothing);
    });
  });

  group('your picks', () {
    testWidgets('limits are enforced visibly: 4 brought, then leads appear', (
      tester,
    ) async {
      final viewModel = await pumpScreen(tester);
      await selectDropdownItem(tester, 'Your team used', 'Big Six');

      for (final name in [
        'Kingambit',
        'Whimsicott',
        'Garchomp',
        'Incineroar',
      ]) {
        await tapChip(tester, section: 'your-brought', name: name);
      }
      expect(find.text('4 / 4 selected'), findsOneWidget);

      await tapChip(tester, section: 'your-brought', name: 'Rillaboom');
      expect(find.text('Only 4 Pokémon can be brought.'), findsOneWidget);
      expect(viewModel.brought, hasLength(4));

      expect(find.text('0 / 2 selected'), findsOneWidget);
      final leadChips = find.descendant(
        of: find.byKey(const ValueKey('your-leads')),
        matching: find.byType(Text),
      );
      expect(leadChips, findsNWidgets(4));

      await tapChip(tester, section: 'your-leads', name: 'Garchomp');
      expect(viewModel.leads.single.slug, 'garchomp');
      expect(find.text('1 / 2 selected'), findsOneWidget);
    });
  });

  group('the opponent', () {
    testWidgets('filled slots become brought chips, and brought become '
        'lead chips', (tester) async {
      final viewModel = await pumpScreen(tester);
      expect(
        find.text(
          'From Team Preview — fill in whichever you remember, '
          'rest optional',
        ),
        findsOneWidget,
      );
      expect(find.byKey(const ValueKey('opponent-brought')), findsNothing);

      await pickPokemon(
        tester,
        label: 'Opp. Pokémon 1',
        query: 'rilla',
        option: 'Rillaboom',
      );
      expect(find.text('0 selected (up to 4)'), findsOneWidget);
      expect(find.text('Pick from brought above'), findsOneWidget);

      await tapChip(tester, section: 'opponent-brought', name: 'Rillaboom');
      expect(find.text('1 selected (up to 4)'), findsOneWidget);
      await tapChip(tester, section: 'opponent-leads', name: 'Rillaboom');

      expect(viewModel.opponentLeads.single.slug, 'rillaboom');
      expect(find.text('1 selected (up to 2)'), findsOneWidget);
    });
  });

  group('saving', () {
    Future<void> tapSaveGame(WidgetTester tester) async {
      await tester.tap(find.widgetWithText(FilledButton, 'Save game'));
      await tester.pumpAndSettle();
    }

    testWidgets('without a result says what is missing', (tester) async {
      await pumpScreen(tester);

      await tapSaveGame(tester);

      expect(find.text('Pick Win or Loss first.'), findsOneWidget);
    });

    testWidgets('stores mistake and notes, confirms, and resets the form', (
      tester,
    ) async {
      await pumpScreen(tester);
      await tester.tap(find.text('Win'));
      await pickPokemon(
        tester,
        label: 'Opp. Pokémon 1',
        query: 'rilla',
        option: 'Rillaboom',
      );
      await selectDropdownItem(
        tester,
        'What decided this game?',
        MistakeCategory.protectCall.label,
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Notes'),
        'Protect less.',
      );

      await tapSaveGame(tester);

      expect(find.text('Game logged ✓'), findsOneWidget);
      final [saved] = await games.watchAll().first;
      expect(saved.mistake, MistakeCategory.protectCall);
      expect(saved.notes, 'Protect less.');
      expect(find.text('Protect less.'), findsNothing);
      expect(find.text('Rillaboom'), findsNothing);
      expect(find.text(MistakeCategory.protectCall.label), findsNothing);
    });

    testWidgets('a failed save says so and keeps the form', (tester) async {
      await pumpScreen(tester);
      games.failWith = Exception('disk full');
      await tester.tap(find.text('Win'));
      await tester.enterText(
        find.widgetWithText(TextField, 'Notes'),
        'Keep me.',
      );

      await tapSaveGame(tester);

      expect(find.text("Couldn't save the game. Try again."), findsOneWidget);
      expect(find.text('Keep me.'), findsOneWidget);
    });
  });
}
