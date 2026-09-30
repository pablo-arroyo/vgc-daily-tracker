import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:vgc_daily_tracker/data/repositories/team/team_repository.dart';
import 'package:vgc_daily_tracker/domain/models/pokemon_ref.dart';
import 'package:vgc_daily_tracker/domain/models/team.dart';
import 'package:vgc_daily_tracker/ui/core/theme/app_theme.dart';
import 'package:vgc_daily_tracker/ui/teams/view_models/team_editor_view_model.dart';
import 'package:vgc_daily_tracker/ui/teams/widgets/team_editor_screen.dart';
import 'package:vgc_daily_tracker/utils/result.dart';

import '../../../../testing/fakes/fake_id_generator.dart';
import '../../../../testing/fakes/fake_pokemon_repository.dart';
import '../../../../testing/fakes/fake_team_repository.dart';

/// A repository whose teams never arrive, to observe the loading state.
class _NeverLoadsTeamRepository implements TeamRepository {
  // Stays open without emitting (an empty stream would close, which is a
  // different situation).
  final _never = StreamController<List<Team>>();
  @override
  Stream<List<Team>> watchAll() => _never.stream;
  @override
  Future<Result<void>> save(Team team) async => const Result.ok(null);
  @override
  Future<Result<void>> delete(String id) async => const Result.ok(null);
}

void main() {
  PokemonRef ref(String slug) {
    final p = FakePokemonRepository.samplePokemon.singleWhere(
      (p) => p.slug == slug,
    );
    return PokemonRef(id: p.id, slug: p.slug, displayName: p.displayName);
  }

  final existing = Team(
    id: 't9',
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
        ref(slug),
    ],
  );

  /// The editor, pushed over a host page, like the real route.
  Future<FakeTeamRepository> pumpEditor(
    WidgetTester tester, {
    String? teamId,
  }) async {
    final teams = FakeTeamRepository(teams: [existing]);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => ChangeNotifierProvider(
                    create: (_) => TeamEditorViewModel(
                      teamRepository: teams,
                      pokemonRepository: FakePokemonRepository(),
                      idGenerator: SequentialIdGenerator(),
                      teamId: teamId,
                    ),
                    child: const TeamEditorScreen(),
                  ),
                ),
              ),
              child: const Text('host page'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('host page'));
    await tester.pump();
    return teams;
  }

  testWidgets('a new team: a name field, six Pokémon fields and Save', (
    tester,
  ) async {
    await pumpEditor(tester);
    await tester.pumpAndSettle();

    expect(find.text('New team'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Team name'), findsOneWidget);
    for (var i = 1; i <= 6; i++) {
      expect(find.widgetWithText(TextField, 'Pokémon $i'), findsOneWidget);
    }
    expect(find.widgetWithText(FilledButton, 'Save team'), findsOneWidget);
  });

  testWidgets('shows why a team cannot be saved', (tester) async {
    await pumpEditor(tester);
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Save team'));
    await tester.pumpAndSettle();

    expect(find.text('Give the team a name.'), findsOneWidget);
  });

  testWidgets('editing: a spinner while the team loads', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider(
          create: (_) => TeamEditorViewModel(
            teamRepository: _NeverLoadsTeamRepository(),
            pokemonRepository: FakePokemonRepository(),
            idGenerator: SequentialIdGenerator(),
            teamId: 't9',
          ),
          child: const TeamEditorScreen(),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('editing: the form starts pre-filled', (tester) async {
    await pumpEditor(tester, teamId: 't9');
    await tester.pumpAndSettle();

    expect(find.text('Edit team'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Big Six'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Kingambit'), findsOneWidget);
  });

  testWidgets('a successful save closes the editor', (tester) async {
    final teams = await pumpEditor(tester, teamId: 't9');
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextField, 'Big Six'),
      'Big Six v2',
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Save team'));
    await tester.pumpAndSettle();

    expect(find.text('host page'), findsOneWidget);
    expect((await teams.watchAll().first).single.name, 'Big Six v2');
  });

  testWidgets('editing a team that no longer exists says so', (tester) async {
    await pumpEditor(tester, teamId: 'deleted');
    await tester.pumpAndSettle();

    expect(find.text('This team no longer exists.'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Save team'), findsNothing);
  });

  testWidgets('the Save bar sits below the form instead of covering it', (
    tester,
  ) async {
    // Regression: the sticky Save bar once grew to the full screen height and
    // covered the form (the fields existed but were invisible).
    await pumpEditor(tester);
    await tester.pumpAndSettle();

    final nameField = find.widgetWithText(TextField, 'Team name');
    final save = find.widgetWithText(FilledButton, 'Save team');
    expect(
      tester.getRect(save).top,
      greaterThan(tester.getRect(nameField).bottom),
    );
    expect(
      tester.getRect(save).bottom,
      greaterThan(
        tester.view.physicalSize.height / tester.view.devicePixelRatio - 100,
      ),
      reason: 'Save is at the bottom of the screen',
    );
    // A real tap on the name field reaches it (nothing is on top of it).
    await tester.tap(nameField);
    expect(tester.testTextInput.isVisible, isTrue);
  });
}
