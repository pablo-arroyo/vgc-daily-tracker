# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

VGC Daily Tracker is a Flutter app that rebuilds an existing "VGC daily tracker" claude.ai artifact (a Pokémon VGC companion) from scratch. Its data comes from public Pokémon API endpoints. When building a feature meant to mimic the original, read that artifact first so the behavior and layout match.

Current state: this is still the fresh `flutter create` scaffold. `lib/main.dart` holds the default counter app and `test/widget_test.dart` holds its smoke test. No architecture, state management or API client has been chosen yet. Once those decisions are made, record them in this file.

## Toolchain

- Flutter 3.47.5 (stable), installed with `brew install --cask flutter`. Dart SDK constraint: `^3.13.4`.
- Dart package name: `vgc_daily_tracker`. The folder name uses hyphens, but imports use underscores, for example `package:vgc_daily_tracker/...`.
- Org / bundle ID prefix: `com.parroyo`.
- Platforms scaffolded: Android, iOS, web, macOS, Windows, Linux.

## Commands

```sh
flutter pub get                      # install dependencies
flutter run -d chrome                # run (or -d macos, or a device id from `flutter devices`)
flutter analyze                      # static analysis / lints
dart format .                        # format
flutter test                         # all tests
flutter test test/widget_test.dart   # a single test file
flutter test --plain-name "Counter increments smoke test"   # a single test by name
```

## Lints

`analysis_options.yaml` includes `package:flutter_lints/flutter.yaml` and excludes `build/` and the platform folders (`android/`, `ios/`, `web/`, `windows/`, `macos/`, `linux/`). `flutter analyze` should stay clean.
