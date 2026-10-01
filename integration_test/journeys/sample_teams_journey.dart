import 'package:flutter_test/flutter_test.dart';

import '../../testing/app.dart';

/// An empty Teams tab adds the format's sample teams in one tap.
void sampleTeamsJourney() {
  testWidgets('add the Reg M-C sample teams: exactly 3 appear', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('Teams'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add Reg M-C sample teams'));
    await tester.pumpAndSettle();

    for (final name in [
      'Big Six',
      'Mega Metagross (Worlds 2026)',
      'Rillaboom / Sneasler Grassy Offense',
    ]) {
      expect(find.text(name), findsOneWidget);
    }
    expect(find.byTooltip(RegExp('^Delete ')), findsNWidgets(3));
  });
}
