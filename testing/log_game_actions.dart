import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Taps the Pokémon chip [name] inside the chip section keyed [section]
/// (`your-brought`, `your-leads`, `opponent-brought`, `opponent-leads`).
Future<void> tapChip(
  WidgetTester tester, {
  required String section,
  required String name,
}) async {
  final chip = find.descendant(
    of: find.byKey(ValueKey(section)),
    matching: find.text(name),
  );
  await tester.ensureVisible(chip);
  await tester.pumpAndSettle();
  await tester.tap(chip);
  await tester.pumpAndSettle();
}

/// Opens the dropdown labelled [label] and picks [item].
Future<void> selectDropdownItem(
  WidgetTester tester,
  String label,
  String item,
) async {
  final dropdown = find.ancestor(
    of: find.text(label),
    matching: find.byWidgetPredicate((w) => w is DropdownButtonFormField),
  );
  await tester.ensureVisible(dropdown);
  await tester.pumpAndSettle();
  await tester.tap(dropdown);
  await tester.pumpAndSettle();
  await tester.tap(find.text(item).last);
  await tester.pumpAndSettle();
}
