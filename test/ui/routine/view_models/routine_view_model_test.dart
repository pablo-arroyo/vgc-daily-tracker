import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/ui/routine/view_models/routine_view_model.dart';
import 'package:vgc_daily_tracker/utils/result.dart';

import '../../../../testing/fakes/fake_routine_repository.dart';

DateTime costaRica(DateTime utc) => utc.subtract(const Duration(hours: 6));

/// 2026-09-30 22:00 local (UTC-6), which is already Oct 1 in UTC.
final lateEvening = DateTime.utc(2026, 10, 1, 4);

void main() {
  late FakeRoutineRepository repository;

  setUp(() => repository = FakeRoutineRepository());

  Future<RoutineViewModel> routineAt(DateTime now) async {
    late RoutineViewModel viewModel;
    await withClock(Clock.fixed(now), () async {
      viewModel = RoutineViewModel(
        routineRepository: repository,
        toLocal: costaRica,
      );
      expect(viewModel.loaded, isFalse);
      await pumpEventQueue();
    });
    addTearDown(viewModel.dispose);
    return viewModel;
  }

  test("loads today's ticks, for the local day", () async {
    await repository.save('2026-09-30', {'speed-order'});

    final viewModel = await routineAt(lateEvening);

    expect(viewModel.loaded, isTrue);
    expect(viewModel.isChecked('speed-order'), isTrue);
    expect(viewModel.isChecked('log-fast'), isFalse);
  });

  test("toggle ticks and saves under today's date; again unticks", () async {
    final viewModel = await routineAt(lateEvening);

    await viewModel.toggle.execute('log-fast');
    expect(viewModel.isChecked('log-fast'), isTrue);
    expect(
      (await repository.checkedOn('2026-09-30') as Ok<Set<String>>).value,
      {'log-fast'},
    );

    await viewModel.toggle.execute('log-fast');
    expect(viewModel.isChecked('log-fast'), isFalse);
  });

  test('the next day starts with nothing ticked', () async {
    await repository.save('2026-09-30', {'speed-order'});

    final nextDay = await routineAt(DateTime.utc(2026, 10, 1, 16));

    expect(nextDay.isChecked('speed-order'), isFalse);
  });

  test('a failed save puts the tick back and reports it', () async {
    final viewModel = await routineAt(lateEvening);
    repository.failWith = Exception('disk full');

    await viewModel.toggle.execute('log-fast');

    expect(viewModel.toggle.error, isTrue);
    expect(viewModel.isChecked('log-fast'), isFalse);
  });
}
