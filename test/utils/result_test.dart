import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/utils/result.dart';

void main() {
  group('Result', () {
    test('ok wraps a value in an Ok', () {
      const Result<int> result = Result.ok(42);

      expect(result, isA<Ok<int>>());
      expect((result as Ok<int>).value, 42);
    });

    test('failure wraps an exception in a Failure', () {
      final exception = Exception('boom');
      final Result<int> result = Result.failure(exception);

      expect(result, isA<Failure<int>>());
      expect((result as Failure<int>).error, same(exception));
    });
  });
}
