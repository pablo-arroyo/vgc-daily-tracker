/// Why a PokéAPI call failed. Returned inside `Result.failure`, never thrown
/// across layers.
sealed class PokeApiException implements Exception {
  const PokeApiException();
}

/// The resource doesn't exist (HTTP 404), e.g. a mistyped slug.
final class PokeApiNotFound extends PokeApiException {
  const PokeApiNotFound(this.path);

  final String path;
}

/// PokéAPI answered, but not with something usable: an unexpected status
/// code ([statusCode] set) or a body that doesn't parse ([statusCode] 200).
final class PokeApiBadResponse extends PokeApiException {
  const PokeApiBadResponse(this.path, {required this.statusCode});

  final String path;
  final int statusCode;
}

/// PokéAPI couldn't be reached: no connection, DNS failure or timeout.
final class PokeApiNetworkUnavailable extends PokeApiException {
  const PokeApiNetworkUnavailable(this.path);

  final String path;
}
