# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

VGC Daily Tracker is a Flutter app that rebuilds an existing "VGC daily tracker" claude.ai artifact (a Pokémon VGC companion) from scratch. Its data comes from public Pokémon API endpoints. When building a feature meant to mimic the original, read that artifact first so the behavior and layout match.

Current state: the code is still the `flutter create` scaffold (a counter app in `lib/main.dart`). The architecture below has been decided but not built yet, and none of its packages have been added.

## Every feature, bugfix or update: use the `flutter-change` skill

Run the `flutter-change` skill (`.claude/skills/flutter-change/`) for any change under `lib/` or `test/`. It loads the full architecture and performance rules from its `references/` folder. Those files are distilled from Flutter's official [architecture recommendations](https://docs.flutter.dev/app-architecture/recommendations) and [performance best practices](https://docs.flutter.dev/perf/best-practices). The skill then plans the change layer by layer, implements it with tests, and self-reviews it against a checklist.

Rules that must always hold (details and reasoning are in the skill's references):

- **Layers:** View → ViewModel → Repository → Service → PokéAPI. The dependency direction is one-way: data flows down, events flow up.
- **Widgets are dumb:** they contain only show/hide flags, animation, layout and simple routing. All other logic goes in the `ChangeNotifier` view model, and user actions go through `Command`s.
- **Repositories:** each one is an abstract class with a real implementation and a fake. Repositories return `Result<T>` and map PokéAPI *API models* to *domain models*. API models never go past the repository.
- **Models:** immutable, generated with `freezed` + `json_serializable`.
- **DI and routing:** dependencies are wired with `provider` in `lib/config/dependencies.dart` (no globals or singletons). Navigation uses `go_router`.
- **Performance:**
  - Nothing expensive in `build()`.
  - Keep rebuild scopes narrow and use `const` widgets.
  - Use `.builder` for lists and grids.
  - Use widget classes, not functions that return widgets.
  - Avoid `Opacity`, clipping and intrinsic sizing. Use `FadeInImage` for sprites.
- **Tests:** unit tests for every service, repository and view model, and widget tests for views. Use fakes, not mocks. Tests never call the network.
- **Changing a rule:** ask the user first, then update the skill's references.

## Hooks (`.claude/settings.json`)

- **PostToolUse on `Edit|Write`** (`.claude/hooks/dart-format-analyze.sh`): runs `dart format` and then `dart analyze` on the edited `.dart` file. It skips `*.g.dart` and `*.freezed.dart`. Analyzer issues are sent back to Claude as a blocking error.
- **Stop** (`.claude/hooks/flutter-verify.sh`): if any Dart files, `pubspec.yaml` or `analysis_options.yaml` changed since the last commit, it runs `flutter analyze` and then `flutter test`. A failure stops Claude from finishing. If it fails again on the retry, it only warns, so it can't loop.

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
dart run build_runner build --delete-conflicting-outputs    # regenerate freezed/json code (once added)
```

## Lints

`analysis_options.yaml` extends `flutter_lints` with extra rules:
- **Performance:** the `prefer_const_*` rules and `use_string_buffers`.
- **Immutability:** `prefer_final_fields`, `prefer_final_locals`.
- **Async:** `unawaited_futures`, `avoid_void_async`.
- **Style:** `prefer_single_quotes`.

It excludes the platform folders, `build/`, and generated `*.g.dart` / `*.freezed.dart` files. `flutter analyze` must stay clean.
