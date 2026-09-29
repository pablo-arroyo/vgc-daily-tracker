import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/main.dart';
import 'package:vgc_daily_tracker/ui/core/theme/app_theme.dart';
import 'package:vgc_daily_tracker/ui/log_game/widgets/log_game_screen.dart';
import 'package:vgc_daily_tracker/ui/progress/widgets/progress_screen.dart';
import 'package:vgc_daily_tracker/ui/routine/widgets/routine_screen.dart';
import 'package:vgc_daily_tracker/ui/teams/widgets/teams_screen.dart';

void main() {
  testWidgets('VgcApp builds a MaterialApp titled VGC Daily Tracker', (
    tester,
  ) async {
    await tester.pumpWidget(const VgcApp());

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.title, 'VGC Daily Tracker');
  });

  testWidgets('uses the app light and dark themes, following the system', (
    tester,
  ) async {
    await tester.pumpWidget(const VgcApp());

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.theme, same(AppTheme.light));
    expect(app.darkTheme, same(AppTheme.dark));
    expect(app.themeMode, ThemeMode.system);
  });

  testWidgets('opens on Routine and switches screens from the tab bar', (
    tester,
  ) async {
    await tester.pumpWidget(const VgcApp());
    await tester.pumpAndSettle();

    expect(find.byType(RoutineScreen), findsOneWidget);
    for (final label in ['Routine', 'Teams', 'Log Game', 'Progress']) {
      expect(
        find.descendant(
          of: find.byType(NavigationBar),
          matching: find.text(label),
        ),
        findsOneWidget,
      );
    }

    final tabs = {
      'Teams': TeamsScreen,
      'Log Game': LogGameScreen,
      'Progress': ProgressScreen,
      'Routine': RoutineScreen,
    };
    for (final MapEntry(key: label, value: screen) in tabs.entries) {
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();
      expect(find.byType(screen), findsOneWidget, reason: 'tab "$label"');
    }
  });
}
