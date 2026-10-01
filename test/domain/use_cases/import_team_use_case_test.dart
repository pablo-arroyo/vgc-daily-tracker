import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/domain/models/team.dart';
import 'package:vgc_daily_tracker/domain/use_cases/import_team_use_case.dart';
import 'package:vgc_daily_tracker/utils/result.dart';

import '../../../testing/fakes/fake_id_generator.dart';
import '../../../testing/fakes/fake_item_repository.dart';
import '../../../testing/fakes/fake_pokemon_repository.dart';
import '../../../testing/showdown_pastes.dart';

void main() {
  ImportTeamUseCase create() => ImportTeamUseCase(
    pokemonRepository: FakePokemonRepository(),
    itemRepository: FakeItemRepository(),
    idGenerator: SequentialIdGenerator(),
  );

  test('builds a checked team with a new id, without saving it', () async {
    final result = await create()(name: ' Worlds ', paste: team1Paste);

    final team = (result as Ok<Team>).value;
    expect(team.id, 'id-1');
    expect(team.name, 'Worlds');
    expect(team.pokemon.map((p) => p.slug).first, 'kingambit');
    expect(team.sets, hasLength(6));
  });

  test('reports every problem found', () async {
    final result = await create()(name: '', paste: team1Paste);

    expect(((result as Failure<Team>).error as TeamImportError).problems, [
      'Give the team a name.',
    ]);
  });
}
