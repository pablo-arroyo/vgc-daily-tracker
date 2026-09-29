import 'package:go_router/go_router.dart';

import '../ui/core/app_shell.dart';
import '../ui/log_game/widgets/log_game_screen.dart';
import '../ui/progress/widgets/progress_screen.dart';
import '../ui/routine/widgets/routine_screen.dart';
import '../ui/teams/widgets/teams_screen.dart';
import 'routes.dart';

/// One branch per tab. `indexedStack` keeps every visited branch alive, so a
/// tab keeps its state (scroll position, a half-filled form) while you're on
/// another tab.
GoRouter createRouter() => GoRouter(
  initialLocation: Routes.routine,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.routine,
              builder: (context, state) => const RoutineScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.teams,
              builder: (context, state) => const TeamsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.logGame,
              builder: (context, state) => const LogGameScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.progress,
              builder: (context, state) => const ProgressScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
