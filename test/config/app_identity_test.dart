import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// The name people see on every platform, not the Dart package name.
const appName = 'VGC Daily Tracker';

String read(String path) => File(path).readAsStringSync();

void main() {
  group('the app is called "$appName"', () {
    test('Android launcher label', () {
      expect(
        read('android/app/src/main/AndroidManifest.xml'),
        contains('android:label="$appName"'),
      );
    });

    test('iOS display and bundle names', () {
      final plist = read('ios/Runner/Info.plist').replaceAll(RegExp(r'\s'), '');
      final name = appName.replaceAll(' ', '');
      expect(plist, contains('<key>CFBundleDisplayName</key><string>$name'));
      expect(plist, contains('<key>CFBundleName</key><string>$name'));
    });

    test('macOS product name', () {
      expect(
        read('macos/Runner/Configs/AppInfo.xcconfig'),
        contains('PRODUCT_NAME = $appName'),
      );
    });

    test('web page title and install name', () {
      expect(read('web/index.html'), contains('<title>$appName</title>'));
      expect(
        read('web/index.html'),
        contains('apple-mobile-web-app-title" content="$appName"'),
      );
      expect(read('web/manifest.json'), contains('"name": "$appName"'));
    });

    test('Windows window title and product name', () {
      expect(read('windows/runner/main.cpp'), contains('L"$appName"'));
      expect(
        read('windows/runner/Runner.rc'),
        contains('VALUE "ProductName", "$appName"'),
      );
    });

    test('Linux window title', () {
      expect(
        read('linux/runner/my_application.cc'),
        contains('gtk_window_set_title(window, "$appName")'),
      );
    });
  });

  group('the app icon', () {
    /// Width and height from a PNG's IHDR chunk.
    (int, int) pngSize(String path) {
      final bytes = File(path).readAsBytesSync();
      int at(int i) =>
          bytes[i] << 24 |
          bytes[i + 1] << 16 |
          bytes[i + 2] << 8 |
          bytes[i + 3];
      return (at(16), at(20));
    }

    test('sources are 1024 px, as flutter_launcher_icons expects', () {
      for (final source in [
        'assets/icon/app_icon.png',
        'assets/icon/app_icon_macos.png',
        'assets/icon/app_icon_foreground.png',
      ]) {
        expect(pngSize(source), (1024, 1024), reason: source);
      }
    });

    test('regenerating icons left the iOS project intact', () {
      // flutter_launcher_icons 0.14 rewrote this YES/NO setting to
      // "AppIcon"; the icon set is named by ASSETCATALOG_COMPILER_APPICON_NAME.
      final project = read('ios/Runner.xcodeproj/project.pbxproj');
      expect(
        project,
        isNot(contains('GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS = AppIcon')),
      );
      expect(
        project,
        contains('ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;'),
      );
    });
  });
}
