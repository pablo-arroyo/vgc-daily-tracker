import '../../../domain/models/item.dart';
import '../../../utils/result.dart';

/// Source of truth for held items.
abstract class ItemRepository {
  /// The item a Showdown-style [name] refers to, e.g. `Raichunite Y` →
  /// `raichunite-y`. Fails with `PokeApiNotFound` for an unknown item.
  Future<Result<Item>> resolve(String name);
}
