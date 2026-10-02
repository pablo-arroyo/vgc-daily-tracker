import 'package:flutter_test/flutter_test.dart';

import '../../testing/app.dart';

void main() {
  testWidgets(
    'Log Game always offers the Their team picker, and says how to fill it',
    (tester) async {
      await pumpApp(tester);
      await tester.tap(find.text('Log Game'));
      await tester.pumpAndSettle();

      expect(find.text('Their team'), findsOneWidget);
      expect(
        find.text(
          'No saved opponent teams yet. Add one in Teams → Opponents.',
        ),
        findsOneWidget,
      );
    },
  );
}
