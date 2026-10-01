import 'dart:async';

import 'package:vgc_daily_tracker/data/repositories/routine/routine_repository.dart';
import 'package:vgc_daily_tracker/utils/result.dart';

/// In-memory [RoutineRepository]; passes the same contract as the real one.
class FakeRoutineRepository implements RoutineRepository {
  final _days = <String, Set<String>>{};
  final _changes = StreamController<String>.broadcast();

  /// When set, `save` fails with it and changes nothing.
  Exception? failWith;

  @override
  Future<Result<Set<String>>> checkedOn(String day) async =>
      Result.ok({...?_days[day]});

  @override
  Stream<Set<String>> watchOn(String day) async* {
    yield {...?_days[day]};
    yield* _changes.stream
        .where((changed) => changed == day)
        .map((_) => {...?_days[day]});
  }

  @override
  Future<Result<Map<String, Set<String>>>> allDays() async => Result.ok({
    for (final MapEntry(key: day, value: checked) in _days.entries)
      day: {...checked},
  });

  @override
  Future<Result<void>> save(String day, Set<String> checked) async {
    if (failWith case final error?) return Result.failure(error);
    _days[day] = {...checked};
    _changes.add(day);
    return const Result.ok(null);
  }
}
