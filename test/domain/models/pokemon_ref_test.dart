import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/domain/models/pokemon_ref.dart';

void main() {
  const ref = PokemonRef(
    id: 902,
    slug: 'basculegion-male',
    displayName: 'Basculegion-Male',
  );
  const json = {
    'id': 902,
    'slug': 'basculegion-male',
    'display_name': 'Basculegion-Male',
  };

  test('serializes to the pinned storage shape', () {
    expect(ref.toJson(), json);
  });

  test('round-trips through JSON', () {
    expect(PokemonRef.fromJson(json), ref);
  });

  test('derives its sprite URL from the id, with no network call', () {
    expect(
      ref.spriteUrl,
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/902.png',
    );
  });
}
