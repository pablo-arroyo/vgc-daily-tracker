import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/domain/models/mistake_category.dart';

void main() {
  test('has the original tracker\'s 9 options, labels verbatim, in order', () {
    expect(MistakeCategory.values.map((c) => c.label), [
      'No major mistake — played well',
      'Team Preview read / game plan',
      'Protect call / bluff',
      'Speed calc / turn order',
      'Overcommitted (greedy play)',
      'Wrong lead or bring choice',
      'Damage calc misjudged',
      'Teambuilding gap (nothing answered a threat)',
      'Got outplayed straight up',
    ]);
  });

  test('only "played well" is not a mistake', () {
    expect(MistakeCategory.values.where((c) => c.isPlayedWell), [
      MistakeCategory.playedWell,
    ]);
  });
}
