import '../../../domain/models/matchup_note.dart';
import '../../../utils/result.dart';

/// Source of truth for matchup notes: your game plan per pair of teams.
abstract class MatchupRepository {
  /// Every matchup note, emitted now and again after each change.
  Stream<List<MatchupNote>> watchAll();

  /// Inserts [note], or replaces the note for the same pair of teams.
  Future<Result<void>> save(MatchupNote note);
}
