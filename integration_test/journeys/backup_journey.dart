import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/domain/models/team.dart';

import '../../testing/app.dart';
import '../../testing/clipboard.dart';

/// Backup on the real app: copy, then restore into a fresh app. Uses a fake
/// clipboard so test runs never overwrite the developer's real one.
void backupJourney() {
  testWidgets('copy a backup and restore it into a fresh app', (tester) async {
    final clipboard = FakeClipboard(tester);
    await pumpApp(
      tester,
      teams: const [Team(id: 't1', name: 'Big Six', pokemon: [])],
    );
    await tester.tap(find.byTooltip('Backup & restore'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Copy backup'));
    await tester.pumpAndSettle();

    await pumpApp(tester);
    await tester.tap(find.byTooltip('Backup & restore'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'Paste a backup here'),
      clipboard.text!,
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Restore'));
    await tester.pumpAndSettle();
    expect(
      find.text('Restored 1 team, 0 games, 0 routine days'),
      findsOneWidget,
    );

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Teams'));
    await tester.pumpAndSettle();
    expect(find.text('Big Six'), findsOneWidget);
  });
}
