import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:vgc_daily_tracker/ui/core/theme/app_theme.dart';
import 'package:vgc_daily_tracker/domain/models/team.dart';
import 'package:vgc_daily_tracker/domain/use_cases/import_team_use_case.dart';
import 'package:vgc_daily_tracker/ui/teams/view_models/team_import_view_model.dart';
import 'package:vgc_daily_tracker/ui/teams/widgets/team_import_screen.dart';

import '../../../../testing/fakes/fake_id_generator.dart';
import '../../../../testing/fakes/fake_item_repository.dart';
import '../../../../testing/fakes/fake_pokemon_repository.dart';
import '../../../../testing/fakes/fake_team_repository.dart';
import '../../../../testing/showdown_pastes.dart';

void main() {
  /// The import screen, pushed over a host page, like the real route.
  Future<FakeTeamRepository> pumpImport(
    WidgetTester tester, {
    TeamSide side = TeamSide.mine,
  }) async {
    final teams = FakeTeamRepository();
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => ChangeNotifierProvider(
                    create: (_) => TeamImportViewModel(
                      side: side,
                      teamRepository: teams,
                      importTeam: ImportTeamUseCase(
                        pokemonRepository: FakePokemonRepository(),
                        itemRepository: FakeItemRepository(),
                        idGenerator: SequentialIdGenerator(),
                      ),
                    ),
                    child: const TeamImportScreen(),
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
    await tester.pumpAndSettle();
    return teams;
  }

  Future<void> fillAndImport(
    WidgetTester tester, {
    String name = 'Worlds',
    required String paste,
  }) async {
    await tester.enterText(find.widgetWithText(TextField, 'Team name'), name);
    await tester.enterText(
      find.widgetWithText(TextField, 'Showdown paste'),
      paste,
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Import team'));
    await tester.pumpAndSettle();
  }

  testWidgets('a name field, a paste field and a reachable Import button', (
    tester,
  ) async {
    await pumpImport(tester);

    expect(find.text('Import from Showdown'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Team name'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Showdown paste'), findsOneWidget);
    final button = find.widgetWithText(FilledButton, 'Import team');
    expect(
      tester
          .hitTestOnBinding(tester.getCenter(button))
          .path
          .any((entry) => entry.target == tester.renderObject(button)),
      isTrue,
      reason: 'Import team is covered',
    );
  });

  testWidgets("importing an opponent's team says so in the title", (
    tester,
  ) async {
    await pumpImport(tester, side: TeamSide.opponent);

    expect(find.text('Import opponent team'), findsOneWidget);
  });

  testWidgets('lists every problem with the paste', (tester) async {
    await pumpImport(tester);

    await fillAndImport(tester, paste: 'Pikachu\nGrumpy Nature\nIVs: 40 Spe');

    expect(find.text('Line 2: Unknown nature "Grumpy"'), findsOneWidget);
    expect(find.text('Line 3: 40 Spe IVs (max 31)'), findsOneWidget);
    expect(find.text('host page'), findsNothing);
  });

  testWidgets('a good paste is saved and the screen closes', (tester) async {
    final teams = await pumpImport(tester);

    await fillAndImport(tester, paste: team1Paste);

    expect(find.text('host page'), findsOneWidget);
    expect((await teams.watchAll().first).single.name, 'Worlds');
  });

  testWidgets('a failed save says so', (tester) async {
    final teams = await pumpImport(tester);
    teams.failWith = Exception('disk full');

    await fillAndImport(tester, paste: team1Paste);

    expect(find.text("Couldn't save the team. Try again."), findsOneWidget);
  });
}
