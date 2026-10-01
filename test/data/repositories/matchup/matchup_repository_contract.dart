import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/data/repositories/matchup/matchup_repository.dart';
import 'package:vgc_daily_tracker/domain/models/matchup_note.dart';
import 'package:vgc_daily_tracker/utils/result.dart';

/// Behavior every [MatchupRepository] must have (real and fake).
void matchupRepositoryContract(Future<MatchupRepository> Function() create) {
  late MatchupRepository repository;

  setUp(() async => repository = await create());

  MatchupNote note(String my, String opp, String notes) => MatchupNote(
    myTeamId: my,
    opponentTeamId: opp,
    notes: notes,
    updatedAt: DateTime.utc(2026, 10, 1),
  );

  test('nothing saved: no notes', () async {
    expect(await repository.watchAll().first, isEmpty);
  });

  test('a saved note appears, one per pair of teams', () async {
    final saved = await repository.save(note('t1', 'o1', 'Plan A'));
    await repository.save(note('t1', 'o2', 'Plan B'));

    expect(saved, isA<Ok<void>>());
    expect(
      await repository.watchAll().first,
      unorderedEquals([note('t1', 'o1', 'Plan A'), note('t1', 'o2', 'Plan B')]),
    );
  });

  test('saving the same pair again replaces its note', () async {
    await repository.save(note('t1', 'o1', 'Plan A'));

    await repository.save(note('t1', 'o1', 'Plan A, revised'));

    expect(await repository.watchAll().first, [
      note('t1', 'o1', 'Plan A, revised'),
    ]);
  });

  test('watchAll emits again after each save', () async {
    final emissions = repository.watchAll().take(2).toList();

    await Future<void>.delayed(Duration.zero);
    await repository.save(note('t1', 'o1', 'Plan A'));

    expect((await emissions).last, [note('t1', 'o1', 'Plan A')]);
  });
}
