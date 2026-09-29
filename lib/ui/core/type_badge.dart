import 'package:flutter/material.dart';

/// A Pokémon type, e.g. `dark`, shown as a small colored badge.
class TypeBadge extends StatelessWidget {
  const TypeBadge({required this.type, super.key});

  /// PokéAPI type name, lowercase.
  final String type;

  /// The standard type colors (as used by Bulbapedia and Showdown).
  static const _typeColors = {
    'normal': Color(0xFFA8A77A),
    'fire': Color(0xFFEE8130),
    'water': Color(0xFF6390F0),
    'electric': Color(0xFFF7D02C),
    'grass': Color(0xFF7AC74C),
    'ice': Color(0xFF96D9D6),
    'fighting': Color(0xFFC22E28),
    'poison': Color(0xFFA33EA1),
    'ground': Color(0xFFE2BF65),
    'flying': Color(0xFFA98FF3),
    'psychic': Color(0xFFF95587),
    'bug': Color(0xFFA6B91A),
    'rock': Color(0xFFB6A136),
    'ghost': Color(0xFF735797),
    'dragon': Color(0xFF6F35FC),
    'dark': Color(0xFF705746),
    'steel': Color(0xFFB7B7CE),
    'fairy': Color(0xFFD685AD),
  };

  @override
  Widget build(BuildContext context) {
    final background =
        _typeColors[type] ??
        Theme.of(context).colorScheme.surfaceContainerHighest;
    final foreground = background.computeLuminance() > 0.5
        ? Colors.black87
        : Colors.white;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Text(
          type[0].toUpperCase() + type.substring(1),
          style: Theme.of(context).textTheme.labelSmall
              ?.copyWith(color: foreground, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
