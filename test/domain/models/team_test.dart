import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/domain/models/pokemon_ref.dart';
import 'package:vgc_daily_tracker/domain/models/pokemon_set.dart';
import 'package:vgc_daily_tracker/domain/models/team.dart';

void main() {
  const team = Team(
    id: 'team-1',
    name: 'Mega Metagross (Worlds)',
    pokemon: [
      PokemonRef(id: 983, slug: 'kingambit', displayName: 'Kingambit'),
      PokemonRef(id: 900, slug: 'kleavor', displayName: 'Kleavor'),
    ],
  );
  const json = {
    'id': 'team-1',
    'name': 'Mega Metagross (Worlds)',
    'pokemon': [
      {'id': 983, 'slug': 'kingambit', 'display_name': 'Kingambit'},
      {'id': 900, 'slug': 'kleavor', 'display_name': 'Kleavor'},
    ],
    'sets': <Object?>[],
    'side': 'mine',
    'notes': '',
  };

  test('serializes to plain JSON storage can hold', () {
    expect(team.toJson(), json);
  });

  test('round-trips through JSON', () {
    expect(Team.fromJson(json), team);
  });

  test('teams saved before sets existed load with no sets', () {
    final legacy = {...json}..remove('sets');

    expect(Team.fromJson(legacy), team);
    expect(team.sets, isEmpty);
  });

  test('teams saved before sides existed load as mine', () {
    final legacy = {...json}..remove('side');

    expect(Team.fromJson(legacy).side, TeamSide.mine);
  });

  test('teams saved before notes existed load with none', () {
    final legacy = {...json}..remove('notes');

    expect(Team.fromJson(legacy).notes, '');
  });

  test('notes round-trip with the team', () {
    final noted = team.copyWith(notes: 'Lead Kingambit + Kleavor.');

    expect(noted.toJson()['notes'], 'Lead Kingambit + Kleavor.');
    expect(Team.fromJson(noted.toJson()), noted);
  });

  test("an opponent's team stores its side", () {
    final opponent = team.copyWith(side: TeamSide.opponent);

    expect(opponent.toJson()['side'], 'opponent');
    expect(Team.fromJson(opponent.toJson()), opponent);
  });

  test('imported sets round-trip with the team', () {
    final imported = team.copyWith(
      sets: const [
        PokemonSet(species: 'Kingambit', moves: ['Protect']),
        PokemonSet(species: 'Kleavor', item: 'Focus Sash'),
      ],
    );

    expect(Team.fromJson(imported.toJson()), imported);
    expect(imported.toJson()['sets'], hasLength(2));
  });
}
