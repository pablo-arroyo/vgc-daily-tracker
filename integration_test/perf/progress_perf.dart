// Profile-mode run, not part of `flutter test integration_test` (no
// `_test.dart` suffix). Run with the command in test_driver/perf_driver.dart.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../../testing/app.dart';
import '../../testing/generated_games.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Progress with 1,000 games: open, show all, scroll', (
    tester,
  ) async {
    await pumpApp(tester, games: generateGames(1000, now: DateTime.now()));

    await binding.traceAction(() async {
      await tester.tap(find.text('Progress'));
      await tester.pumpAndSettle();

      final list = find.byType(Scrollable).last;
      await tester.dragUntilVisible(
        find.text('Show all (1000)'),
        list,
        const Offset(0, -300),
      );
      await tester.tap(find.text('Show all (1000)'));
      await tester.pumpAndSettle();

      // Fling through the long list and back, like a player browsing.
      for (var i = 0; i < 6; i++) {
        await tester.fling(list, const Offset(0, -1500), 3000);
        await tester.pumpAndSettle();
      }
      for (var i = 0; i < 6; i++) {
        await tester.fling(list, const Offset(0, 1500), 3000);
        await tester.pumpAndSettle();
      }
    }, reportKey: 'progress_1000_games');
  });
}
