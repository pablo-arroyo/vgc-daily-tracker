import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/domain/models/team.dart';

import '../../../testing/app.dart';
import '../../../testing/fakes/fake_pokemon_repository.dart';

void main() {
  final rival = Team(
    id: 'o1',
    name: 'Rival Grassy',
    side: TeamSide.opponent,
    pokemon: [FakePokemonRepository.sampleRef('rillaboom')],
  );

  testWidgets("write notes on an opponent's team; they're there when you "
      'come back', (tester) async {
    await pumpApp(tester, teams: [rival]);
    await tester.tap(find.text('Teams'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Opponents'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Rival Grassy'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextField, 'Notes'),
      'Sneasler runs Unburden: Fake Out it turn 1.',
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Save notes'));
    await tester.pumpAndSettle();
    expect(find.text('Notes saved'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Rival Grassy'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TextField>(find.widgetWithText(TextField, 'Notes'))
          .controller
          ?.text,
      'Sneasler runs Unburden: Fake Out it turn 1.',
    );
  });
}
