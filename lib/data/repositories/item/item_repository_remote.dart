import '../../../domain/models/item.dart';
import '../../../utils/result.dart';
import '../../services/pokeapi/poke_api_service.dart';
import '../pokemon/pokemon_names.dart';
import 'item_repository.dart';

/// [ItemRepository] on PokéAPI, caching each item found.
class ItemRepositoryRemote implements ItemRepository {
  ItemRepositoryRemote({required this._service});

  final PokeApiService _service;
  final _items = <String, Item>{};

  @override
  Future<Result<Item>> resolve(String name) async {
    // Item slugs follow the same rules as Pokémon slugs.
    final slug = PokemonNames.normalize(name);
    final cached = _items[slug];
    if (cached != null) return Result.ok(cached);

    switch (await _service.getItem(slug)) {
      case Ok(:final value):
        return Result.ok(_items[slug] = Item(id: value.id, slug: value.name));
      case Failure(:final error):
        return Result.failure(error);
    }
  }
}
