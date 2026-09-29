/// The outcome of an operation that can fail: either [Ok] with a value or
/// [Failure] with an exception. Repositories return this instead of throwing,
/// so errors cross layers as values.
///
/// Named `Failure` rather than `Error` to avoid shadowing `dart:core`'s
/// [Error].
sealed class Result<T> {
  const Result();

  const factory Result.ok(T value) = Ok<T>._;

  const factory Result.failure(Exception error) = Failure<T>._;
}

final class Ok<T> extends Result<T> {
  const Ok._(this.value);

  final T value;
}

final class Failure<T> extends Result<T> {
  const Failure._(this.error);

  final Exception error;
}
