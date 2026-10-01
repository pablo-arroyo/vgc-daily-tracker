import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/config/format_config.dart';
import 'package:vgc_daily_tracker/domain/models/pokemon_set.dart';
import 'package:vgc_daily_tracker/domain/showdown/showdown_format.dart';
import 'package:vgc_daily_tracker/utils/result.dart';

import '../../testing/fixtures.dart';

void main() {
  const format = FormatConfig.regMC;

  test('Reg M-C is labelled for display', () {
    expect(format.label, 'Reg M-C');
  });

  test("its sample teams are the artifact's 3 pastes, verbatim", () {
    expect(
      [for (final team in format.sampleTeams) team.name],
      [
        'Mega Metagross (Worlds 2026)',
        'Rillaboom / Sneasler Grassy Offense',
        'Big Six',
      ],
    );
    expect(
      [for (final team in format.sampleTeams) team.paste],
      [
        fixture('showdown/team1_metagross.txt'),
        fixture('showdown/team2_grassy.txt'),
        fixture('showdown/team3_big_six.txt'),
      ],
    );
  });

  test('every sample paste parses into 6 sets', () {
    for (final team in format.sampleTeams) {
      final sets = ShowdownFormat.parse(team.paste);
      expect((sets as Ok<List<PokemonSet>>).value, hasLength(6));
    }
  });
}
