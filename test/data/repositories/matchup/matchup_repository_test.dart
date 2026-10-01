import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/data/repositories/matchup/matchup_repository_local.dart';

import '../../../../testing/fakes/fake_matchup_repository.dart';
import '../../../../testing/storage.dart';
import 'matchup_repository_contract.dart';

void main() {
  group('MatchupRepositoryLocal', () {
    matchupRepositoryContract(
      () async => MatchupRepositoryLocal(storage: await memoryStorage()),
    );
  });

  group('FakeMatchupRepository', () {
    matchupRepositoryContract(() async => FakeMatchupRepository());
  });
}
