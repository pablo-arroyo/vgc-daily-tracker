import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../testing/app.dart';
import '../../../testing/fakes/fake_routine_repository.dart';

void main() {
  testWidgets('Routine: three checklists; ticks survive an app restart', (
    tester,
  ) async {
    final storage = FakeRoutineRepository();
    await pumpApp(tester, routine: storage);

    for (final title in [
      'Before the game',
      'During the game',
      'After the game',
    ]) {
      expect(find.text(title), findsOneWidget);
    }
    expect(
      find.byType(CheckboxListTile, skipOffstage: false),
      findsNWidgets(12),
    );

    const item =
        'Check speed order before committing to a move you assume '
        'goes first.';
    await tester.ensureVisible(find.text(item));
    await tester.tap(find.text(item));
    await tester.pumpAndSettle();

    // "Restart": a brand-new app over the same storage.
    await tester.pumpWidget(const SizedBox.shrink());
    await pumpApp(tester, routine: storage);
    await tester.ensureVisible(find.text(item));

    final tile = tester.widget<CheckboxListTile>(
      find.ancestor(
        of: find.text(item),
        matching: find.byType(CheckboxListTile),
      ),
    );
    expect(tile.value, isTrue);
  });
}
