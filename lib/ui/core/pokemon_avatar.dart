import 'dart:typed_data';

import 'package:flutter/material.dart';

/// A Pokémon sprite that fades in (GPU-cheap, unlike `Opacity`) and falls
/// back to an icon if the image can't load, e.g. offline.
class PokemonAvatar extends StatelessWidget {
  const PokemonAvatar({required this.spriteUrl, required this.name, super.key});

  final String spriteUrl;

  /// Read by screen readers, whether the sprite or the fallback shows.
  final String name;

  static const _size = 40.0;

  /// A 1×1 transparent PNG to fade in from.
  static final _transparentPixel = Uint8List.fromList(const [
    0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, //
    0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, //
    0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00, //
    0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00, //
    0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49, //
    0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82, //
  ]);

  @override
  Widget build(BuildContext context) {
    return FadeInImage(
      placeholder: MemoryImage(_transparentPixel),
      image: NetworkImage(spriteUrl),
      imageSemanticLabel: name,
      width: _size,
      height: _size,
      // No label of its own: FadeInImage's [imageSemanticLabel] already
      // covers the fallback, and a second one is read out twice.
      imageErrorBuilder: (context, error, stackTrace) => Icon(
        Icons.catching_pokemon,
        size: _size,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
