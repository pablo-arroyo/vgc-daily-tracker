import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/utils/command.dart';
import 'package:vgc_daily_tracker/utils/result.dart';

void main() {
  group('Command0', () {
    test('starts idle with no result', () {
      final command = Command0<int>(() async => const Result.ok(1));

      expect(command.running, isFalse);
      expect(command.completed, isFalse);
      expect(command.error, isFalse);
      expect(command.result, isNull);
    });

    test('execute stores an Ok result and marks completed', () async {
      final command = Command0<int>(() async => const Result.ok(7));

      await command.execute();

      expect(command.completed, isTrue);
      expect(command.error, isFalse);
      expect(command.running, isFalse);
      expect((command.result! as Ok<int>).value, 7);
    });

    test('execute stores a Failure result and marks error', () async {
      final exception = Exception('offline');
      final command = Command0<int>(() async => Result.failure(exception));

      await command.execute();

      expect(command.error, isTrue);
      expect(command.completed, isFalse);
      expect((command.result! as Failure<int>).error, same(exception));
    });

    test('is running while the action is in flight', () async {
      final gate = Completer<Result<int>>();
      final command = Command0<int>(() => gate.future);

      final execution = command.execute();
      expect(command.running, isTrue);

      gate.complete(const Result.ok(1));
      await execution;
      expect(command.running, isFalse);
    });

    test('notifies listeners when execution starts and when it ends', () async {
      final gate = Completer<Result<int>>();
      final command = Command0<int>(() => gate.future);
      var notifications = 0;
      command.addListener(() => notifications++);

      final execution = command.execute();
      expect(notifications, 1);

      gate.complete(const Result.ok(1));
      await execution;
      expect(notifications, 2);
    });

    test('ignores execute while already running', () async {
      final gate = Completer<Result<int>>();
      var calls = 0;
      final command = Command0<int>(() {
        calls++;
        return gate.future;
      });

      final first = command.execute();
      final second = command.execute();
      gate.complete(const Result.ok(1));
      await Future.wait([first, second]);

      expect(calls, 1);
    });

    test('captures an exception thrown by the action as a Failure', () async {
      final exception = Exception('thrown');
      final command = Command0<int>(() async => throw exception);

      await command.execute();

      expect(command.error, isTrue);
      expect(command.running, isFalse);
      expect((command.result! as Failure<int>).error, same(exception));
    });

    test('rethrows a programming error but stops running', () async {
      final command = Command0<int>(() async => throw StateError('bug'));

      await expectLater(command.execute(), throwsStateError);
      expect(command.running, isFalse);
    });

    test('clears the previous result when a new execution starts', () async {
      var gate = Completer<Result<int>>()
        ..complete(Result.failure(Exception('first')));
      final command = Command0<int>(() => gate.future);
      await command.execute();
      expect(command.error, isTrue);

      gate = Completer<Result<int>>();
      final retry = command.execute();
      expect(command.result, isNull);
      expect(command.error, isFalse);

      gate.complete(const Result.ok(2));
      await retry;
      expect(command.completed, isTrue);
    });

    test('clearResult forgets the result and notifies listeners', () async {
      final command = Command0<int>(
        () async => Result.failure(Exception('shown once')),
      );
      await command.execute();
      var notifications = 0;
      command.addListener(() => notifications++);

      command.clearResult();

      expect(command.result, isNull);
      expect(command.error, isFalse);
      expect(notifications, 1);
    });
  });

  group('Command1', () {
    test('passes the argument to the action and stores its result', () async {
      final command = Command1<int, String>(
        (text) async => Result.ok(text.length),
      );

      await command.execute('Kingambit');

      expect(command.completed, isTrue);
      expect((command.result! as Ok<int>).value, 9);
    });
  });
}
