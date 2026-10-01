import '../../../domain/models/type_chart.dart';
import '../../../utils/result.dart';

/// Source of truth for type matchups.
abstract class TypeRepository {
  /// The full type chart for the 18 battle types.
  Future<Result<TypeChart>> chart();
}
