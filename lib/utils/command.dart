import 'package:flutter/foundation.dart';

import 'result.dart';

/// Wraps an async action for the UI: exposes [running], [completed],
/// [error] and [result], and ignores new executions while one is in flight.
///
/// Exceptions thrown by the action become a [Failure]; programming errors
/// (non-[Exception] throwables) are rethrown, but never leave the command
/// stuck in [running].
abstract class Command<T> extends ChangeNotifier {
  bool _running = false;
  Result<T>? _result;

  bool get running => _running;

  bool get completed => _result is Ok<T>;

  bool get error => _result is Failure<T>;

  Result<T>? get result => _result;

  void clearResult() {
    _result = null;
    notifyListeners();
  }

  Future<void> _execute(Future<Result<T>> Function() action) async {
    if (_running) return;
    _running = true;
    _result = null;
    notifyListeners();
    try {
      _result = await action();
    } on Exception catch (e) {
      _result = Result.failure(e);
    } finally {
      _running = false;
      notifyListeners();
    }
  }
}

/// A [Command] whose action takes no argument.
class Command0<T> extends Command<T> {
  Command0(this._action);

  final Future<Result<T>> Function() _action;

  Future<void> execute() => _execute(_action);
}

/// A [Command] whose action takes one argument of type [A].
class Command1<T, A> extends Command<T> {
  Command1(this._action);

  final Future<Result<T>> Function(A) _action;

  Future<void> execute(A argument) => _execute(() => _action(argument));
}
