import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../domain/models/team.dart';
import '../ui/backup/view_models/backup_view_model.dart';
import '../ui/backup/widgets/backup_screen.dart';
import '../ui/core/app_shell.dart';
import '../ui/log_game/view_models/log_game_view_model.dart';
import '../ui/log_game/widgets/log_game_screen.dart';
import '../ui/progress/view_models/progress_view_model.dart';
import '../ui/progress/widgets/progress_screen.dart';
import '../ui/routine/view_models/routine_view_model.dart';
import '../ui/routine/widgets/routine_screen.dart';
import '../ui/teams/view_models/team_detail_view_model.dart';
import '../ui/teams/view_models/team_editor_view_model.dart';
import '../ui/teams/view_models/team_import_view_model.dart';
import '../ui/teams/view_models/teams_view_model.dart';
import '../ui/teams/widgets/team_detail_screen.dart';
import '../ui/teams/widgets/team_editor_screen.dart';
import '../ui/teams/widgets/team_import_screen.dart';
import '../ui/teams/widgets/teams_screen.dart';
import 'routes.dart';

/// One branch per tab. `indexedStack` keeps every visited branch alive, so a
/// tab keeps its state (scroll position, a half-filled form) while you're on
/// another tab.
GoRouter createRouter() => GoRouter(
  initialLocation: Routes.routine,
  routes: [
    // Full screen, over the tabs.
    GoRoute(
      path: Routes.backup,
      builder: (context, state) => ChangeNotifierProvider(
        create: (context) => BackupViewModel(
          teamRepository: context.read(),
          gameLogRepository: context.read(),
          routineRepository: context.read(),
        ),
        child: const BackupScreen(),
      ),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.routine,
              builder: (context, state) => ChangeNotifierProvider(
                create: (context) =>
                    RoutineViewModel(routineRepository: context.read()),
                child: const RoutineScreen(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.teams,
              // Created once per tab and disposed with it.
              builder: (context, state) => ChangeNotifierProvider(
                create: (context) => TeamsViewModel(
                  teamRepository: context.read(),
                  importTeam: context.read(),
                  format: context.read(),
                ),
                child: const TeamsScreen(),
              ),
              routes: [
                GoRoute(
                  path: 'new',
                  builder: (context, state) =>
                      _teamEditor(side: Routes.sideOf(state.uri)),
                ),
                GoRoute(
                  path: 'import',
                  builder: (context, state) => ChangeNotifierProvider(
                    create: (context) => TeamImportViewModel(
                      teamRepository: context.read(),
                      importTeam: context.read(),
                      side: Routes.sideOf(state.uri),
                    ),
                    child: const TeamImportScreen(),
                  ),
                ),
                // After `new` and `import`, so those aren't read as ids.
                GoRoute(
                  path: ':id',
                  builder: (context, state) => ChangeNotifierProvider(
                    create: (context) => TeamDetailViewModel(
                      teamRepository: context.read(),
                      pokemonRepository: context.read(),
                      teamId: state.pathParameters['id']!,
                    )..load.execute(),
                    child: const TeamDetailScreen(),
                  ),
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
                create: (context) => ProgressViewModel(
                  gameLogRepository: context.read(),
                  teamRepository: context.read(),
                  pokemonRepository: context.read(),
                  idGenerator: context.read(),
                ),
                child: const ProgressScreen(),
              ),
            ),
          ],
        ),
      ],
    ),
  ],
);

Widget _teamEditor({String? teamId, TeamSide side = TeamSide.mine}) =>
    ChangeNotifierProvider(
      create: (context) => TeamEditorViewModel(
        teamRepository: context.read(),
        pokemonRepository: context.read(),
        idGenerator: context.read(),
        teamId: teamId,
        side: side,
      ),
      child: const TeamEditorScreen(),
    );
