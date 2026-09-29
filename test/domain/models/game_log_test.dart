import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/domain/models/game_log.dart';
import 'package:vgc_daily_tracker/domain/models/mistake_category.dart';

void main() {
  group('a fully logged game', () {
    final game = GameLog(
      id: 'game-1',
      playedAt: DateTime.utc(2026, 9, 29, 21, 30),
      result: GameResult.loss,
      teamId: 'team-1',
      teamName: 'Mega Metagross (Worlds)',
      team: const [
        'kingambit',
        'kleavor',
        'metagross-mega',
        'whimsicott',
        'raichu-mega-y',
        'basculegion-male',
      ],
      brought: const ['kingambit', 'kleavor', 'whimsicott', 'metagross-mega'],
      leads: const ['kleavor', 'whimsicott'],
      opponentTeam: const ['rillaboom', 'sneasler', 'incineroar'],
      opponentBrought: const ['rillaboom', 'sneasler'],
      opponentLeads: const ['rillaboom', 'sneasler'],
      mistake: MistakeCategory.wrongBring,
      notes: 'Lead Kingambit into Rillaboom next time.',
    );
    final json = {
      'id': 'game-1',
      'played_at': '2026-09-29T21:30:00.000Z',
      'result': 'loss',
      'team_id': 'team-1',
      'team_name': 'Mega Metagross (Worlds)',
      'team': [
        'kingambit',
        'kleavor',
        'metagross-mega',
        'whimsicott',
        'raichu-mega-y',
        'basculegion-male',
      ],
      'brought': ['kingambit', 'kleavor', 'whimsicott', 'metagross-mega'],
      'leads': ['kleavor', 'whimsicott'],
      'opponent_team': ['rillaboom', 'sneasler', 'incineroar'],
      'opponent_brought': ['rillaboom', 'sneasler'],
      'opponent_leads': ['rillaboom', 'sneasler'],
      'mistake': 'wrongBring',
      'notes': 'Lead Kingambit into Rillaboom next time.',
    };

    test('serializes to the pinned storage shape', () {
      expect(game.toJson(), json);
    });

    test('round-trips through JSON', () {
      expect(GameLog.fromJson(json), game);
    });
  });

  group('a minimal game (no saved team, no mistake picked)', () {
    final game = GameLog(
      id: 'game-2',
      playedAt: DateTime.utc(2026, 9, 30, 8),
      result: GameResult.win,
    );

    test('defaults to empty lists, no team, no mistake and empty notes', () {
      expect(game.toJson(), {
        'id': 'game-2',
        'played_at': '2026-09-30T08:00:00.000Z',
        'result': 'win',
        'team_id': null,
        'team_name': null,
        'team': <String>[],
        'brought': <String>[],
        'leads': <String>[],
        'opponent_team': <String>[],
        'opponent_brought': <String>[],
        'opponent_leads': <String>[],
        'mistake': null,
        'notes': '',
      });
    });

    test('round-trips through JSON', () {
      expect(GameLog.fromJson(game.toJson()), game);
    });
  });
}
