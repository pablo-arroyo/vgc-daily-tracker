import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:vgc_daily_tracker/data/repositories/game_log/game_log_repository.dart';
import 'package:vgc_daily_tracker/ui/log_game/widgets/log_game_screen.dart';

import '../../testing/app.dart';
import '../../testing/log_game_actions.dart';
import '../../testing/team_editor_actions.dart';

/// Create a team, then log a game with it (brought 4, leads 2).
/// Checking the game in Progress arrives with the Progress tab (5.2).
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
  });
}
