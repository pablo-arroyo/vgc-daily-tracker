import '../../../utils/result.dart';

/// Which routine items are ticked, per local day (`yyyy-MM-dd`). Each day
/// starts empty, so the checklist resets daily.
abstract class RoutineRepository {
  Future<Result<Set<String>>> checkedOn(String day);

  /// Replaces the ticked item ids for [day].
  Future<Result<void>> save(String day, Set<String> checked);
}
