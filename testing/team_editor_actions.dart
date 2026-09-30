import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Types [query] into the Pokémon field labelled [label] and picks [option]
/// from the suggestions.
Future<void> pickPokemon(
  WidgetTester tester, {
  required String label,
  required String query,
  required String option,
}) async {
  await tester.enterText(find.widgetWithText(TextField, label), query);
  await tester.pumpAndSettle();
  await tester.tap(find.text(option));
  await tester.pumpAndSettle();
}

/// Taps the editor's sticky Save button.
Future<void> tapSave(WidgetTester tester) async {
  await tester.tap(find.widgetWithText(FilledButton, 'Save team'));
  await tester.pumpAndSettle();
}

/// From the Teams tab: Add team → name → six picks → Save.
Future<void> createTeam(
  WidgetTester tester, {
  required String name,
  required List<(String query, String option)> picks,
}) async {
  await tester.tap(find.byTooltip('Add team'));
  await tester.pumpAndSettle();
  await tester.enterText(find.widgetWithText(TextField, 'Team name'), name);
  for (final (index, (query, option)) in picks.indexed) {
    await pickPokemon(
      tester,
      label: 'Pokémon ${index + 1}',
      query: query,
      option: option,
    );
  }
  await tapSave(tester);
}
