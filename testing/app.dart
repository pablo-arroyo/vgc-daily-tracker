import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:vgc_daily_tracker/config/format_config.dart';
import 'package:vgc_daily_tracker/data/repositories/game_log/game_log_repository.dart';
import 'package:vgc_daily_tracker/data/repositories/item/item_repository.dart';
import 'package:vgc_daily_tracker/data/repositories/matchup/matchup_repository.dart';
import 'package:vgc_daily_tracker/data/repositories/pokemon/pokemon_repository.dart';
import 'package:vgc_daily_tracker/data/repositories/routine/routine_repository.dart';
import 'package:vgc_daily_tracker/data/repositories/team/team_repository.dart';
import 'package:vgc_daily_tracker/data/repositories/type/type_repository.dart';
import 'package:vgc_daily_tracker/domain/models/game_log.dart';
import 'package:vgc_daily_tracker/domain/models/team.dart';
import 'package:vgc_daily_tracker/domain/use_cases/import_team_use_case.dart';
import 'package:vgc_daily_tracker/main.dart';
import 'package:vgc_daily_tracker/utils/id_generator.dart';

import 'fakes/fake_game_log_repository.dart';
import 'fakes/fake_id_generator.dart';
import 'fakes/fake_item_repository.dart';
import 'fakes/fake_matchup_repository.dart';
import 'fakes/fake_pokemon_repository.dart';
import 'fakes/fake_routine_repository.dart';
import 'fakes/fake_team_repository.dart';
import 'fakes/fake_type_repository.dart';

/// Builds the whole app and waits until it has settled on its first screen.
///
/// Shared by widget tests (`test/`) and integration tests
/// (`integration_test/`), always with [providersFake], optionally seeded.
Future<void> pumpApp(
  WidgetTester tester, {
  List<Team> teams = const [],
  List<GameLog> games = const [],
  FakeRoutineRepository? routine,
  FormatConfig? format,
  FakePokemonRepository? pokemon,
  FakeMatchupRepository? matchups,
}) async {
  await tester.pumpWidget(
    VgcApp(
      // A fresh key per call: calling pumpApp again launches a new app (as
      // after a restart), rather than rebuilding the old one in place.
      key: UniqueKey(),
      providers: providersFake(
        teams: teams,
        games: games,
        routine: routine,
        format: format,
        pokemon: pokemon,
        matchups: matchups,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

/// The app's dependencies, all fake: no network, no disk. [teams] and
/// [games] seed the repositories; pass the same [routine] to two apps to
/// simulate a restart, or a [pokemon] repository to switch it offline.
List<SingleChildWidget> providersFake({
  List<Team> teams = const [],
  List<GameLog> games = const [],
  FakeRoutineRepository? routine,
  FormatConfig? format,
  FakePokemonRepository? pokemon,
  FakeMatchupRepository? matchups,
}) => [
  Provider<FormatConfig>.value(value: format ?? FormatConfig.regMC),
  Provider<PokemonRepository>(
    create: (_) => pokemon ?? FakePokemonRepository(),
  ),
  Provider<ItemRepository>(create: (_) => FakeItemRepository()),
  Provider<TypeRepository>(create: (_) => FakeTypeRepository()),
  Provider<MatchupRepository>(
    create: (_) => matchups ?? FakeMatchupRepository(),
  ),
  Provider<TeamRepository>(create: (_) => FakeTeamRepository(teams: teams)),
  Provider<GameLogRepository>(
    create: (_) => FakeGameLogRepository(games: games),
  ),
  Provider<RoutineRepository>(
    create: (_) => routine ?? FakeRoutineRepository(),
  ),
  Provider<IdGenerator>(create: (_) => SequentialIdGenerator()),
  // The real use case, over the fakes above.
  Provider<ImportTeamUseCase>(
    create: (context) => ImportTeamUseCase(
      pokemonRepository: context.read(),
      itemRepository: context.read(),
      idGenerator: context.read(),
    ),
  ),
];
