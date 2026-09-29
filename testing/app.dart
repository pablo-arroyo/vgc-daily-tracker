import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/main.dart';

/// Builds the whole app and waits until it has settled on its first screen.
///
/// Shared by widget tests (`test/`) and integration tests
/// (`integration_test/`). Dependency overrides get added here once the app
/// has dependencies to inject (roadmap step 1.2).
Future<void> pumpApp(WidgetTester tester) async {
  await tester.pumpWidget(const VgcApp());
  await tester.pumpAndSettle();
}
