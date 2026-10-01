import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/domain/models/type_chart.dart';

void main() {
  // A slice of the real chart: what each attacking type hits for how much.
  const chart = TypeChart({
    'fire': {'grass': 2, 'steel': 2, 'water': 0.5, 'fire': 0.5},
    'ground': {'fire': 2, 'steel': 2, 'flying': 0, 'grass': 0.5},
    'electric': {'water': 2, 'grass': 0.5, 'dragon': 0.5, 'ground': 0},
    'normal': {'ghost': 0, 'steel': 0.5},
  });

  test('single types: ×2, ×½ and ×0', () {
    expect(chart.multiplier('fire', ['grass']), 2);
    expect(chart.multiplier('fire', ['water']), 0.5);
    expect(chart.multiplier('normal', ['ghost']), 0);
  });

  test('anything the chart does not list is ×1', () {
    expect(chart.multiplier('fire', ['normal']), 1);
    expect(chart.multiplier('psychic', ['fire']), 1);
  });

  test('dual types multiply: ×4, ×¼, and an immunity wins', () {
    expect(chart.multiplier('ground', ['fire', 'steel']), 4);
    expect(chart.multiplier('electric', ['grass', 'dragon']), 0.25);
    expect(chart.multiplier('ground', ['flying', 'steel']), 0);
  });

  test('lists the 18 battle types in the games’ order', () {
    expect(TypeChart.types, hasLength(18));
    expect(TypeChart.types.first, 'normal');
    expect(TypeChart.types.last, 'fairy');
  });
}
