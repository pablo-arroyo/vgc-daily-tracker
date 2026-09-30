import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/domain/models/team.dart';

import '../../../testing/app.dart';

void main() {
  testWidgets('the "Deleted" snackbar does not cover Add team', (tester) async {
    await pumpApp(
      tester,
      teams: [const Team(id: 't1', name: 'Big Six', pokemon: [])],
    );
    await tester.tap(find.text('Teams'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Delete Big Six'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();
    expect(find.text('Deleted Big Six'), findsOneWidget);

    final addTeam = find.byTooltip('Add team');
    expect(
      tester
          .hitTestOnBinding(tester.getCenter(addTeam))
          .path
          .any(
            (entry) =>
                entry.target ==
                tester.renderObject(
                  find
                      .descendant(
                        of: addTeam,
                        matching: find.byType(RawMaterialButton),
                      )
                      .first,
                ),
          ),
      isTrue,
      reason: 'Add team is covered',
    );
  });
}
