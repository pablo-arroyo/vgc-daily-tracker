import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:vgc_daily_tracker/data/repositories/routine/routine_repository.dart';
import 'package:vgc_daily_tracker/ui/core/theme/app_theme.dart';
import 'package:vgc_daily_tracker/ui/routine/view_models/routine_view_model.dart';
import 'package:vgc_daily_tracker/ui/routine/widgets/routine_screen.dart';
import 'package:vgc_daily_tracker/utils/result.dart';

import '../../../../testing/fakes/fake_routine_repository.dart';

/// Never answers, to observe the loading state.
class _NeverLoadsRoutine implements RoutineRepository {
  final _never = Completer<Result<Set<String>>>();
  @override
  Future<Result<Set<String>>> checkedOn(String day) => _never.future;
  @override
  Stream<Set<String>> watchOn(String day) =>
      StreamController<Set<String>>().stream;

  @override
  Future<Result<Map<String, Set<String>>>> allDays() =>
      Completer<Result<Map<String, Set<String>>>>().future;

  @override
  Future<Result<void>> save(String day, Set<String> checked) async =>
      const Result.ok(null);
}

void main() {
  Future<void> pumpRoutine(WidgetTester tester, RoutineRepository repository) =>
      tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: ChangeNotifierProvider(
            create: (_) => RoutineViewModel(routineRepository: repository),
            child: const RoutineScreen(),
          ),
        ),
      );

  const speedOrder =
      'Check speed order before committing to a move you assume goes first.';

  CheckboxListTile tileOf(WidgetTester tester, String text) =>
      tester.widget<CheckboxListTile>(
        find.ancestor(
          of: find.text(text),
          matching: find.byType(CheckboxListTile),
        ),
      );

  testWidgets('shows a spinner until today\'s ticks load', (tester) async {
    await pumpRoutine(tester, _NeverLoadsRoutine());
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('three cards with twelve checkboxes', (tester) async {
    await pumpRoutine(tester, FakeRoutineRepository());
    await tester.pumpAndSettle();

    expect(find.text('Before the game'), findsOneWidget);
    expect(find.text('During the game'), findsOneWidget);
    expect(find.text('After the game', skipOffstage: false), findsOneWidget);
    expect(
      find.byType(CheckboxListTile, skipOffstage: false),
      findsNWidgets(12),
    );
  });

  testWidgets('tapping an item ticks it', (tester) async {
    await pumpRoutine(tester, FakeRoutineRepository());
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text(speedOrder));
    await tester.tap(find.text(speedOrder));
    await tester.pumpAndSettle();

    expect(tileOf(tester, speedOrder).value, isTrue);
  });

  testWidgets('a failed save says so and unticks', (tester) async {
    final repository = FakeRoutineRepository()..failWith = Exception('full');
    await pumpRoutine(tester, repository);
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text(speedOrder));
    await tester.tap(find.text(speedOrder));
    await tester.pumpAndSettle();

    expect(find.text("Couldn't save your tick. Try again."), findsOneWidget);
    expect(tileOf(tester, speedOrder).value, isFalse);
  });
}
