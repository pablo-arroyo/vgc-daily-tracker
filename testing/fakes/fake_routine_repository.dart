import 'package:vgc_daily_tracker/data/repositories/routine/routine_repository.dart';
import 'package:vgc_daily_tracker/utils/result.dart';

/// In-memory [RoutineRepository]; passes the same contract as the real one.
class FakeRoutineRepository implements RoutineRepository {
  final _days = <String, Set<String>>{};

  /// When set, `save` fails with it and changes nothing.
  Exception? failWith;

  @override
  Future<Result<Set<String>>> checkedOn(String day) async =>
      Result.ok({...?_days[day]});

  @override
  Future<Result<void>> save(String day, Set<String> checked) async {
    if (failWith case final error?) return Result.failure(error);
    _days[day] = {...checked};
    return const Result.ok(null);
  }
}
