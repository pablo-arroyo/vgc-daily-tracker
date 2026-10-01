import 'package:flutter/material.dart';

import 'theme/app_theme.dart';

/// What a chip marks in the bring/lead pickers.
enum PokemonChipRole {
  none(null),
  brought('brought'),
  lead('lead'),
  opponentBrought('opponent brought'),
  opponentLead('opponent lead');

  const PokemonChipRole(this.spoken);

  /// Read after the name by screen readers, since the role is otherwise
  /// shown only by color.
  final String? spoken;
}

/// A tappable Pokémon name used by the bring/lead pickers, colored by its
/// [role] like the original tracker's chips.
class PokemonChip extends StatelessWidget {
  const PokemonChip({
    required this.label,
    required this.role,
    required this.onTap,
    super.key,
  });

  final String label;
  final PokemonChipRole role;
  final VoidCallback? onTap;

  static final _radius = BorderRadius.circular(20);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final colors = AppColors.of(context);
    final (foreground, background) = switch (role) {
      PokemonChipRole.none => (scheme.outlineVariant, scheme.surface),
      PokemonChipRole.brought => (scheme.primary, colors.accentSoft),
      PokemonChipRole.lead => (colors.lead, colors.leadSoft),
      PokemonChipRole.opponentBrought => (colors.opp, colors.oppSoft),
      PokemonChipRole.opponentLead => (colors.oppLead, colors.oppLeadSoft),
    };
    final picked = role != PokemonChipRole.none;
    return Semantics(
      selected: picked,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: _radius,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: background,
            border: Border.all(color: foreground, width: 1.5),
            borderRadius: _radius,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              label,
              semanticsLabel: role.spoken == null
                  ? label
                  : '$label, ${role.spoken}',
              style: Theme.of(context).textTheme.labelLarge
                  ?.copyWith(color: picked ? foreground : scheme.onSurface),
            ),
          ),
        ),
      ),
    );
  }
}
