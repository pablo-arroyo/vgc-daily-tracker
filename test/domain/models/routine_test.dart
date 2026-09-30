import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/domain/models/routine.dart';

void main() {
  test("has the original's three sections: 3, 5 and 4 items", () {
    expect(routine.map((s) => s.title), [
      'Before the game',
      'During the game',
      'After the game',
    ]);
    expect(routine.map((s) => s.items.length), [3, 5, 4]);
  });

  test('item ids are unique, so saved ticks never collide', () {
    final ids = [for (final s in routine) ...s.items.map((i) => i.id)];

    expect(ids.toSet(), hasLength(12));
  });

  test("keeps the original's wording, pointing to tabs instead of 'below'", () {
    final texts = [for (final s in routine) ...s.items.map((i) => i.text)];

    expect(
      texts,
      contains(
        'Check speed order before committing to a move you assume goes '
        'first.',
      ),
    );
    expect(
      texts,
      contains(
        "If you lost your last game, re-read that game's entry in "
        'Progress before queuing again.',
      ),
    );
    expect(texts.where((t) => t.contains('below')), isEmpty);
  });
}
