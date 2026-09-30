import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../testing/app.dart';

void main() {
  testWidgets('the "Game logged" snackbar does not cover Save game', (
    tester,
  ) async {
    // Regression: the shell's Scaffold showed the snackbar above the tab bar,
    // right over this screen's sticky Save button, for ~4 seconds.
    await pumpApp(tester);
    await tester.tap(find.text('Log Game'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Win'));
    await tester.tap(find.widgetWithText(FilledButton, 'Save game'));
    await tester.pumpAndSettle();
    expect(find.text('Game logged ✓'), findsOneWidget);

    // Tap Save again while the confirmation is still showing: it must reach
    // the button (the reset form then asks for a result).
    final save = find.widgetWithText(FilledButton, 'Save game');
    expect(
      tester
          .hitTestOnBinding(tester.getCenter(save))
          .path
          .any((entry) => entry.target == tester.renderObject(save)),
      isTrue,
      reason: 'Save game is covered',
    );
  });
}
