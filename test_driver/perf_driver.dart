import 'package:flutter_driver/flutter_driver.dart' as driver;
import 'package:integration_test/integration_test_driver.dart';

/// Host side of the profile-mode runs in `integration_test/perf/`. Writes
/// each traced action's frame timings to
/// `build/<name>.timeline_summary.json`.
///
///   flutter drive --profile -d macos --driver=test_driver/perf_driver.dart \
///     --target=integration_test/perf/progress_perf.dart
Future<void> main() => integrationDriver(
  responseDataCallback: (data) async {
    for (final MapEntry(key: name, value: timeline) in (data ?? {}).entries) {
      final summary = driver.TimelineSummary.summarize(
        driver.Timeline.fromJson(timeline as Map<String, dynamic>),
      );
      await summary.writeTimelineToFile(
        name,
        pretty: true,
        includeSummary: true,
      );
    }
  },
);
