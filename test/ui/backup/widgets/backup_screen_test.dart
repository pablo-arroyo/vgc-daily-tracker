import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:vgc_daily_tracker/domain/models/team.dart';
import 'package:vgc_daily_tracker/ui/backup/view_models/backup_view_model.dart';
import 'package:vgc_daily_tracker/ui/backup/widgets/backup_screen.dart';
import 'package:vgc_daily_tracker/ui/core/theme/app_theme.dart';

import '../../../../testing/clipboard.dart';
import '../../../../testing/fakes/fake_game_log_repository.dart';
import '../../../../testing/fakes/fake_routine_repository.dart';
import '../../../../testing/fakes/fake_team_repository.dart';

void main() {
  late FakeTeamRepository teams;

  Future<void> pumpBackup(
    WidgetTester tester, {
    List<Team> seed = const [],
  }) async {
    teams = FakeTeamRepository(teams: seed);
    await tester.pumpWidget(
      MaterialApp(
        // A fresh key per pump: a second pump is a new app, not a rebuild
        // that would keep the first view model.
        key: UniqueKey(),
        theme: AppTheme.light,
        home: ChangeNotifierProvider(
          create: (_) => BackupViewModel(
            teamRepository: teams,
            gameLogRepository: FakeGameLogRepository(),
            routineRepository: FakeRoutineRepository(),
          ),
          child: const BackupScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Copy backup puts the JSON on the clipboard and says what it '
      'holds', (tester) async {
    final clipboard = FakeClipboard(tester);
    await pumpBackup(
      tester,
      seed: const [Team(id: 't1', name: 'Big Six', pokemon: [])],
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Copy backup'));
    await tester.pumpAndSettle();

    expect(clipboard.text, contains('"app": "vgc_daily_tracker"'));
    expect(clipboard.text, contains('Big Six'));
    expect(
      find.text('Backup copied: 1 team, 0 games, 0 routine days'),
      findsOneWidget,
    );
  });

  testWidgets('Restore merges a pasted backup and says what came back', (
    tester,
  ) async {
    final clipboard = FakeClipboard(tester);
    await pumpBackup(
      tester,
      seed: const [Team(id: 't1', name: 'Big Six', pokemon: [])],
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Copy backup'));
    await tester.pumpAndSettle();
    final text = clipboard.text!;
    await pumpBackup(tester); // an empty app

    await tester.enterText(
      find.widgetWithText(TextField, 'Paste a backup here'),
      text,
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Restore'));
    await tester.pumpAndSettle();

    expect(
      find.text('Restored 1 team, 0 games, 0 routine days'),
      findsOneWidget,
    );
    expect((await teams.watchAll().first).single.name, 'Big Six');
  });

  testWidgets("says why pasted text can't be restored", (tester) async {
    await pumpBackup(tester);

    await tester.enterText(
      find.widgetWithText(TextField, 'Paste a backup here'),
      'hello',
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Restore'));
    await tester.pumpAndSettle();

    expect(find.text("This isn't a backup: it's not JSON."), findsOneWidget);
  });
}
