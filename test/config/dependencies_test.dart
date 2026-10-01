import 'package:flutter/material.dart';
import 'package:vgc_daily_tracker/data/repositories/item/item_repository.dart';
import 'package:vgc_daily_tracker/data/repositories/item/item_repository_remote.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:vgc_daily_tracker/config/dependencies.dart';
import 'package:vgc_daily_tracker/data/repositories/game_log/game_log_repository.dart';
import 'package:vgc_daily_tracker/data/repositories/game_log/game_log_repository_local.dart';
import 'package:vgc_daily_tracker/data/repositories/pokemon/pokemon_repository.dart';
import 'package:vgc_daily_tracker/data/repositories/pokemon/pokemon_repository_remote.dart';
import 'package:vgc_daily_tracker/data/repositories/routine/routine_repository.dart';
import 'package:vgc_daily_tracker/data/repositories/routine/routine_repository_local.dart';
import 'package:vgc_daily_tracker/data/repositories/team/team_repository.dart';
import 'package:vgc_daily_tracker/data/repositories/team/team_repository_local.dart';
import 'package:vgc_daily_tracker/data/services/storage/local_storage_service.dart';
import 'package:vgc_daily_tracker/ui/routine/widgets/routine_screen.dart';
import 'package:vgc_daily_tracker/utils/id_generator.dart';

import '../../testing/app.dart';
import '../../testing/fakes/fake_game_log_repository.dart';
import '../../testing/fakes/fake_item_repository.dart';
import '../../testing/fakes/fake_id_generator.dart';
import '../../testing/fakes/fake_pokemon_repository.dart';
import '../../testing/fakes/fake_routine_repository.dart';
import '../../testing/fakes/fake_team_repository.dart';
import '../../testing/storage.dart';

void main() {
  testWidgets('the app built with fake dependencies exposes a '
      'PokemonRepository to its screens', (tester) async {
    await pumpApp(tester);

    final context = tester.element(find.byType(RoutineScreen));
    expect(context.read<PokemonRepository>(), isA<FakePokemonRepository>());
    expect(context.read<TeamRepository>(), isA<FakeTeamRepository>());
    expect(context.read<GameLogRepository>(), isA<FakeGameLogRepository>());
    expect(context.read<IdGenerator>(), isA<SequentialIdGenerator>());
    expect(context.read<RoutineRepository>(), isA<FakeRoutineRepository>());
    expect(context.read<ItemRepository>(), isA<FakeItemRepository>());
  });

  testWidgets('providersRemote wires the real PokemonRepositoryRemote', (
    tester,
  ) async {
    final storage = (await tester.runAsync(memoryStorage))!;
    late PokemonRepository repository;
    late LocalStorageService providedStorage;
    late TeamRepository teams;
    late GameLogRepository games;
    late IdGenerator ids;
    late RoutineRepository routine;
    late ItemRepository items;
    await tester.pumpWidget(
      MultiProvider(
        providers: providersRemote(storage: storage),
        child: Builder(
          builder: (context) {
            repository = context.read<PokemonRepository>();
            providedStorage = context.read<LocalStorageService>();
            teams = context.read<TeamRepository>();
            games = context.read<GameLogRepository>();
            ids = context.read<IdGenerator>();
            routine = context.read<RoutineRepository>();
            items = context.read<ItemRepository>();
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(repository, isA<PokemonRepositoryRemote>());
    expect(providedStorage, same(storage));
    expect(teams, isA<TeamRepositoryLocal>());
    expect(games, isA<GameLogRepositoryLocal>());
    expect(ids, isA<RandomIdGenerator>());
    expect(routine, isA<RoutineRepositoryLocal>());
    expect(items, isA<ItemRepositoryRemote>());
  });
}
