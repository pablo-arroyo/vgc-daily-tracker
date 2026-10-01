import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/domain/backup/backup_format.dart';
import 'package:vgc_daily_tracker/domain/models/backup.dart';
import 'package:vgc_daily_tracker/domain/models/game_log.dart';
import 'package:vgc_daily_tracker/domain/models/mistake_category.dart';
import 'package:vgc_daily_tracker/domain/models/pokemon_ref.dart';
import 'package:vgc_daily_tracker/domain/models/pokemon_set.dart';
import 'package:vgc_daily_tracker/domain/models/team.dart';
import 'package:vgc_daily_tracker/utils/result.dart';

void main() {
  final backup = Backup(
    exportedAt: DateTime.utc(2026, 10, 1, 9),
    teams: const [
      Team(
        id: 't1',
        name: 'Big Six',
        pokemon: [
          PokemonRef(id: 983, slug: 'kingambit', displayName: 'Kingambit'),
        ],
        sets: [
          PokemonSet(species: 'Kingambit', moves: ['Protect']),
        ],
      ),
      Team(
        id: 'o1',
        name: 'Rival Grassy',
        pokemon: [
          PokemonRef(id: 812, slug: 'rillaboom', displayName: 'Rillaboom'),
        ],
        side: TeamSide.opponent,
      ),
    ],
    games: [
      GameLog(
        id: 'g1',
        playedAt: DateTime.utc(2026, 9, 30, 20),
        result: GameResult.loss,
        teamId: 't1',
        teamName: 'Big Six',
        opponentTeamId: 'o1',
        opponentTeamName: 'Rival Grassy',
        mistake: MistakeCategory.speedCalc,
        notes: 'Outsped by Tailwind.',
      ),
    ],
    routine: const {
      '2026-09-30': ['log-fast', 'speed-order'],
    },
  );

  String problem(String text) => switch (BackupFormat.decode(text)) {
    Failure(error: BackupFormatException(:final message)) => message,
    _ => fail('expected "$text" to be rejected'),
  };

  test('everything survives encode then decode', () {
    final decoded = BackupFormat.decode(BackupFormat.encode(backup));

    expect((decoded as Ok<Backup>).value, backup);
  });

  test("the file says what it is and which format it's in", () {
    final json =
        jsonDecode(BackupFormat.encode(backup)) as Map<String, Object?>;

    expect(json['app'], 'vgc_daily_tracker');
    expect(json['format_version'], 1);
    expect(json['exported_at'], '2026-10-01T09:00:00.000Z');
  });

  test('rejects text that is not JSON', () {
    expect(
      problem('Kingambit @ Life Orb'),
      "This isn't a backup: it's not JSON.",
    );
  });

  test('rejects JSON that is not a tracker backup', () {
    expect(problem('{"teams": []}'), "This isn't a VGC Daily Tracker backup.");
    expect(problem('[1, 2]'), "This isn't a VGC Daily Tracker backup.");
  });

  test('rejects a backup from a newer app version', () {
    final newer = (jsonDecode(BackupFormat.encode(backup)) as Map)
      ..['format_version'] = 2;

    expect(
      problem(jsonEncode(newer)),
      'This backup is from a newer version of the app. Update the app to '
      'restore it.',
    );
  });

  test('rejects a damaged backup', () {
    final damaged = (jsonDecode(BackupFormat.encode(backup)) as Map)
      ..['games'] = [
        {'id': 'g1'},
      ];

    expect(
      problem(jsonEncode(damaged)),
      "This backup is damaged and can't be restored.",
    );
  });
}
