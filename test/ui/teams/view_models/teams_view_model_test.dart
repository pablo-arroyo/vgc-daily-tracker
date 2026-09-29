import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/domain/models/team.dart';
import 'package:vgc_daily_tracker/ui/teams/view_models/teams_view_model.dart';

import '../../../../testing/fakes/fake_team_repository.dart';

void main() {
  const bigSix = Team(id: 't1', name: 'Big Six', pokemon: []);
  const metagross = Team(id: 't2', name: 'Mega Metagross', pokemon: []);

  late FakeTeamRepository repository;
  late TeamsViewModel viewModel;

  setUp(() {
    repository = FakeTeamRepository(teams: [metagross, bigSix]);
    viewModel = TeamsViewModel(teamRepository: repository);
  });
  tearDown(() => viewModel.dispose());

  test('is not loaded until the teams arrive, then lists them', () async {
    // Created here, not in setUp: the first emission lands before the test
    // body would run.
    final fresh = TeamsViewModel(teamRepository: repository);
    addTearDown(fresh.dispose);
    expect(fresh.loaded, isFalse);

    await pumpEventQueue();

    expect(fresh.loaded, isTrue);
    expect(fresh.teams, [bigSix, metagross]);
  });

  test('deleteTeam removes a team and undoDelete brings it back', () async {
    await pumpEventQueue();

    await viewModel.deleteTeam.execute(bigSix);
    await pumpEventQueue();
    expect(viewModel.deleteTeam.completed, isTrue);
    expect(viewModel.teams, [metagross]);

    await viewModel.undoDelete.execute();
    await pumpEventQueue();
    expect(viewModel.teams, [bigSix, metagross]);
  });

  test('a failed delete reports an error and keeps the team', () async {
    await pumpEventQueue();
    repository.failWith = Exception('disk full');

    await viewModel.deleteTeam.execute(bigSix);
    await pumpEventQueue();

    expect(viewModel.deleteTeam.error, isTrue);
    expect(viewModel.teams, [bigSix, metagross]);
  });
}
