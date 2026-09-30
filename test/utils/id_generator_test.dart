import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/utils/id_generator.dart';

void main() {
  test('RandomIdGenerator makes unique, non-empty ids', () {
    final generator = RandomIdGenerator();

    final ids = [for (var i = 0; i < 1000; i++) generator.next()];

    expect(ids.toSet(), hasLength(1000));
    expect(ids, everyElement(isNotEmpty));
  });
}
