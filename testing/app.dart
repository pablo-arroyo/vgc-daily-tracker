import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:vgc_daily_tracker/data/repositories/game_log/game_log_repository.dart';
import 'package:vgc_daily_tracker/data/repositories/pokemon/pokemon_repository.dart';
import 'package:vgc_daily_tracker/data/repositories/team/team_repository.dart';
import 'package:vgc_daily_tracker/domain/models/game_log.dart';
import 'package:vgc_daily_tracker/domain/models/team.dart';
import 'package:vgc_daily_tracker/main.dart';
import 'package:vgc_daily_tracker/utils/id_generator.dart';

import 'fakes/fake_game_log_repository.dart';
import 'fakes/fake_id_generator.dart';
import 'fakes/fake_pokemon_repository.dart';
import 'fakes/fake_team_repository.dart';

/// Builds the whole app and waits until it has settled on its first screen.
///
/// Shared by widget tests (`test/`) and integration tests
/// (`integration_test/`), always with [providersFake], optionally seeded.
Future<void> pumpApp(
  WidgetTester tester, {
  List<Team> teams = const [],
  List<GameLog> games = const [],
}) async {
  await tester.pumpWidget(
    VgcApp(
      providers: providersFake(teams: teams, games: games),
    ),
  );
  await tester.pumpAndSettle();
}

/// The app's dependencies, all fake: no network, no disk. [teams] and
/// [games] seed the repositories.
List<SingleChildWidget> providersFake({
  List<Team> teams = const [],
  List<GameLog> games = const [],
}) => [
  Provider<PokemonRepository>(create: (_) => FakePokemonRepository()),
  Provider<TeamRepository>(create: (_) => FakeTeamRepository(teams: teams)),
  Provider<GameLogRepository>(
    create: (_) => FakeGameLogRepository(games: games),
  ),
  Provider<IdGenerator>(create: (_) => SequentialIdGenerator()),
];
