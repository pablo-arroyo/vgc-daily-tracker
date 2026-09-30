import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/data/repositories/routine/routine_repository_local.dart';

import '../../../../testing/fakes/fake_routine_repository.dart';
import '../../../../testing/storage.dart';
import 'routine_repository_contract.dart';

void main() {
  group('RoutineRepositoryLocal', () {
    routineRepositoryContract(
      () async => RoutineRepositoryLocal(storage: await memoryStorage()),
    );
  });

  group('FakeRoutineRepository', () {
    routineRepositoryContract(() async => FakeRoutineRepository());
  });
}
