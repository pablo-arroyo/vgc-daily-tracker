import 'package:freezed_annotation/freezed_annotation.dart';

part 'item_api_model.freezed.dart';
part 'item_api_model.g.dart';

/// `GET /item/{slug}`, keeping only the fields the app reads.
@freezed
abstract class ItemApiModel with _$ItemApiModel {
  const factory ItemApiModel({required int id, required String name}) =
      _ItemApiModel;

  factory ItemApiModel.fromJson(Map<String, Object?> json) =>
      _$ItemApiModelFromJson(json);
}
