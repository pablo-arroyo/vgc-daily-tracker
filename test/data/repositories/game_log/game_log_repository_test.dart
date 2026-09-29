import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/data/repositories/game_log/game_log_repository_local.dart';

import '../../../../testing/fakes/fake_game_log_repository.dart';
import '../../../../testing/storage.dart';
import 'game_log_repository_contract.dart';

void main() {
  group('GameLogRepositoryLocal', () {
    gameLogRepositoryContract(
      () async => GameLogRepositoryLocal(storage: await memoryStorage()),
    );
  });

  group('FakeGameLogRepository', () {
    gameLogRepositoryContract(() async => FakeGameLogRepository());
  });
}
