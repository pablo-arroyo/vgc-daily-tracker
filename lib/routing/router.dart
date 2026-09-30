import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../ui/core/app_shell.dart';
import '../ui/log_game/view_models/log_game_view_model.dart';
import '../ui/log_game/widgets/log_game_screen.dart';
import '../ui/progress/view_models/progress_view_model.dart';
import '../ui/progress/widgets/progress_screen.dart';
import '../ui/routine/widgets/routine_screen.dart';
import '../ui/teams/view_models/team_editor_view_model.dart';
import '../ui/teams/view_models/teams_view_model.dart';
import '../ui/teams/widgets/team_editor_screen.dart';
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
              // Created once per tab and disposed with it.
              builder: (context, state) => ChangeNotifierProvider(
                create: (context) =>
                    TeamsViewModel(teamRepository: context.read()),
                child: const TeamsScreen(),
              ),
              routes: [
                GoRoute(
                  path: 'new',
                  builder: (context, state) => _teamEditor(),
                ),
                GoRoute(
                  path: ':id/edit',
                  builder: (context, state) =>
                      _teamEditor(teamId: state.pathParameters['id']),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.logGame,
              builder: (context, state) => ChangeNotifierProvider(
                create: (context) => LogGameViewModel(
                  gameLogRepository: context.read(),
                  teamRepository: context.read(),
                  pokemonRepository: context.read(),
                  idGenerator: context.read(),
                ),
                child: const LogGameScreen(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.progress,
              builder: (context, state) => ChangeNotifierProvider(
                create: (context) =>
                    ProgressViewModel(gameLogRepository: context.read()),
                child: const ProgressScreen(),
              ),
            ),
          ],
        ),
      ],
    ),
  ],
);

Widget _teamEditor({String? teamId}) => ChangeNotifierProvider(
  create: (context) => TeamEditorViewModel(
    teamRepository: context.read(),
    pokemonRepository: context.read(),
    idGenerator: context.read(),
    teamId: teamId,
  ),
  child: const TeamEditorScreen(),
);
