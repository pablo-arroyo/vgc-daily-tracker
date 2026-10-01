import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../data/repositories/game_log/game_log_repository.dart';
import '../data/repositories/game_log/game_log_repository_local.dart';
import '../data/repositories/item/item_repository.dart';
import '../data/repositories/item/item_repository_remote.dart';
import '../data/repositories/pokemon/pokemon_repository.dart';
import '../data/repositories/pokemon/pokemon_repository_remote.dart';
import '../data/repositories/routine/routine_repository.dart';
import '../data/repositories/routine/routine_repository_local.dart';
import '../data/repositories/team/team_repository.dart';
import '../data/repositories/team/team_repository_local.dart';
import '../data/services/pokeapi/poke_api_service.dart';
import '../data/services/storage/local_storage_service.dart';
import '../utils/id_generator.dart';

/// The real app wiring: services first, then the repositories that use them.
/// Providers are lazy, so nothing is created (or fetched) until first read.
/// [storage] is opened in `main()`, because opening the database is async.
///
/// Tests pass their own list with fakes instead (see `testing/app.dart`).
List<SingleChildWidget> providersRemote({
  required LocalStorageService storage,
}) => [
  Provider<LocalStorageService>.value(value: storage),
  Provider<IdGenerator>(create: (_) => RandomIdGenerator()),
  Provider<http.Client>(
    create: (_) => http.Client(),
    dispose: (_, client) => client.close(),
  ),
  Provider<PokeApiService>(
    create: (context) => PokeApiService(client: context.read()),
  ),
  Provider<PokemonRepository>(
    create: (context) => PokemonRepositoryRemote(
      service: context.read(),
      storage: context.read(),
    ),
  ),
  Provider<ItemRepository>(
    create: (context) => ItemRepositoryRemote(service: context.read()),
  ),
  Provider<TeamRepository>(
    create: (context) => TeamRepositoryLocal(storage: context.read()),
  ),
  Provider<GameLogRepository>(
    create: (context) => GameLogRepositoryLocal(storage: context.read()),
  ),
  Provider<RoutineRepository>(
    create: (context) => RoutineRepositoryLocal(storage: context.read()),
  ),
];
