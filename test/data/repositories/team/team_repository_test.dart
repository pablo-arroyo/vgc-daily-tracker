import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/data/repositories/team/team_repository_local.dart';

import '../../../../testing/fakes/fake_team_repository.dart';
import '../../../../testing/storage.dart';
import 'team_repository_contract.dart';

void main() {
  group('TeamRepositoryLocal', () {
    teamRepositoryContract(
      () async => TeamRepositoryLocal(storage: await memoryStorage()),
    );
  });

  group('FakeTeamRepository', () {
    teamRepositoryContract(() async => FakeTeamRepository());
  });
}
