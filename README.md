# VGC Daily Tracker

A Pokémon VGC practice companion. You log every game, review your mistakes,
and track your progress. It rebuilds the *VGC Daily Practice Tracker*
artifact in Flutter, backed by [PokéAPI](https://pokeapi.co). The build plan
is in [`docs/ROADMAP.md`](docs/ROADMAP.md).

## Setup

- Flutter 3.47 (stable): `brew install --cask flutter`
- For macOS desktop and integration tests:
  1. Install full Xcode.
  2. Run:
     ```sh
     sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
     sudo xcodebuild -runFirstLaunch
     brew install cocoapods
     ```

```sh
flutter pub get
flutter run -d chrome        # or -d macos
```

## Tests

The project is built test-first. Test levels and where they live:

| Level | Location | Command |
|---|---|---|
| Unit + widget | `test/` | `flutter test` |
| Single file / single test | | `flutter test test/main_test.dart` / `flutter test --plain-name "<test name>"` |
| Golden (screenshots) | `test/goldens/` | `flutter test --tags golden` (update with `--update-goldens`) |
| Integration (real app on a device) | `integration_test/` (journeys in `journeys/`, one entry point `app_test.dart`) | `flutter test integration_test -d macos` |
| Contract (live PokéAPI) | `test/contract/` | `flutter test --tags network --run-skipped` |
| Coverage | | `flutter test --coverage` → `coverage/lcov.info` |

Contract tests are skipped by default (see `dart_test.yaml`), so a normal
`flutter test` run never touches the network. Shared test support lives in
`testing/`:
- `app.dart`: `pumpApp(tester)` builds the whole app, with fakes.
- `storage.dart`: `memoryStorage()`, a fresh in-memory database.
- `fakes/`: in-memory fakes of repositories and services.
- `fixtures/`: recorded PokéAPI JSON.
