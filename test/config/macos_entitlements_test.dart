import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  // The macOS app is sandboxed: without this key it can't open any
  // outgoing connection, so PokéAPI and sprites fail on every build type.
  for (final file in ['DebugProfile', 'Release']) {
    test('$file entitlements allow outgoing network connections', () {
      final plist = File(
        'macos/Runner/$file.entitlements',
      ).readAsStringSync().replaceAll(RegExp(r'\s'), '');

      expect(
        plist,
        contains('<key>com.apple.security.network.client</key><true/>'),
      );
    });
  }
}
