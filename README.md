# VGC Daily Tracker

[![CI](https://github.com/pablo-arroyo/vgc-daily-tracker/actions/workflows/ci.yml/badge.svg)](https://github.com/pablo-arroyo/vgc-daily-tracker/actions/workflows/ci.yml)

<img src="assets/icon/app_icon.png" alt="App icon: a calendar page with a check mark" width="96" align="right">

A Pokémon VGC practice companion: plan each battle, log every game, review
your mistakes and track your progress. It rebuilds the *VGC Daily Practice
Tracker* claude.ai artifact in Flutter, backed by
[PokéAPI](https://pokeapi.co), and adds team analysis from the *VGC Reg M-C
Teams* artifact. The step-by-step build plan, with what each step delivered,
is in [`docs/ROADMAP.md`](docs/ROADMAP.md).

## What it does

| Tab | What you get |
|---|---|
| **Routine** | Before / during / after checklists, ticked per local day. |
| **Teams** | *My teams* and *Opponents*: build a team by picking Pokémon, or import a Showdown paste (checked against PokéAPI). A team's detail screen shows each Pokémon's battle form (Megas from their stone), types, item, ability, moves, level 50 stats and the team's Speed order, plus team notes and matchup notes against each team on the other side. An empty tab offers the Reg M-C sample teams. |
| **Log Game** | Result, your team with its bring 4 / lead 2, their team (pick a saved opponent team to fill it), what decided the game, and notes. A **Game plan** card shows your notes and matchup plan before the battle; after saving, a game's notes can be added to that plan. |
| **Progress** | Totals, win rates, streak, weekly focus, win rate by team, your record against each opponent team, opponent leads, mistake breakdown and recent games (save a game's opponent as a team from here). |

**Backup & restore** (the icon in the header) copies everything to the
clipboard as JSON and merges a pasted backup back in.

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
flutter run -d macos         # or -d chrome, or a device id from `flutter devices`
```

## Commands

| What | Command |
|---|---|
| Analyze (lints must stay clean) | `flutter analyze` |
| Format | `dart format .` |
| Regenerate freezed / JSON code | `dart run build_runner build --delete-conflicting-outputs` |
| Frame times in profile mode | `flutter drive --profile -d macos --driver=test_driver/perf_driver.dart --target=integration_test/perf/progress_perf.dart` (writes `build/<name>.timeline_summary.json`) |
| Redraw the app icon | `flutter test tool/app_icon/render_app_icon_test.dart`, then `dart run flutter_launcher_icons` |

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

CI (`.github/workflows/ci.yml`) runs on every push to `main` and every pull
request. On Linux it runs the formatting, analyzer, generated-code and
unit/widget checks; on macOS it runs the goldens and the integration
journeys.

Contract tests are skipped by default (see `dart_test.yaml`), so a normal
`flutter test` run never touches the network. Shared test support lives in
`testing/`:
- `app.dart`: `pumpApp(tester)` builds the whole app with fakes; each call
  is a fresh app launch, and it can be seeded (teams, games, routine,
  matchup notes, an offline PokéAPI).
- `storage.dart`: `memoryStorage()`, a fresh in-memory database.
- `fakes/`: in-memory fakes of repositories and services, each passing the
  same contract tests as the real implementation.
- `fixtures/`: recorded PokéAPI JSON and the artifact's Showdown pastes.
- `clipboard.dart`: a fake clipboard, so tests never touch the real one.

## Architecture

MVVM with a repository layer, following Flutter's
[architecture recommendations](https://docs.flutter.dev/app-architecture/recommendations):

```
View (widget) ──commands──▶ ViewModel ──▶ Repository ──▶ Service ──▶ PokéAPI / local DB
     ◀──ChangeNotifier──        ◀── domain models ──   ◀── API models ──
```

```
lib/
  config/        DI wiring (provider) and the format config (Reg M-C, sample teams)
  data/
    services/    PokeApiService (+ API models), LocalStorageService (sembast)
    repositories/ one folder each: abstract class + local/remote implementation
  domain/
    models/      immutable freezed models (Team, GameLog, PokemonSet, Backup, …)
    showdown/    Showdown paste parse/export
    stats/       level 50 stat calculator
    backup/      backup JSON format
    use_cases/   logic shared by view models (ImportTeamUseCase)
  routing/       go_router routes
  ui/<feature>/  view_models/ + widgets/; shared widgets and theme in ui/core/
  utils/         Result, Command, ids, dates
```

Key decisions (the full list, with reasons, is in the roadmap and in
`.claude/skills/flutter-change/references/architecture.md`):
- **Local-first:** all data lives on the device in sembast. There's no
  account or server; use Backup & restore to move or keep data.
- **Repositories return `Result<T>`** and are abstract, with a fake for
  tests. API models never leave their repository.
- **View models expose `Command`s**, and widgets hold no business logic.
- **Time and ids are injected** (`package:clock`, an id generator), so
  tests pin both; dates are stored in UTC and shown by local day.
- **Offline:** the PokéAPI name index is cached for 24 hours and kept as
  an offline fallback, and every PokéAPI-backed screen says when it can't
  reach the network.

## How the project is worked on

- One roadmap step at a time, each starting from a failing acceptance test
  (tagged `wip` until it passes), then test-first through the layers.
- Every change runs through the `flutter-change` workflow in `.claude/`,
  with hooks that format and analyze each edit and run the tests before
  finishing. See [`CLAUDE.md`](CLAUDE.md).
- Rules are spot-checked by breaking them on purpose and confirming a
  test fails.
