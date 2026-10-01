import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// From the Teams tab: Import from Showdown → name → paste → Import team.
Future<void> importTeam(
  WidgetTester tester, {
  required String name,
  required String paste,
}) async {
  await tester.tap(find.byTooltip('Import from Showdown'));
  await tester.pumpAndSettle();
  await tester.enterText(find.widgetWithText(TextField, 'Team name'), name);
  await tester.enterText(
    find.widgetWithText(TextField, 'Showdown paste'),
    paste,
  );
  await tester.tap(find.widgetWithText(FilledButton, 'Import team'));
  await tester.pumpAndSettle();
}

/// The speed shown for [name] in the team detail's Speed order list.
Finder speedTier(String name) => find.descendant(
  of: find.widgetWithText(ListTile, name),
  matching: find.byKey(const ValueKey('speed')),
);
