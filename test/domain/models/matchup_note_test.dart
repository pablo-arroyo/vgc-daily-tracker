import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/domain/models/matchup_note.dart';

void main() {
  final note = MatchupNote(
    myTeamId: 't1',
    opponentTeamId: 'o1',
    notes: 'Lead Whimsicott + Kingambit.',
    updatedAt: DateTime.utc(2026, 10, 1, 9),
  );
  const json = {
    'my_team_id': 't1',
    'opponent_team_id': 'o1',
    'notes': 'Lead Whimsicott + Kingambit.',
    'updated_at': '2026-10-01T09:00:00.000Z',
  };

  test('serializes to the pinned storage shape', () {
    expect(note.toJson(), json);
  });

  test('round-trips through JSON', () {
    expect(MatchupNote.fromJson(json), note);
  });

  test('is identified by its pair of teams', () {
    expect(note.key, 't1|o1');
  });
}
