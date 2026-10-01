import 'dart:async';

import 'package:vgc_daily_tracker/data/repositories/matchup/matchup_repository.dart';
import 'package:vgc_daily_tracker/domain/models/matchup_note.dart';
import 'package:vgc_daily_tracker/utils/result.dart';

/// In-memory [MatchupRepository]; passes the same contract as the real one.
class FakeMatchupRepository implements MatchupRepository {
  FakeMatchupRepository({List<MatchupNote> notes = const []})
    : _notes = {for (final note in notes) note.key: note};

  final Map<String, MatchupNote> _notes;
  final _changes = StreamController<List<MatchupNote>>.broadcast();

  /// When set, `save` fails with it and changes nothing.
  Exception? failWith;

  @override
  Stream<List<MatchupNote>> watchAll() async* {
    yield _notes.values.toList();
    yield* _changes.stream;
  }

  @override
  Future<Result<void>> save(MatchupNote note) async {
    if (failWith case final error?) return Result.failure(error);
    _notes[note.key] = note;
    _changes.add(_notes.values.toList());
    return const Result.ok(null);
  }
}
