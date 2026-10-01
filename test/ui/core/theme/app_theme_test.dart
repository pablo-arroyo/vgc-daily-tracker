import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/ui/core/theme/app_theme.dart';

void main() {
  group('AppTheme', () {
    test('light and dark themes have the matching brightness', () {
      expect(AppTheme.light.brightness, Brightness.light);
      expect(AppTheme.dark.brightness, Brightness.dark);
    });

    test('both themes carry AppColors with the original tracker palette', () {
      final light = AppTheme.light.extension<AppColors>()!;
      final dark = AppTheme.dark.extension<AppColors>()!;

      expect(light.win, const Color(0xFF1E9E5A));
      expect(dark.win, const Color(0xFF4ADE8A));
      expect(light.loss, const Color(0xFFD64545));
      expect(dark.loss, const Color(0xFFF27979));
    });
  });

  test('text on the accent meets WCAG AA (4.5:1) in both themes', () {
    double contrast(Color a, Color b) {
      final (light, dark) = (
        a.computeLuminance() > b.computeLuminance() ? a : b,
        a.computeLuminance() > b.computeLuminance() ? b : a,
      );
      return (light.computeLuminance() + 0.05) /
          (dark.computeLuminance() + 0.05);
    }

    for (final theme in [AppTheme.light, AppTheme.dark]) {
      final scheme = theme.colorScheme;
      expect(
        contrast(scheme.primary, scheme.onPrimary),
        greaterThanOrEqualTo(4.5),
        reason: '${theme.brightness}',
      );
    }
  });

  group('AppColors', () {
    test('lerp returns each end at t = 0 and t = 1', () {
      final light = AppTheme.light.extension<AppColors>()!;
      final dark = AppTheme.dark.extension<AppColors>()!;

      expect(light.lerp(dark, 0).win, light.win);
      expect(light.lerp(dark, 1).oppLead, dark.oppLead);
    });

    test('copyWith replaces only the given color', () {
      final light = AppTheme.light.extension<AppColors>()!;

      final changed = light.copyWith(lead: Colors.pink);

      expect(changed.lead, Colors.pink);
      expect(changed.win, light.win);
    });
  });

  group('AppColors.of', () {
    Future<AppColors> colorsUnder(WidgetTester tester, ThemeData theme) async {
      late AppColors colors;
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: Builder(
            builder: (context) {
              colors = AppColors.of(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      // MaterialApp animates between themes; read the settled value.
      await tester.pumpAndSettle();
      return colors;
    }

    testWidgets('reads the theme extension', (tester) async {
      expect(await colorsUnder(tester, AppTheme.dark), AppColors.dark);
    });

    testWidgets('falls back to the matching default when the theme lacks it', (
      tester,
    ) async {
      expect(await colorsUnder(tester, ThemeData.light()), AppColors.light);
      expect(await colorsUnder(tester, ThemeData.dark()), AppColors.dark);
    });
  });
}
