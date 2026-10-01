import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/domain/models/game_log.dart';
import 'package:vgc_daily_tracker/domain/models/mistake_category.dart';

import '../../testing/app.dart';

final now = DateTime.utc(2026, 9, 30, 12);

/// Played games, so Progress shows every card.
final games = [
  for (var i = 0; i < 4; i++)
    GameLog(
      id: 'g$i',
      playedAt: now.subtract(Duration(days: i)),
      result: i.isEven ? GameResult.win : GameResult.loss,
      teamId: 't1',
      teamName: 'Big Six',
      leads: const ['kingambit', 'whimsicott'],
      opponentLeads: const ['rillaboom', 'incineroar'],
      mistake: MistakeCategory.speedCalc,
    ),
];

/// Runs [check] on each page of the current screen, scrolling its main list
/// from top to bottom so lazily built rows are laid out and checked too.
Future<void> everyPage(
  WidgetTester tester,
  Future<void> Function() check,
) async {
  await check();
  final view = find.byWidgetPredicate(
    (w) => w is ScrollView || w is SingleChildScrollView,
  );
  if (view.evaluate().isEmpty) return;
  final scrollable = tester.state<ScrollableState>(
    find.descendant(of: view.first, matching: find.byType(Scrollable)).first,
  );
  final position = scrollable.position;
  while (position.pixels < position.maxScrollExtent) {
    position.jumpTo(
      (position.pixels + position.viewportDimension * 0.8).clamp(
        0,
        position.maxScrollExtent,
      ),
    );
    await tester.pumpAndSettle();
    await check();
  }
  position.jumpTo(0);
  await tester.pumpAndSettle();
}

/// Visits every screen, running [check] on each: the four tabs, the team
/// editor, the Showdown import, and a team's detail screen.
Future<void> visitEveryScreen(
  WidgetTester tester,
  Future<void> Function(String screen) check,
) async {
  await withClock(Clock.fixed(now), () async {
    await pumpApp(tester, games: games);
    await check('Routine');

    await tester.tap(find.text('Teams'));
    await tester.pumpAndSettle();
    await check('Teams (empty)');
    await tester.tap(find.text('Add Reg M-C sample teams'));
    await tester.pumpAndSettle();
    await check('Teams');

    await tester.tap(find.text('Big Six'));
    await tester.pumpAndSettle();
    await check('Team detail');
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Add team'));
    await tester.pumpAndSettle();
    await check('Team editor');
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Import from Showdown'));
    await tester.pumpAndSettle();
    await check('Import');
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Log Game'));
    await tester.pumpAndSettle();
    await check('Log Game');

    await tester.tap(find.text('Progress'));
    await tester.pumpAndSettle();
    await check('Progress');
  });
}

void main() {
  for (final brightness in Brightness.values) {
    testWidgets('every screen meets the contrast, label and tap-target '
        'guidelines (${brightness.name})', (tester) async {
      tester.platformDispatcher.platformBrightnessTestValue = brightness;
      addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
      final semantics = tester.ensureSemantics();

      await visitEveryScreen(
        tester,
        (screen) => everyPage(tester, () async {
          for (final (name, guideline) in [
            ('text contrast', textContrastGuideline),
            ('labeled tap targets', labeledTapTargetGuideline),
            ('Android tap targets', androidTapTargetGuideline),
            ('iOS tap targets', iOSTapTargetGuideline),
          ]) {
            await expectLater(
              tester,
              meetsGuideline(guideline),
              reason: '$screen: $name',
            );
          }
        }),
      );
      semantics.dispose();
    });
  }

  testWidgets('every screen lays out at 200 % text size', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    final visited = <String>[];

    // An overflow fails the test on its own; this records how far it got.
    await visitEveryScreen(
      tester,
      (screen) => everyPage(tester, () async => visited.add(screen)),
    );

    expect(visited.toSet(), hasLength(8));
  });
}
