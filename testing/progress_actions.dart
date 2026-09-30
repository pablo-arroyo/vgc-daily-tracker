import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Scrolls the current screen's list back to the top, then down until
/// [finder] is built and shown (lower cards are built lazily, as for a user).
Future<void> scrollTo(WidgetTester tester, Finder finder) async {
  final list = find.byType(Scrollable).last;
  await tester.drag(list, const Offset(0, 10000));
  await tester.pumpAndSettle();
  await tester.dragUntilVisible(finder, list, const Offset(0, -200));
  await tester.pumpAndSettle();
}
