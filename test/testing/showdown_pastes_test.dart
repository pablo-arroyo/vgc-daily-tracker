import 'package:flutter_test/flutter_test.dart';

import '../../testing/fixtures.dart';
import '../../testing/showdown_pastes.dart';

void main() {
  test('team1Paste matches the recorded fixture', () {
    // Dart drops the newline right after the opening ''', so they're equal.
    expect(team1Paste, fixture('showdown/team1_metagross.txt'));
  });
}
