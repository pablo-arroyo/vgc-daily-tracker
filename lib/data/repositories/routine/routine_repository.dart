import '../../../utils/result.dart';

/// Which routine items are ticked, per local day (`yyyy-MM-dd`). Each day
/// starts empty, so the checklist resets daily.
abstract class RoutineRepository {
  Future<Result<Set<String>>> checkedOn(String day);

  /// The ticked item ids for [day], emitted now and again after each change
  /// to that day (e.g. a restored backup).
  Stream<Set<String>> watchOn(String day);

  /// Every saved day with its ticked item ids (e.g. for a backup).
  Future<Result<Map<String, Set<String>>>> allDays();

  /// Replaces the ticked item ids for [day].
  Future<Result<void>> save(String day, Set<String> checked);
}
