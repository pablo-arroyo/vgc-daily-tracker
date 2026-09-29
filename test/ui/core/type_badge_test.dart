import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/ui/core/type_badge.dart';

void main() {
  Future<void> pumpBadge(WidgetTester tester, String type) =>
      tester.pumpWidget(MaterialApp(home: TypeBadge(type: type)));

  testWidgets('shows the capitalized type name', (tester) async {
    await pumpBadge(tester, 'dark');

    expect(find.text('Dark'), findsOneWidget);
  });

  BoxDecoration decorationOf(WidgetTester tester) =>
      tester.widget<DecoratedBox>(find.byType(DecoratedBox)).decoration
          as BoxDecoration;
  Color? textColorOf(WidgetTester tester) =>
      tester.widget<Text>(find.byType(Text)).style?.color;

  testWidgets('uses the type color with readable text', (tester) async {
    await pumpBadge(tester, 'dark');
    expect(decorationOf(tester).color, const Color(0xFF705746));
    expect(textColorOf(tester), Colors.white);

    await pumpBadge(tester, 'electric');
    expect(decorationOf(tester).color, const Color(0xFFF7D02C));
    expect(textColorOf(tester), Colors.black87);
  });

  testWidgets('falls back to a neutral color for an unknown type', (
    tester,
  ) async {
    await pumpBadge(tester, 'stellar');

    final context = tester.element(find.byType(TypeBadge));
    expect(
      decorationOf(tester).color,
      Theme.of(context).colorScheme.surfaceContainerHighest,
    );
  });
}
