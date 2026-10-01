import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:vgc_daily_tracker/data/repositories/team/team_repository.dart';
import 'package:vgc_daily_tracker/domain/models/pokemon_ref.dart';
import 'package:vgc_daily_tracker/domain/models/team.dart';
import 'package:vgc_daily_tracker/ui/core/pokemon_avatar.dart';
import 'package:vgc_daily_tracker/ui/core/theme/app_theme.dart';
import 'package:vgc_daily_tracker/ui/teams/view_models/teams_view_model.dart';
import 'package:vgc_daily_tracker/ui/teams/widgets/teams_screen.dart';
import 'package:vgc_daily_tracker/utils/result.dart';

import '../../../../testing/fakes/fake_team_repository.dart';

/// A repository whose list never arrives, to observe the loading state.
class _NeverLoadsTeamRepository implements TeamRepository {
  @override
  Stream<List<Team>> watchAll() => const Stream.empty();
  @override
  Future<Result<void>> save(Team team) async => const Result.ok(null);
  @override
  Future<Result<void>> delete(String id) async => const Result.ok(null);
}

void main() {
  const bigSix = Team(
    id: 't1',
    name: 'Big Six',
    pokemon: [
      PokemonRef(id: 983, slug: 'kingambit', displayName: 'Kingambit'),
      PokemonRef(id: 547, slug: 'whimsicott', displayName: 'Whimsicott'),
      PokemonRef(id: 445, slug: 'garchomp', displayName: 'Garchomp'),
      PokemonRef(
        id: 902,
        slug: 'basculegion-male',
        displayName: 'Basculegion-Male',
      ),
      PokemonRef(
        id: 10035,
        slug: 'charizard-mega-y',
        displayName: 'Charizard-Mega-Y',
      ),
      PokemonRef(id: 10313, slug: 'floette-mega', displayName: 'Floette-Mega'),
    ],
  );

  Future<void> pumpScreen(WidgetTester tester, TeamRepository repository) =>
      tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: ChangeNotifierProvider(
              create: (_) => TeamsViewModel(teamRepository: repository),
              child: const TeamsScreen(),
            ),
          ),
        ),
      );

  testWidgets('shows a spinner until the teams arrive', (tester) async {
    await pumpScreen(tester, _NeverLoadsTeamRepository());
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('No teams saved yet.'), findsNothing);
  });

  testWidgets('says so when there are no teams', (tester) async {
    await pumpScreen(tester, FakeTeamRepository());
    await tester.pumpAndSettle();

    expect(find.text('No teams saved yet.'), findsOneWidget);
  });

  testWidgets('lists each team with its six Pokémon', (tester) async {
    await pumpScreen(tester, FakeTeamRepository(teams: [bigSix]));
    await tester.pumpAndSettle();

    expect(find.text('Big Six'), findsOneWidget);
    for (final pokemon in bigSix.pokemon) {
      expect(find.text(pokemon.displayName), findsOneWidget);
    }
    expect(find.byType(PokemonAvatar), findsNWidgets(6));
  });

  testWidgets('offers Import from Showdown beside Add team, both tappable', (
    tester,
  ) async {
    await pumpScreen(tester, FakeTeamRepository());
    await tester.pumpAndSettle();

    for (final tooltip in ['Import from Showdown', 'Add team']) {
      final button = find.descendant(
        of: find.byTooltip(tooltip),
        matching: find.byType(RawMaterialButton),
      );
      expect(
        tester
            .hitTestOnBinding(tester.getCenter(button))
            .path
            .any((entry) => entry.target == tester.renderObject(button)),
        isTrue,
        reason: '$tooltip is covered',
      );
    }
  });

  group('deleting', () {
    Future<void> openDeleteDialog(WidgetTester tester) async {
      await tester.tap(find.byTooltip('Delete Big Six'));
      await tester.pumpAndSettle();
      expect(find.text('Delete Big Six?'), findsOneWidget);
    }

    testWidgets('cancel keeps the team', (tester) async {
      await pumpScreen(tester, FakeTeamRepository(teams: [bigSix]));
      await tester.pumpAndSettle();

      await openDeleteDialog(tester);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Big Six'), findsOneWidget);
    });

    testWidgets('confirm deletes it, and Undo restores it', (tester) async {
      await pumpScreen(tester, FakeTeamRepository(teams: [bigSix]));
      await tester.pumpAndSettle();

      await openDeleteDialog(tester);
      await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
      await tester.pumpAndSettle();
      expect(find.text('Big Six'), findsNothing);
      expect(find.text('Deleted Big Six'), findsOneWidget);

      await tester.tap(find.widgetWithText(SnackBarAction, 'Undo'));
      await tester.pumpAndSettle();
      expect(find.text('Big Six'), findsOneWidget);
    });

    testWidgets('a failed delete says so and keeps the team', (tester) async {
      final repository = FakeTeamRepository(teams: [bigSix]);
      await pumpScreen(tester, repository);
      await tester.pumpAndSettle();
      repository.failWith = Exception('disk full');

      await openDeleteDialog(tester);
      await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
      await tester.pumpAndSettle();

      expect(find.text("Couldn't delete Big Six. Try again."), findsOneWidget);
      expect(find.text('Big Six'), findsOneWidget);
    });
  });
}
