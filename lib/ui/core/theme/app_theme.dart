import 'package:flutter/material.dart';

/// Light and dark Material 3 themes using the original tracker's palette.
abstract final class AppTheme {
  static final light = _build(
    brightness: Brightness.light,
    accent: const Color(0xFF5B5BD6),
    background: const Color(0xFFF7F7FB),
    colors: AppColors.light,
  );

  static final dark = _build(
    brightness: Brightness.dark,
    accent: const Color(0xFF8A8AFF),
    background: const Color(0xFF14141F),
    colors: AppColors.dark,
  );

  static ThemeData _build({
    required Brightness brightness,
    required Color accent,
    required Color background,
    required AppColors colors,
  }) {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: accent,
        primary: accent,
        brightness: brightness,
      ),
      scaffoldBackgroundColor: background,
      extensions: [colors],
    );
  }
}

/// Semantic colors from the original tracker that Material's ColorScheme has
/// no slot for: the accent's soft background, results (win/loss) and the
/// picker chips (your lead, opponent's brought, opponent's lead). Each has a
/// soft background variant.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.accentSoft,
    required this.win,
    required this.winSoft,
    required this.loss,
    required this.lossSoft,
    required this.lead,
    required this.leadSoft,
    required this.opp,
    required this.oppSoft,
    required this.oppLead,
    required this.oppLeadSoft,
  });

  /// The theme's [AppColors], or the matching light/dark default if the
  /// theme doesn't carry them (e.g. a bare ThemeData in a test), rather than
  /// crashing on a missing color.
  static AppColors of(BuildContext context) {
    final theme = Theme.of(context);
    return theme.extension<AppColors>() ??
        (theme.brightness == Brightness.dark ? dark : light);
  }

  static const light = AppColors(
    accentSoft: Color(0xFFEEEEFF),
    win: Color(0xFF1E9E5A),
    winSoft: Color(0xFFE6F7EE),
    loss: Color(0xFFD64545),
    lossSoft: Color(0xFFFDEAEA),
    lead: Color(0xFFB8860B),
    leadSoft: Color(0xFFFFF6E0),
    opp: Color(0xFFC2410C),
    oppSoft: Color(0xFFFFF1E8),
    oppLead: Color(0xFF9333EA),
    oppLeadSoft: Color(0xFFF5ECFF),
  );

  static const dark = AppColors(
    accentSoft: Color(0xFF26264A),
    win: Color(0xFF4ADE8A),
    winSoft: Color(0xFF16301F),
    loss: Color(0xFFF27979),
    lossSoft: Color(0xFF331A1A),
    lead: Color(0xFFFFC857),
    leadSoft: Color(0xFF3A2F10),
    opp: Color(0xFFFF8A5C),
    oppSoft: Color(0xFF3A2416),
    oppLead: Color(0xFFCF9FFF),
    oppLeadSoft: Color(0xFF2E2140),
  );

  final Color accentSoft;
  final Color win;
  final Color winSoft;
  final Color loss;
  final Color lossSoft;
  final Color lead;
  final Color leadSoft;
  final Color opp;
  final Color oppSoft;
  final Color oppLead;
  final Color oppLeadSoft;

  @override
  AppColors copyWith({
    Color? accentSoft,
    Color? win,
    Color? winSoft,
    Color? loss,
    Color? lossSoft,
    Color? lead,
    Color? leadSoft,
    Color? opp,
    Color? oppSoft,
    Color? oppLead,
    Color? oppLeadSoft,
  }) {
    return AppColors(
      accentSoft: accentSoft ?? this.accentSoft,
      win: win ?? this.win,
      winSoft: winSoft ?? this.winSoft,
      loss: loss ?? this.loss,
      lossSoft: lossSoft ?? this.lossSoft,
      lead: lead ?? this.lead,
      leadSoft: leadSoft ?? this.leadSoft,
      opp: opp ?? this.opp,
      oppSoft: oppSoft ?? this.oppSoft,
      oppLead: oppLead ?? this.oppLead,
      oppLeadSoft: oppLeadSoft ?? this.oppLeadSoft,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;
    return AppColors(
      accentSoft: Color.lerp(accentSoft, other.accentSoft, t)!,
      win: Color.lerp(win, other.win, t)!,
      winSoft: Color.lerp(winSoft, other.winSoft, t)!,
      loss: Color.lerp(loss, other.loss, t)!,
      lossSoft: Color.lerp(lossSoft, other.lossSoft, t)!,
      lead: Color.lerp(lead, other.lead, t)!,
      leadSoft: Color.lerp(leadSoft, other.leadSoft, t)!,
      opp: Color.lerp(opp, other.opp, t)!,
      oppSoft: Color.lerp(oppSoft, other.oppSoft, t)!,
      oppLead: Color.lerp(oppLead, other.oppLead, t)!,
      oppLeadSoft: Color.lerp(oppLeadSoft, other.oppLeadSoft, t)!,
    );
  }
}
