import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/ui/log_game/widgets/log_game_screen.dart';
import 'package:vgc_daily_tracker/ui/progress/widgets/progress_screen.dart';
import 'package:vgc_daily_tracker/ui/routine/widgets/routine_screen.dart';
import 'package:vgc_daily_tracker/ui/teams/widgets/teams_screen.dart';

import '../../testing/app.dart';

/// Launch the app and visit every tab.
void smokeJourney() {
  testWidgets('smoke: launch the app and visit every tab', (tester) async {
    await pumpApp(tester);
    expect(find.text('🎮 VGC Daily Practice Tracker'), findsOneWidget);
    expect(find.byType(RoutineScreen), findsOneWidget);

    final tabs = {
      'Teams': TeamsScreen,
      'Log Game': LogGameScreen,
      'Progress': ProgressScreen,
      'Routine': RoutineScreen,
    };
    for (final MapEntry(key: label, value: screen) in tabs.entries) {
      await tester.tap(
        find.descendant(
          of: find.byType(NavigationBar),
          matching: find.text(label),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(screen), findsOneWidget, reason: 'tab "$label"');
    }
  });
}
