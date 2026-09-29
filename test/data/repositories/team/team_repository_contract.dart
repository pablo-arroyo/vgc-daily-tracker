import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/data/repositories/team/team_repository.dart';
import 'package:vgc_daily_tracker/domain/models/pokemon_ref.dart';
import 'package:vgc_daily_tracker/domain/models/team.dart';
import 'package:vgc_daily_tracker/utils/result.dart';

/// Behavior every [TeamRepository] must have. Run against the real
/// implementation and the fake, so screen tests can trust the fake.
void teamRepositoryContract(Future<TeamRepository> Function() create) {
  late TeamRepository repository;

  setUp(() async => repository = await create());

  Team team(String id, String name) => Team(
    id: id,
    name: name,
    pokemon: const [
      PokemonRef(id: 983, slug: 'kingambit', displayName: 'Kingambit'),
    ],
  );

  test('a saved team appears in watchAll', () async {
    final saved = await repository.save(team('t1', 'Big Six'));

    expect(saved, isA<Ok<void>>());
    expect(await repository.watchAll().first, [team('t1', 'Big Six')]);
  });

  test('saving an existing id replaces that team (editing)', () async {
    await repository.save(team('t1', 'Big Six'));

    await repository.save(team('t1', 'Big Six v2'));

    expect(await repository.watchAll().first, [team('t1', 'Big Six v2')]);
  });

  test('lists teams alphabetically, ignoring case', () async {
    await repository.save(team('t1', 'rillaboom offense'));
    await repository.save(team('t2', 'Big Six'));
    await repository.save(team('t3', 'Mega Metagross'));

    final names = (await repository.watchAll().first).map((t) => t.name);

    expect(names, ['Big Six', 'Mega Metagross', 'rillaboom offense']);
  });

  test('delete removes the team, and watchers see it go', () async {
    await repository.save(team('t1', 'Big Six'));
    await repository.save(team('t2', 'Mega Metagross'));
    final emissions = repository.watchAll().take(2).toList();
    await Future<void>.delayed(Duration.zero);

    final deleted = await repository.delete('t1');

    expect(deleted, isA<Ok<void>>());
    final [before, after] = await emissions;
    expect(before.map((t) => t.id), ['t1', 't2']);
    expect(after.map((t) => t.id), ['t2']);
  });
}
