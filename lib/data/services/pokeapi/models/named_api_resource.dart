import 'package:freezed_annotation/freezed_annotation.dart';

part 'named_api_resource.freezed.dart';
part 'named_api_resource.g.dart';

/// PokéAPI's `{name, url}` reference to another resource.
@freezed
abstract class NamedApiResource with _$NamedApiResource {
  const factory NamedApiResource({required String name, required String url}) =
      _NamedApiResource;

  factory NamedApiResource.fromJson(Map<String, Object?> json) =>
      _$NamedApiResourceFromJson(json);
}
