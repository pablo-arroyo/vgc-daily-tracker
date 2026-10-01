import 'package:vgc_daily_tracker/domain/models/game_log.dart';
import 'package:vgc_daily_tracker/domain/models/mistake_category.dart';

/// [count] varied, deterministic games ending at [now], about 8 a day:
/// mixed results, 3 teams, leads, opponent leads and mistakes. For load
/// tests such as Progress with 1,000 games.
List<GameLog> generateGames(int count, {required DateTime now}) {
  const teams = [
    ('t1', 'Big Six'),
    ('t2', 'Mega Metagross (Worlds 2026)'),
    ('t3', 'Rillaboom / Sneasler Grassy Offense'),
  ];
  const leads = [
    ['kingambit', 'whimsicott'],
    ['charizard-mega-y', 'garchomp'],
    ['incineroar', 'rillaboom'],
  ];
  const opponents = ['rillaboom', 'incineroar', 'sneasler', 'kingambit'];
  const mistakes = MistakeCategory.values;
  return [
    for (var i = 0; i < count; i++)
      GameLog(
        id: 'gen-$i',
        playedAt: now.subtract(Duration(hours: i * 3)),
        result: i % 3 == 0 ? GameResult.loss : GameResult.win,
        teamId: teams[i % 3].$1,
        teamName: teams[i % 3].$2,
        leads: leads[i % 3],
        opponentLeads: [opponents[i % 4], opponents[(i + 1) % 4]],
        mistake: mistakes[i % mistakes.length],
        notes: i.isEven ? 'Game $i: lost the speed tie on turn 2.' : '',
      ),
  ];
}
