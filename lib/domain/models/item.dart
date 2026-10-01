import 'package:freezed_annotation/freezed_annotation.dart';

part 'item.freezed.dart';

/// A held item PokéAPI knows, e.g. `raichunite-y`.
@freezed
abstract class Item with _$Item {
  const factory Item({required int id, required String slug}) = _Item;
}
