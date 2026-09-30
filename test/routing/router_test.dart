import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vgc_daily_tracker/routing/router.dart';
import 'package:vgc_daily_tracker/routing/routes.dart';
import 'package:vgc_daily_tracker/ui/log_game/widgets/log_game_screen.dart';
import 'package:vgc_daily_tracker/ui/progress/widgets/progress_screen.dart';
import 'package:vgc_daily_tracker/ui/routine/widgets/routine_screen.dart';
import 'package:vgc_daily_tracker/ui/teams/widgets/team_editor_screen.dart';
import 'package:vgc_daily_tracker/ui/teams/widgets/teams_screen.dart';

import '../../testing/app.dart';

void main() {
  late GoRouter router;

  setUp(() => router = createRouter());
  tearDown(() => router.dispose());

  Future<void> pumpRouter(WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: providersFake(),
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('starts on the Routine screen', (tester) async {
    await pumpRouter(tester);

    expect(find.byType(RoutineScreen), findsOneWidget);
  });

  final deepLinks = {
    Routes.routine: RoutineScreen,
    Routes.teams: TeamsScreen,
    Routes.logGame: LogGameScreen,
    Routes.progress: ProgressScreen,
  };
  for (final MapEntry(key: path, value: screen) in deepLinks.entries) {
    testWidgets('deep link $path shows $screen', (tester) async {
      await pumpRouter(tester);

      router.go(path);
      await tester.pumpAndSettle();

      expect(find.byType(screen), findsOneWidget);
    });
  }

  testWidgets('keeps a visited tab alive offstage when switching away', (
    tester,
  ) async {
    await pumpRouter(tester);

    router.go(Routes.teams);
    await tester.pumpAndSettle();

    expect(find.byType(RoutineScreen), findsNothing);
    expect(find.byType(RoutineScreen, skipOffstage: false), findsOneWidget);
  });

  testWidgets('/teams/new opens the editor for a new team', (tester) async {
    await pumpRouter(tester);

    router.go(Routes.newTeam);
    await tester.pumpAndSettle();

    expect(find.byType(TeamEditorScreen), findsOneWidget);
    expect(find.text('New team'), findsOneWidget);
  });

  testWidgets('/teams/:id/edit opens the editor for that team', (tester) async {
    await pumpRouter(tester);

    router.go(Routes.editTeam('t1'));
    await tester.pumpAndSettle();

    expect(find.byType(TeamEditorScreen), findsOneWidget);
    expect(find.text('Edit team'), findsOneWidget);
  });
}
