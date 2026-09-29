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
  static PokemonRef? resolve(List<PokemonRef> refs, String name) {
    final slug = normalize(name);
    final expanded = _expandShowdownGender(slug);
    PokemonRef? exact(String s) => refs.where((r) => r.slug == s).firstOrNull;
    // An exact slug wins, so real `nidoran-f` isn't "expanded".
    return exact(slug) ?? exact(expanded) ?? _defaultForm(refs, expanded);
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
