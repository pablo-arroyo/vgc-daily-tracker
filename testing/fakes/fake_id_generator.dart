import 'package:vgc_daily_tracker/utils/id_generator.dart';

/// Predictable ids for tests: `id-1`, `id-2`, ...
class SequentialIdGenerator implements IdGenerator {
  var _count = 0;

  @override
  String next() => 'id-${++_count}';
}
