import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:vgc_daily_tracker/data/repositories/game_log/game_log_repository.dart';
import 'package:vgc_daily_tracker/ui/log_game/widgets/log_game_screen.dart';

import '../../testing/app.dart';
import '../../testing/log_game_actions.dart';
import '../../testing/progress_actions.dart';
import '../../testing/team_editor_actions.dart';

/// Create a team, log two games (one with brought 4 and leads 2), then
/// check totals, streak and the team's record in Progress.
void logGameJourney() {
  testWidgets('create a team, then log a game with it', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('Teams'));
    await tester.pumpAndSettle();
    await createTeam(
      tester,
      name: 'Big Six',
      picks: const [
        ('king', 'Kingambit'),
        ('whim', 'Whimsicott'),
        ('garch', 'Garchomp'),
        ('incin', 'Incineroar'),
        ('rilla', 'Rillaboom'),
        ('chariz', 'Charizard'),
      ],
    );

    await tester.tap(find.text('Log Game'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Loss'));
    await selectDropdownItem(tester, 'Your team used', 'Big Six');
    for (final name in ['Kingambit', 'Whimsicott', 'Garchomp', 'Rillaboom']) {
      await tapChip(tester, section: 'your-brought', name: name);
    }
    await tapChip(tester, section: 'your-leads', name: 'Rillaboom');
    await tapChip(tester, section: 'your-leads', name: 'Garchomp');
    await tester.tap(find.widgetWithText(FilledButton, 'Save game'));
    await tester.pumpAndSettle();

    expect(find.text('Game logged ✓'), findsOneWidget);
    final games = await tester
        .element(find.byType(LogGameScreen))
        .read<GameLogRepository>()
        .watchAll()
        .first;
    expect(games.single.leads, ['rillaboom', 'garchomp']);

    // A second game, then both show up in Progress. The page stays scrolled
    // down after the first save, so bring the result picker back into view.
    await tester.ensureVisible(find.text('Win'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Win'));
    await tester.tap(find.widgetWithText(FilledButton, 'Save game'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Progress'));
    await tester.pumpAndSettle();

    String statValue(String label) => tester
        .widgetList<Text>(
          find.descendant(
            of: find.ancestor(
              of: find.text(label),
              matching: find.byKey(const ValueKey('stat-box')),
            ),
            matching: find.byType(Text),
          ),
        )
        .first
        .data!;
    expect(statValue('games logged'), '2');
    expect(statValue('overall win rate'), '50%');
    expect(statValue('day streak'), '1');
    // Only the first game (a loss) used Big Six; the second had no team.
    await scrollTo(tester, find.text('Big Six (0-1)'));
    expect(find.text('Big Six (0-1)'), findsOneWidget);
  });
}
