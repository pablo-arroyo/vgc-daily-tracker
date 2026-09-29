import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/ui/core/pokemon_avatar.dart';

void main() {
  const url =
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/983.png';

  Future<void> pumpAvatar(WidgetTester tester) => tester.pumpWidget(
    const MaterialApp(
      home: PokemonAvatar(spriteUrl: url, name: 'Kingambit'),
    ),
  );

  testWidgets('fades the sprite in from a transparent placeholder', (
    tester,
  ) async {
    await pumpAvatar(tester);

    final image = tester.widget<FadeInImage>(find.byType(FadeInImage));
    expect(image.image, const NetworkImage(url));
    expect(image.imageSemanticLabel, 'Kingambit');
  });

  testWidgets('shows a labelled fallback when the sprite fails to load', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    // Test environments answer every network image with an HTTP error.
    await pumpAvatar(tester);
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.catching_pokemon), findsOneWidget);
    expect(find.bySemanticsLabel('Kingambit'), findsOneWidget);
    semantics.dispose();
  });
}
