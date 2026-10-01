import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/data/repositories/routine/routine_repository.dart';
import 'package:vgc_daily_tracker/utils/result.dart';

/// Behavior every [RoutineRepository] must have (real and fake).
void routineRepositoryContract(Future<RoutineRepository> Function() create) {
  late RoutineRepository repository;

  setUp(() async => repository = await create());

  Future<Set<String>> checked(String day) async =>
      (await repository.checkedOn(day) as Ok<Set<String>>).value;

  test('a day with nothing saved has no ticks', () async {
    expect(await checked('2026-09-30'), isEmpty);
  });

  test('ticks saved for a day come back for that day only', () async {
    final saved = await repository.save('2026-09-30', {
      'speed-order',
      'log-fast',
    });

    expect(saved, isA<Ok<void>>());
    expect(await checked('2026-09-30'), {'speed-order', 'log-fast'});
    expect(await checked('2026-10-01'), isEmpty, reason: 'a new day');
  });

  test('saving again replaces the ticks (unticking)', () async {
    await repository.save('2026-09-30', {'speed-order', 'log-fast'});

    await repository.save('2026-09-30', {'log-fast'});

    expect(await checked('2026-09-30'), {'log-fast'});
  });

  test('allDays lists every saved day with its ticks', () async {
    await repository.save('2026-09-29', {'log-fast'});
    await repository.save('2026-09-30', {'speed-order', 'log-fast'});

    final days = await repository.allDays();

    expect((days as Ok<Map<String, Set<String>>>).value, {
      '2026-09-29': {'log-fast'},
      '2026-09-30': {'speed-order', 'log-fast'},
    });
  });

  test('watchOn emits the day now, then after each save to it', () async {
    await repository.save('2026-09-30', {'log-fast'});
    final emissions = repository.watchOn('2026-09-30').take(2).toList();

    await Future<void>.delayed(Duration.zero);
    await repository.save('2026-09-29', {'speed-order'}); // another day
    await repository.save('2026-09-30', {'log-fast', 'speed-order'});

    expect(await emissions, [
      {'log-fast'},
      {'log-fast', 'speed-order'},
    ]);
  });
}
