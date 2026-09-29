import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';

import '../../../utils/result.dart';
import 'models/pokemon_detail_api_model.dart';
import 'models/pokemon_list_api_model.dart';
import 'poke_api_exception.dart';

/// Stateless client for https://pokeapi.co/api/v2. Returns API models that
/// mirror the JSON; mapping to domain models is the repositories' job.
class PokeApiService {
  PokeApiService({
    required this._client,
    this._timeout = const Duration(seconds: 10),
  });

  final http.Client _client;
  final Duration _timeout;

  static const _baseUrl = 'https://pokeapi.co/api/v2';

  Future<Result<PokemonListApiModel>> getPokemonList({required int limit}) =>
      _getJson('/pokemon?limit=$limit', PokemonListApiModel.fromJson);

  Future<Result<PokemonDetailApiModel>> getPokemon(String slug) =>
      _getJson('/pokemon/$slug', PokemonDetailApiModel.fromJson);

  /// Every failure comes back as a [Failure] holding a [PokeApiException].
  /// Nothing is thrown.
  Future<Result<T>> _getJson<T>(
    String path,
    T Function(Map<String, Object?> json) parse,
  ) async {
    final http.Response response;
    try {
      response = await _client
          .get(Uri.parse('$_baseUrl$path'))
          .timeout(_timeout);
    } on http.ClientException {
      return Result.failure(PokeApiNetworkUnavailable(path));
    } on TimeoutException {
      return Result.failure(PokeApiNetworkUnavailable(path));
    }

    return switch (response.statusCode) {
      200 => _decode(path, response.body, parse),
      404 => Result.failure(PokeApiNotFound(path)),
      final status => Result.failure(
        PokeApiBadResponse(path, statusCode: status),
      ),
    };
  }

  Result<T> _decode<T>(
    String path,
    String body,
    T Function(Map<String, Object?> json) parse,
  ) {
    final unparseable = Result<T>.failure(
      PokeApiBadResponse(path, statusCode: 200),
    );
    try {
      final json = jsonDecode(body);
      return json is Map<String, Object?>
          ? Result.ok(parse(json))
          : unparseable;
    } on FormatException {
      return unparseable;
    } on CheckedFromJsonException {
      return unparseable;
    }
  }
}
