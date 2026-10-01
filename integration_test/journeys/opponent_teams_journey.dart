import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/config/format_config.dart';
import 'package:vgc_daily_tracker/domain/models/game_log.dart';

import '../../testing/app.dart';
import '../../testing/log_game_actions.dart';
import '../../testing/progress_actions.dart';
import '../../testing/team_import_actions.dart';

/// Opponent teams on the real app: import one under Opponents; it stays
/// out of My teams, and fills the opponent's slots in Log Game.
void opponentTeamsJourney() {
  testWidgets('import an opponent team: listed under Opponents only', (
    tester,
  ) async {
    await pumpApp(tester);
    await tester.tap(find.text('Teams'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Opponents'));
    await tester.pumpAndSettle();

    await importTeam(
      tester,
      name: 'Rival Grassy',
      paste: FormatConfig.regMC.sampleTeams[1].paste,
    );
    expect(find.text('Rival Grassy'), findsOneWidget);

    await tester.tap(find.text('My teams'));
    await tester.pumpAndSettle();
    expect(find.text('Rival Grassy'), findsNothing);

    await tester.tap(find.text('Log Game'));
    await tester.pumpAndSettle();
    await selectDropdownItem(tester, 'Their team', 'Rival Grassy');
    expect(
      tester
          .widget<TextField>(find.widgetWithText(TextField, 'Opp. Pokémon 1'))
          .controller
          ?.text,
      'Rillaboom',
    );
  });

  testWidgets("save a logged game's opponent as a team", (tester) async {
    await pumpApp(
      tester,
      games: [
        GameLog(
          id: 'g1',
          playedAt: DateTime.now().toUtc(),
          result: GameResult.loss,
          opponentTeam: const [
            'rillaboom',
            'sneasler',
            'incineroar',
            'kingambit',
            'salamence',
            'grimmsnarl',
          ],
        ),
      ],
    );
    await tester.tap(find.text('Progress'));
    await tester.pumpAndSettle();

    final save = find.byTooltip('Save their team');
    await scrollTo(tester, save);
    await tester.tap(save);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'Team name'),
      'Ladder Grassy',
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pumpAndSettle();

    // The game now counts toward the matchup.
    await scrollTo(tester, find.text('Ladder Grassy (0-1)'));
    expect(find.text('Ladder Grassy (0-1)'), findsOneWidget);

    await tester.tap(find.text('Teams'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Opponents'));
    await tester.pumpAndSettle();
    expect(find.text('Ladder Grassy'), findsOneWidget);
  });
}
