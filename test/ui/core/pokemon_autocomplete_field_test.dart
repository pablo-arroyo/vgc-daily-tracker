import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/domain/models/pokemon_ref.dart';
import 'package:vgc_daily_tracker/ui/core/pokemon_autocomplete_field.dart';
import 'package:vgc_daily_tracker/utils/result.dart';

import '../../../testing/fakes/fake_pokemon_repository.dart';

void main() {
  final repository = FakePokemonRepository();
  Future<List<PokemonRef>> search(String query) async =>
      switch (await repository.search(query)) {
        Ok(:final value) => value,
        Failure() => const [],
      };

  late List<PokemonRef?> changes;

  Future<void> pumpField(WidgetTester tester) {
    changes = [];
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PokemonAutocompleteField(
            label: 'Pokémon 1',
            search: search,
            onChanged: changes.add,
          ),
        ),
      ),
    );
  }

  testWidgets('suggests matching Pokémon as you type', (tester) async {
    await pumpField(tester);

    await tester.enterText(find.byType(TextField), 'king');
    await tester.pumpAndSettle();

    expect(find.text('Kingambit'), findsOneWidget);
    expect(find.text('Raichu-Mega-Y'), findsNothing);
  });

  testWidgets('picking a suggestion reports it and fills in its name', (
    tester,
  ) async {
    await pumpField(tester);
    await tester.enterText(find.byType(TextField), 'king');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Kingambit'));
    await tester.pumpAndSettle();

    expect(changes.last?.slug, 'kingambit');
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller?.text,
      'Kingambit',
    );
  });

  testWidgets('rejects a typo instead of storing it', (tester) async {
    await pumpField(tester);
    expect(find.text('Pokémon 1'), findsOneWidget, reason: 'field label');

    await tester.enterText(find.byType(TextField), 'Kingambt');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(changes.whereType<PokemonRef>(), isEmpty);
    expect(find.text('Pick a Pokémon from the list'), findsOneWidget);
  });

  testWidgets('editing the text after a pick withdraws the pick', (
    tester,
  ) async {
    await pumpField(tester);
    await tester.enterText(find.byType(TextField), 'king');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kingambit'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Kingambi');
    await tester.pump();

    expect(changes.last, isNull);
  });

  testWidgets('picking a Pokémon after an error clears the error', (
    tester,
  ) async {
    await pumpField(tester);
    await tester.enterText(find.byType(TextField), 'Kingambt');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'king');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kingambit'));
    await tester.pumpAndSettle();

    expect(find.text('Pick a Pokémon from the list'), findsNothing);
  });

  testWidgets('starts from an initial Pokémon, which counts as picked', (
    tester,
  ) async {
    changes = [];
    const kingambit = PokemonRef(
      id: 983,
      slug: 'kingambit',
      displayName: 'Kingambit',
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PokemonAutocompleteField(
            label: 'Pokémon 1',
            search: search,
            onChanged: changes.add,
            initialValue: kingambit,
          ),
        ),
      ),
    );

    expect(
      tester.widget<TextField>(find.byType(TextField)).controller?.text,
      'Kingambit',
    );
    await tester.showKeyboard(find.byType(TextField));
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(find.text('Pick a Pokémon from the list'), findsNothing);

    await tester.enterText(find.byType(TextField), 'Kingam');
    await tester.pump();
    expect(changes.last, isNull, reason: 'editing withdraws the initial pick');
  });
}
