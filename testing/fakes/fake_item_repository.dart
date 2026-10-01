import 'package:vgc_daily_tracker/data/repositories/item/item_repository.dart';
import 'package:vgc_daily_tracker/data/repositories/pokemon/pokemon_names.dart';
import 'package:vgc_daily_tracker/data/services/pokeapi/poke_api_exception.dart';
import 'package:vgc_daily_tracker/domain/models/item.dart';
import 'package:vgc_daily_tracker/utils/result.dart';

/// In-memory [ItemRepository]: knows the items of the Reg M-C artifact's
/// teams (plain Dart data, so it also works on a device).
class FakeItemRepository implements ItemRepository {
  FakeItemRepository({Set<String>? slugs}) : _slugs = slugs ?? sampleItems;

  final Set<String> _slugs;

  /// When set, `resolve` fails with it (e.g. offline).
  Exception? failWith;

  @override
  Future<Result<Item>> resolve(String name) async {
    if (failWith case final error?) return Result.failure(error);
    final slug = PokemonNames.normalize(name);
    if (!_slugs.contains(slug)) return Result.failure(PokeApiNotFound(slug));
    // Ids aren't used by the app; a stable stand-in will do.
    return Result.ok(Item(id: slug.hashCode, slug: slug));
  }

  static const sampleItems = {
    'chople-berry',
    'focus-sash',
    'metagrossite',
    'fairy-feather',
    'raichunite-y',
    'life-orb',
    'miracle-seed',
    'grassy-seed',
    'rocky-helmet',
    'salamencite',
    'light-clay',
    'charizardite-y',
    'floettite',
    'mystic-water',
    'sitrus-berry',
  };
}
