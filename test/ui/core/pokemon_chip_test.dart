import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/ui/core/pokemon_chip.dart';
import 'package:vgc_daily_tracker/ui/core/theme/app_theme.dart';

void main() {
  Future<void> pumpChip(
    WidgetTester tester, {
    PokemonChipRole role = PokemonChipRole.none,
    VoidCallback? onTap,
  }) => tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(
        body: PokemonChip(label: 'Kingambit', role: role, onTap: onTap),
      ),
    ),
  );

  testWidgets('tells screen readers the role, not only the color', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    for (final (role, label) in [
      (PokemonChipRole.none, 'Kingambit'),
      (PokemonChipRole.brought, 'Kingambit, brought'),
      (PokemonChipRole.lead, 'Kingambit, lead'),
      (PokemonChipRole.opponentBrought, 'Kingambit, opponent brought'),
      (PokemonChipRole.opponentLead, 'Kingambit, opponent lead'),
    ]) {
      await pumpChip(tester, role: role, onTap: () {});

      expect(find.bySemanticsLabel(label), findsOneWidget, reason: '$role');
    }
    semantics.dispose();
  });

  testWidgets('shows the name and reports taps', (tester) async {
    var taps = 0;
    await pumpChip(tester, onTap: () => taps++);

    await tester.tap(find.text('Kingambit'));

    expect(taps, 1);
  });

  testWidgets('styles each role with the original tracker colors and marks '
      'picked chips as selected', (tester) async {
    final scheme = AppTheme.light.colorScheme;
    const colors = AppColors.light;
    // role: (border and text, background, selected)
    final expected = {
      PokemonChipRole.none: (scheme.outlineVariant, scheme.surface, false),
      PokemonChipRole.brought: (scheme.primary, colors.accentSoft, true),
      PokemonChipRole.lead: (colors.lead, colors.leadSoft, true),
      PokemonChipRole.opponentBrought: (colors.opp, colors.oppSoft, true),
      PokemonChipRole.opponentLead: (colors.oppLead, colors.oppLeadSoft, true),
    };

    for (final MapEntry(key: role, value: (fg, bg, selected))
        in expected.entries) {
      await pumpChip(tester, role: role);

      final box = tester.widget<DecoratedBox>(
        find.descendant(
          of: find.byType(PokemonChip),
          matching: find.byType(DecoratedBox),
        ),
      );
      final decoration = box.decoration as BoxDecoration;
      expect(decoration.color, bg, reason: '$role background');
      expect((decoration.border! as Border).top.color, fg, reason: '$role');
      if (role != PokemonChipRole.none) {
        expect(
          tester.widget<Text>(find.text('Kingambit')).style?.color,
          fg,
          reason: '$role text',
        );
      }
      final semantics = tester.widget<Semantics>(
        find
            .descendant(
              of: find.byType(PokemonChip),
              matching: find.byType(Semantics),
            )
            .first,
      );
      expect(semantics.properties.selected, selected, reason: '$role');
    }
  });
}
