import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:vgc_daily_tracker/data/repositories/game_log/game_log_repository.dart';
import 'package:vgc_daily_tracker/domain/models/game_log.dart';
import 'package:vgc_daily_tracker/domain/models/mistake_category.dart';
import 'package:vgc_daily_tracker/domain/models/team.dart';
import 'package:vgc_daily_tracker/ui/log_game/widgets/log_game_screen.dart';

import '../../../testing/app.dart';
import '../../../testing/fakes/fake_pokemon_repository.dart';
import '../../../testing/log_game_actions.dart';
import '../../../testing/team_editor_actions.dart';

final bigSix = Team(
  id: 't1',
  name: 'Big Six',
  pokemon: [
    for (final slug in [
      'kingambit',
      'whimsicott',
      'garchomp',
      'incineroar',
      'rillaboom',
      'charizard',
    ])
      FakePokemonRepository.sampleRef(slug),
  ],
);

void main() {
  testWidgets('log a full game: result, team picks, opponent, mistake, notes', (
    tester,
  ) async {
    await pumpApp(tester, teams: [bigSix]);
    await tester.tap(find.text('Log Game'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Win'));
    await selectDropdownItem(tester, 'Your team used', 'Big Six');
    for (final name in ['Kingambit', 'Whimsicott', 'Garchomp', 'Incineroar']) {
      await tapChip(tester, section: 'your-brought', name: name);
    }
    await tapChip(tester, section: 'your-leads', name: 'Whimsicott');
    await tapChip(tester, section: 'your-leads', name: 'Kingambit');

    await pickPokemon(
      tester,
      label: 'Opp. Pokémon 1',
      query: 'rilla',
      option: 'Rillaboom',
    );
    await pickPokemon(
      tester,
      label: 'Opp. Pokémon 2',
      query: 'raichu',
      option: 'Raichu-Mega-Y',
    );
    await tapChip(tester, section: 'opponent-brought', name: 'Rillaboom');
    await tapChip(tester, section: 'opponent-leads', name: 'Rillaboom');

    await selectDropdownItem(
      tester,
      'What decided this game?',
      MistakeCategory.speedCalc.label,
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Notes'),
      'Check Tailwind turns.',
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Save game'));
    await tester.pumpAndSettle();

    expect(find.text('Game logged ✓'), findsOneWidget);
    expect(find.text('Check Tailwind turns.'), findsNothing, reason: 'reset');

    final repository = tester
        .element(find.byType(LogGameScreen))
        .read<GameLogRepository>();
    final [saved] = await repository.watchAll().first;
    expect(saved.result, GameResult.win);
    expect(saved.teamName, 'Big Six');
    expect(saved.brought, [
      'kingambit',
      'whimsicott',
      'garchomp',
      'incineroar',
    ]);
    expect(saved.leads, ['whimsicott', 'kingambit']);
    expect(saved.opponentTeam, ['rillaboom', 'raichu-mega-y']);
    expect(saved.opponentBrought, ['rillaboom']);
    expect(saved.opponentLeads, ['rillaboom']);
    expect(saved.mistake, MistakeCategory.speedCalc);
    expect(saved.notes, 'Check Tailwind turns.');
  });
}
