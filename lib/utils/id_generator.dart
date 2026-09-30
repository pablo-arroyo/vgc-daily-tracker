import 'dart:math';

import 'package:clock/clock.dart';

/// Makes ids for new records. Injected so tests can predict them.
abstract interface class IdGenerator {
  String next();
}

/// Time-ordered, collision-resistant ids: milliseconds since epoch plus 8
/// random base-36 characters, e.g. `1790000000000-k3j9x0qa`.
class RandomIdGenerator implements IdGenerator {
  final _random = Random.secure();

  static const _alphabet = '0123456789abcdefghijklmnopqrstuvwxyz';

  @override
  String next() {
    final suffix = String.fromCharCodes([
      for (var i = 0; i < 8; i++)
        _alphabet.codeUnitAt(_random.nextInt(_alphabet.length)),
    ]);
    return '${clock.now().millisecondsSinceEpoch}-$suffix';
  }
}
