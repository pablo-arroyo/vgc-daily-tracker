/// Screenshot tests: the whole Progress screen, light and dark, over a fixed
/// dataset, clock and timezone. Update after an intended visual change with
///   flutter test --tags golden --update-goldens
@Tags(['golden'])
library;

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:vgc_daily_tracker/domain/models/game_log.dart';
import 'package:vgc_daily_tracker/domain/models/mistake_category.dart';
import 'package:vgc_daily_tracker/ui/core/theme/app_theme.dart';
import 'package:vgc_daily_tracker/ui/progress/view_models/progress_view_model.dart';
import 'package:vgc_daily_tracker/ui/progress/widgets/progress_screen.dart';

import '../../testing/fakes/fake_game_log_repository.dart';

final now = DateTime.utc(2026, 9, 30, 16); // 10:00 in UTC-6

GameLog game(
  String id,
  int day,
  GameResult result, {
  MistakeCategory? mistake,
  List<String> opponentLeads = const [],
}) => GameLog(
  id: id,
  playedAt: DateTime.utc(2026, 9, day, 18),
  result: result,
  teamId: 't1',
  teamName: 'Big Six',
  team: const [
    'kingambit',
    'whimsicott',
    'garchomp',
    'incineroar',
    'rillaboom',
    'charizard',
  ],
  brought: const ['kingambit', 'whimsicott', 'garchomp', 'incineroar'],
  leads: const ['whimsicott', 'kingambit'],
  opponentTeam: const ['rillaboom', 'sneasler', 'incineroar', 'salamence'],
  opponentLeads: opponentLeads,
  mistake: mistake,
);

final games = [
  game('g1', 30, GameResult.win, opponentLeads: ['rillaboom', 'sneasler']),
  game(
    'g2',
    29,
    GameResult.loss,
    mistake: MistakeCategory.speedCalc,
    opponentLeads: ['rillaboom', 'incineroar'],
  ),
  game(
    'g3',
    28,
    GameResult.loss,
    mistake: MistakeCategory.speedCalc,
    opponentLeads: ['salamence', 'sneasler'],
  ),
  game('g4', 27, GameResult.win, mistake: MistakeCategory.playedWell),
];

void main() {
  for (final (name, theme) in [
    ('light', AppTheme.light),
    ('dark', AppTheme.dark),
  ]) {
    testWidgets('Progress screen, $name', (tester) async {
      tester.view.physicalSize = const Size(412, 1900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await withClock(Clock.fixed(now), () async {
        await tester.pumpWidget(
          MaterialApp(
            theme: theme,
            debugShowCheckedModeBanner: false,
            home: ChangeNotifierProvider(
              create: (_) => ProgressViewModel(
                gameLogRepository: FakeGameLogRepository(games: games),
                toLocal: (utc) => utc.subtract(const Duration(hours: 6)),
              ),
              child: const ProgressScreen(),
            ),
          ),
        );
        await tester.pumpAndSettle();
      });

      await expectLater(
        find.byType(ProgressScreen),
        matchesGoldenFile('progress_$name.png'),
      );
    });
  }
}
