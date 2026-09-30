import '../../../domain/models/pokemon_ref.dart';

/// Rules that map what people type (or paste from Showdown) onto PokéAPI
/// slugs, and slugs back onto display names.
abstract final class PokemonNames {
  /// Turns a typed name into slug form: `Mr. Mime` → `mr-mime`,
  /// `Farfetch’d` → `farfetchd`, `Flabébé` → `flabebe`, `Nidoran♀` →
  /// `nidoran-f`.
  static String normalize(String name) => name
      .trim()
      .toLowerCase()
      .replaceAll('♀', '-f')
      .replaceAll('♂', '-m')
      .replaceAll('é', 'e')
      .replaceAll(RegExp(r"[.:'’]"), '')
      .replaceAll(RegExp(r'\s+'), '-');

  /// `raichu-mega-y` → `Raichu-Mega-Y`, the Showdown-style name.
  static String displayName(String slug) => slug
      .split('-')
      .map(
        (part) =>
            part.isEmpty ? part : part[0].toUpperCase() + part.substring(1),
      )
      .join('-');

  /// Finds the index entry a typed or Showdown-style [name] refers to, or
  /// null. Never guesses from a partial name; that's what search is for.
  /// When [item] is that Pokémon's Mega Stone, its Mega is returned instead.
  static PokemonRef? resolve(
    List<PokemonRef> refs,
    String name, {
    String? item,
  }) {
    final slug = normalize(name);
    final expanded = _expandShowdownGender(slug);
    // An exact slug wins, so real `nidoran-f` isn't "expanded".
    final named =
        _exact(refs, slug) ??
        _exact(refs, expanded) ??
        _defaultForm(refs, expanded);
    if (named == null || item == null) return named;
    return _megaHolding(refs, named, item) ?? named;
  }

  static PokemonRef? _exact(List<PokemonRef> refs, String slug) =>
      refs.where((r) => r.slug == slug).firstOrNull;

  /// A stone is the species' name (sometimes minus its last letter, or plus
  /// an `n`) + `ite`, with an optional X / Y / Z: `metagrossite`,
  /// `salamencite`, `raichunite-y`, `garchompite-z`.
  static final _megaStone = RegExp(r'^(.+?)n?ite(-[xyz])?$');

  /// [named]'s Mega if [item] is its stone and the index has that Mega.
  /// `Eviolite` or another species' stone matches nothing.
  static PokemonRef? _megaHolding(
    List<PokemonRef> refs,
    PokemonRef named,
    String item,
  ) {
    final stone = _megaStone.firstMatch(normalize(item));
    if (stone == null || !named.slug.startsWith(stone.group(1)!)) return null;
    return _exact(refs, '${named.slug}-mega${stone.group(2) ?? ''}');
  }

  /// Showdown writes gendered forms as `-F` / `-M`; PokéAPI spells them out.
  static String _expandShowdownGender(String slug) => slug
      .replaceFirst(RegExp(r'-f$'), '-female')
      .replaceFirst(RegExp(r'-m$'), '-male');

  /// A species without a bare slug is listed by its forms, and its default
  /// form has the species' own (lowest) id: `basculegion` →
  /// `basculegion-male` (902), not `basculegion-female` (10248). It also
  /// fills in suffixes Showdown drops: `ogerpon-wellspring` →
  /// `ogerpon-wellspring-mask`.
  static PokemonRef? _defaultForm(List<PokemonRef> refs, String slug) {
    final forms = refs.where((r) => r.slug.startsWith('$slug-'));
    return forms.isEmpty ? null : forms.reduce((a, b) => a.id <= b.id ? a : b);
  }
}
