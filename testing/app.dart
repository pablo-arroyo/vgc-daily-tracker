import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:vgc_daily_tracker/data/repositories/game_log/game_log_repository.dart';
import 'package:vgc_daily_tracker/data/repositories/pokemon/pokemon_repository.dart';
import 'package:vgc_daily_tracker/data/repositories/team/team_repository.dart';
import 'package:vgc_daily_tracker/main.dart';

import 'fakes/fake_game_log_repository.dart';
import 'fakes/fake_pokemon_repository.dart';
import 'fakes/fake_team_repository.dart';

/// Builds the whole app and waits until it has settled on its first screen.
///
/// Shared by widget tests (`test/`) and integration tests
/// (`integration_test/`), always with [providersFake].
Future<void> pumpApp(WidgetTester tester) async {
  await tester.pumpWidget(VgcApp(providers: providersFake()));
  await tester.pumpAndSettle();
}

/// The app's dependencies, all fake: no network, no disk.
List<SingleChildWidget> providersFake() => [
  Provider<PokemonRepository>(create: (_) => FakePokemonRepository()),
  Provider<TeamRepository>(create: (_) => FakeTeamRepository()),
  Provider<GameLogRepository>(create: (_) => FakeGameLogRepository()),
];
