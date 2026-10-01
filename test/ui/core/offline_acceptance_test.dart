import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/data/services/pokeapi/poke_api_exception.dart';

import '../../../testing/app.dart';
import '../../../testing/fakes/fake_pokemon_repository.dart';

const offlineMessage = "Can't reach PokéAPI. Keep typing to try again.";

void main() {
  testWidgets('offline, the Pokémon fields say why there are no suggestions, '
      'and recover once back online', (tester) async {
    final pokemon = FakePokemonRepository()
      ..failWith = const PokeApiNetworkUnavailable('/pokemon');
    await pumpApp(tester, pokemon: pokemon);
    await tester.tap(find.text('Teams'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Add team'));
    await tester.pumpAndSettle();
    final field = find.widgetWithText(TextField, 'Pokémon 1');

    await tester.enterText(field, 'king');
    await tester.pumpAndSettle();
    expect(find.text(offlineMessage), findsOneWidget);

    pokemon.failWith = null; // back online
    await tester.enterText(field, 'kinga');
    await tester.pumpAndSettle();
    expect(find.text(offlineMessage), findsNothing);
    expect(
      find.descendant(
        of: find.byType(ListView),
        matching: find.text('Kingambit'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('Log Game opponent fields explain offline too', (tester) async {
    final pokemon = FakePokemonRepository()
      ..failWith = const PokeApiNetworkUnavailable('/pokemon');
    await pumpApp(tester, pokemon: pokemon);
    await tester.tap(find.text('Log Game'));
    await tester.pumpAndSettle();

    final field = find.widgetWithText(TextField, 'Opp. Pokémon 1');
    await tester.ensureVisible(field);
    await tester.enterText(field, 'rilla');
    await tester.pumpAndSettle();

    expect(find.text(offlineMessage), findsOneWidget);
  });
}
