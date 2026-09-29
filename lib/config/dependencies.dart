import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../data/repositories/pokemon/pokemon_repository.dart';
import '../data/repositories/pokemon/pokemon_repository_remote.dart';
import '../data/services/pokeapi/poke_api_service.dart';

/// The real app wiring: services first, then the repositories that use them.
/// Providers are lazy, so nothing is created (or fetched) until first read.
///
/// Tests pass their own list with fakes instead (see `testing/app.dart`).
List<SingleChildWidget> providersRemote() => [
  Provider<http.Client>(
    create: (_) => http.Client(),
    dispose: (_, client) => client.close(),
  ),
  Provider<PokeApiService>(
    create: (context) => PokeApiService(client: context.read()),
  ),
  Provider<PokemonRepository>(
    create: (context) => PokemonRepositoryRemote(service: context.read()),
  ),
];
