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
}
