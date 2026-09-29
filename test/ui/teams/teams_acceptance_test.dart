import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/domain/models/pokemon_ref.dart';
import 'package:vgc_daily_tracker/domain/models/team.dart';

import '../../../testing/app.dart';

void main() {
  const bigSix = Team(
    id: 't1',
    name: 'Big Six',
    pokemon: [
      PokemonRef(
        id: 10035,
        slug: 'charizard-mega-y',
        displayName: 'Charizard-Mega-Y',
      ),
      PokemonRef(id: 10313, slug: 'floette-mega', displayName: 'Floette-Mega'),
      PokemonRef(
        id: 902,
        slug: 'basculegion-male',
        displayName: 'Basculegion-Male',
      ),
      PokemonRef(id: 983, slug: 'kingambit', displayName: 'Kingambit'),
      PokemonRef(id: 547, slug: 'whimsicott', displayName: 'Whimsicott'),
      PokemonRef(id: 445, slug: 'garchomp', displayName: 'Garchomp'),
    ],
  );

  testWidgets('Teams tab: list a saved team, delete it with confirmation, '
      'and undo', (tester) async {
    await pumpApp(tester, teams: [bigSix]);

    await tester.tap(find.text('Teams'));
    await tester.pumpAndSettle();
    expect(find.text('Big Six'), findsOneWidget);
    expect(find.text('Kingambit'), findsOneWidget);

    await tester.tap(find.byTooltip('Delete Big Six'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();
    expect(find.text('Big Six'), findsNothing);
    expect(find.text('No teams saved yet.'), findsOneWidget);

    await tester.tap(find.widgetWithText(SnackBarAction, 'Undo'));
    await tester.pumpAndSettle();
    expect(find.text('Big Six'), findsOneWidget);
  });
}
