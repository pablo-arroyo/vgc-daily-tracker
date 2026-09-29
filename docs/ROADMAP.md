# VGC Daily Tracker: build roadmap

This plan rebuilds the **VGC Daily Practice Tracker** artifact as a Flutter app
backed by PokéAPI. It also turns the **Reg M-C Teams: EVs & Analysis**
artifact into a real feature: team import plus stat and speed analysis.

How to use this plan:
- Each numbered step is one `flutter-change` run and one commit. Do them in
  order. A step is done only when its **Done when** list holds and
  `flutter analyze` and `flutter test` are clean.
- Tick steps off here as they land.
- Architecture rules live in
  `.claude/skills/flutter-change/references/architecture.md` and are all
  confirmed, so this file doesn't repeat them.

---

## Project decisions (confirmed by the user, 2026-09-29)

| # | Decision | Chosen | Why | Used from |
|---|---|---|---|---|
| D1 | Where data lives | **Local-first with `sembast`** (`sembast` on mobile/desktop, `sembast_web` on web, in-memory in tests) | Pure Dart; works on every platform including web (IndexedDB); tests need no native sqlite; its document model matches the artifact's data shape. A backend can be added later as another repository implementation (Phase 9) without touching the UI. | Step 2.1 |
| D2 | Integration test platform | **macOS desktop**: `flutter test integration_test -d macos` | Web needs `chromedriver` + `flutter drive`, which is clunkier. **User action needed:** install full Xcode from the App Store, then run `sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer` and `sudo xcodebuild -runFirstLaunch`, then `brew install cocoapods`. Until then, integration tests can run on Chrome with `flutter drive` as a fallback. | Step 0.4 |
| D3 | Routine checklist ticks | **Saved per day, reset each new local day** | The artifact never saved them. Keeping them for the day matches how the routine is used. | Step 6.1 |

## What was verified before planning (2026-09-29)

- PokéAPI has **every** Pokémon and item from both artifacts, including the
  Legends Z-A Megas: `raichu-mega-y`, `floette-mega`, `garchomp-mega-z`,
  `absol-mega-z`, `lucario-mega-z`, `baxcalibur-mega`, `golisopod-mega`,
  `metagrossite`, `raichunite-y`, `floettite`, `fairy-feather` and
  `grassy-seed`. The `/pokemon` endpoint lists 1,351 entries, including
  forms.
- PokéAPI uses slugs that differ from display and Showdown names, e.g.
  `basculegion-male`, and base Floette vs `floette-eternal`. Name mapping is
  real work (step 1.2).
- The artifact's Level 50 stat numbers match PokéAPI base stats run through
  the standard formula:

  | Stat | Value |
  |---|---|
  | Mega Metagross Spe | 178 |
  | Kleavor Spe | 137 |
  | Whimsicott Spe | 184 |
  | Mega Raichu Y Spe | 200 |
  | Basculegion Spe | 130 |
  | Kingambit HP | 207 |

  These become the expected values in the stat-calculator tests (step 7.2).

---

## Testing strategy (applies to every step)

**Development is test-driven (TDD).** In every step below:
- The tests listed are written **before** the code they describe.
- The first test is the step's acceptance test, taken from its **Done when**
  (an integration or widget test).
- Each layer is then built with red → green → refactor, from the service up
  to the view.

The full loop and its few exceptions (generated code, config, pure styling,
goldens) are in the `flutter-change` skill. Where a step says "**Tests:**",
read it as "**Tests (write first):**".

| Level | Location | Runs with | What it covers | Test doubles |
|---|---|---|---|---|
| **Unit** | `test/` (mirrors `lib/`) | `flutter test` (Stop hook) | utils, services, repositories, view models, parsers and calculators | `testing/fakes/*`, `package:http/testing.dart` `MockClient` fed with JSON fixtures |
| **Widget (UI)** | `test/ui/...` | `flutter test` (Stop hook) | every screen and shared widget: loading, empty, error and data states; user interaction; navigation | Fake repositories injected through `provider` |
| **Golden (UI visuals)** | `test/goldens/` | `flutter test --tags golden` | key screens in light and dark theme | Fakes. Kept few, and only for stable screens. |
| **Integration** | `integration_test/` | `flutter test integration_test -d macos` (D2) | full user journeys through the real app with real storage (in-memory or temp) | A fake `PokeApiService` only, so tests are deterministic and offline |
| **Contract** | `test/contract/` tagged `network` | `flutter test --tags network --run-skipped` | the real PokéAPI still returns the shape our API models parse | none (live network) |

Rules:
- **Time is injected.** Use `package:clock` everywhere dates matter (streak,
  "last 7 days", 14-day focus, daily routine reset). Tests pin the clock with
  `withClock`.
- **IDs are injected** through a small `IdGenerator`, so tests can predict
  them.
- **No real network** in unit, widget or integration tests. The `network` tag
  is skipped by default in `dart_test.yaml`, so the Stop hook never calls
  PokéAPI.
- **Fixtures:** trimmed real PokéAPI JSON lives in `testing/fixtures/pokeapi/`.
  The contract tests check the same Pokémon, so the fixtures and the real API
  can't drift apart silently.

---

## Phase 0: Foundation

### ✅ 0.1 Dependencies and project skeleton
- Add runtime packages: `provider`, `go_router`, `freezed_annotation`,
  `json_annotation`, `http`, `clock`, and the storage package from D1.
- Add dev packages: `build_runner`, `freezed`, `json_serializable`, and the
  `integration_test` SDK.
- Create the directory layout from `architecture.md`, plus `testing/` and
  `dart_test.yaml` (with the `network` and `golden` tags configured).
- Delete the counter app and its test.
- **Done when:** the app builds and shows an empty `MaterialApp`, and one
  placeholder test passes.

### ✅ 0.2 `Result<T>` and `Command`
- Add `lib/utils/result.dart` (`Ok` / `Failure`) and `lib/utils/command.dart`
  (`Command0<T>`, `Command1<T, A>`, which track running, error and completed, and
  block double execution).
- **Tests (unit):** state transitions, listener notifications, re-entrancy
  blocked, errors captured, and `clearResult`.
- **Done when:** both types are fully covered.

### ✅ 0.3 App shell: theme and routing (DI moved to 1.2)
- **Theme:** a Material 3 light and dark theme using the artifact's
  semantic colors (accent, win, loss, lead, opponent, opponent-lead) as a
  `ThemeExtension`.
- **Routing:** `go_router` with a `StatefulShellRoute` holding 4 tabs,
  Routine / Teams / Log / Progress, each on its own path. Content is capped
  at 640 px wide, like the original.
- **DI:** moved to step 1.2. With no dependencies yet, no test could require
  it, so writing it here would break the TDD rule.
- **Tests:**
  - Widget: switching tabs shows the right screen and keeps each tab's
    state.
  - Widget: deep links such as `/progress` open the correct tab.
  - Unit: the router config.
- **Done when:** the app runs on Chrome with 4 placeholder tabs in both
  themes.

### ✅ 0.4 Test infrastructure
- Add `testing/fakes/` (empty at first; each later step adds its fakes here)
  and `testing/fixtures/`.
- Add a pump helper, `pumpApp(tester, {overrides})`, that builds the app with
  fake dependencies.
- Add `integration_test/app_test.dart`: launch the app → switch tabs → assert
  each screen.
- **Done when:** the integration smoke test passes on the D2 platform, and the
  README documents all the test commands.

## Phase 1: PokéAPI data layer

### ✅ 1.1 `PokeApiService`
- `GET /pokemon?limit=…` returns a name index (name + URL). `GET /pokemon/{slug}`
  returns the detail. API models: `PokemonListApiModel` and
  `PokemonDetailApiModel` (id, name, types, stats, sprites, abilities, species
  link).
- It maps HTTP errors, timeouts and bad JSON to `Result.error` with typed
  exceptions (`NotFound`, `NetworkUnavailable`, `BadResponse`).
- **Tests (unit):** fixtures for kingambit, raichu-mega-y and
  basculegion-male. Cover 404, a 500 error, a timeout and malformed JSON, all
  through `MockClient`.
- **Contract test (`network`):** the same slugs parse from the live API.

### ✅ 1.2 `PokemonRepository` and name mapping
- Domain models:
  - `PokemonRef`: id, slug, display name.
  - `Pokemon`: id, slug, display name, types, `BaseStats`, sprite URL.
    (`isMega` and the base-form slug moved to Phase 7, which is the first
    code that uses them. Floette, whose Mega comes from `floette-eternal`,
    shows they can't be derived naively.)
- `PokemonRepositoryRemote`:
  - The name index is fetched once and cached **in memory** for 24 hours
    (PokéAPI sends `max-age=86400`). Concurrent callers share one request.
    When the network fails after expiry, the expired index is served.
    Persisting the cache across app restarts moved to **2.1**, which adds
    the storage it needs.
  - Details are cached per slug.
  - `search(query)`: prefix matches before substring matches, and a blank
    query returns nothing.
  - `resolve(name)` has no hand-kept table. It normalizes punctuation,
    accents and ♀/♂, expands Showdown `-F`/`-M`, and picks a species'
    default form as the lowest-id `name-*` entry (`Basculegion` →
    `basculegion-male`). It never guesses from partial names. Mapping an
    item to a Mega ("Metagross" + Metagrossite → `metagross-mega`) moved to
    **7.1**, which introduces items.
- **Tests (unit):** search ranking, the name-mapping tables (checked against
  the recorded full index), a second lookup served from cache, the 24-hour
  expiry, the offline fallback, and shared in-flight requests.
- **Fake:** `FakePokemonRepository` in `testing/fakes/`. It holds in-memory
  Dart data rather than fixture files, so it also works on a device, and it
  uses the real name rules.
- **DI (moved here from 0.3):** `lib/config/dependencies.dart` contains only
  `providersRemote()`. The fake setup is `providersFake()` in
  `testing/app.dart`, so fakes never ship in the app. `VgcApp(providers:)`
  wraps everything in `MultiProvider`.

### 1.3 Shared Pokémon UI widgets (`ui/core/`)
- `PokemonAutocompleteField`: validates against the index, so typos can't be
  stored.
- `PokemonAvatar`: sprite via `FadeInImage` with a placeholder and a fallback
  on error.
- `TypeBadge` and `PokemonChip`, which are selectable, with states for
  brought, lead, opponent-brought and opponent-lead.
- **Tests (widget):** autocomplete suggests and selects, invalid input is
  rejected, avatar placeholder and error states, and the chip's selected
  states.

## Phase 2: Local persistence and core models (D1: sembast)

### 2.1 Storage service and domain models
- Persist the Pokémon name index cache from 1.2, with its 24-hour expiry and
  offline fallback, so autocomplete works offline right after an app
  restart. **Tests:** a new repository instance reuses the stored index
  without a network call.
- `LocalStorageService` wraps sembast: `databaseFactoryMemory` in tests,
  `databaseFactoryIo` on mobile and desktop, and `databaseFactoryWeb` on web. The schema is versioned from day one.
- Domain models:
  - `Team`: id, name, 6 `PokemonRef`s, and optional full sets (Phase 7).
  - `GameLog`: every artifact field, but storing team *id* + slugs.
  - `MistakeCategory` enum: the 9 artifact options, with `isPlayedWell`.
  - `GameResult`: win or loss.
- **Tests (unit):** JSON round trips for every model, and a schema-version
  migration from v1.

### 2.2 `TeamRepository` and `GameLogRepository`
- Teams: `watchAll`, `add`, `update` (new: the artifact couldn't edit
  teams), `delete`.
- Games: `watchAll` (sorted newest first), `add`, `delete`.
- **Tests (unit):** CRUD against in-memory storage, ordering, deleting a team
  keeps its games (they still show the team name), and concurrent adds don't
  overwrite each other (the artifact re-read before every write for this
  reason).
- **Fakes:** `FakeTeamRepository` and `FakeGameLogRepository`.

## Phase 3: Teams tab

### 3.1 Team list
- `TeamsViewModel` with a delete command (asks for confirmation and offers
  undo) and an empty state.
- The list shows the team name, 6 avatars and type badges.
- **Tests:**
  - Unit: the view model.
  - Widget: empty, list, delete with confirm and undo.

### 3.2 Add and edit a team
- `TeamEditorViewModel`:
  - The name is required.
  - All 6 slots must be valid Pokémon.
  - **Species clause:** no duplicate species. This is new; it's a VGC rule.
  - Supports both edit and create.
- **Tests:**
  - Unit: every validation rule.
  - Widget: the form flow.
  - **Integration:** create a team → it appears in the list → edit it →
    delete it.

## Phase 4: Log Game tab

### 4.1 `LogGameViewModel` (the rules engine)
- Result is required.
- If a team is chosen:
  - **exactly 4** brought from its 6
  - **exactly 2** leads, chosen from the brought 4
  - un-bringing a Pokémon also removes it as a lead
- Opponent:
  - up to 6 Pokémon, validated through autocomplete
  - **at most 4** brought
  - **at most 2** leads, chosen from their brought
  - removing a Pokémon from their team drops it from brought and leads
- Mistake category and notes are optional.
- The save command resets the form, using the timestamp and *local* date
  from `clock`.
- **Tests (unit):** every rule above with its limit cases (4th vs 5th pick,
  lead removed with its brought Pokémon), save with and without a team, and a
  save failure that keeps the form.

### 4.2 Log Game UI
- Win/Loss toggle, team dropdown, chip pickers with "n / 4" hints, the
  opponent section, mistake dropdown and notes. Snackbars replace the
  artifact's toasts.
- **Tests (widget):** each picker's limits are enforced visibly, validation
  messages, and the form resets after saving.
- **Integration:** create a team → log a game with brought and leads → the
  game appears in Progress' recent games.

## Phase 5: Progress tab

### 5.1 `ProgressViewModel`: statistics
Everything is recomputed from the repository stream, with a pinned clock in
tests:
- **Totals:** number of games and overall win %.
- **Last-7-days win %:** uses **local** dates (fixes the artifact's UTC bug).
- **Day streak:** counts back from today, or from yesterday if nothing has
  been logged today yet.
- **Weekly focus:** the most common mistake in the last 14 days, not counting
  "played well". The artifact's wording claimed "losses" while it counted
  every game; the text is now accurate.
- **Mistake breakdown:** all time.
- **Win rate by team:** grouped by **team id** (fixes grouping by name).
- **Opponent leads:** the 8 most frequent, each with your win % against it.
- **Recent games** list.
- **Tests (unit):** each stat with hand-built fixtures, including edge cases:
  - an empty history
  - games exactly at the 7- and 14-day limits
  - the streak around midnight and a timezone offset
  - ties in the most common mistake
  - a deleted team that still has games

### 5.2 Progress UI
- Stat grid, focus callout, bar chart (plain widgets, no chart package),
  win-rate lists, and a lazy recent-games list with delete. The artifact only
  showed 15 games; this adds "show all".
- **Tests:**
  - Widget: each card's empty and data states, and delete with undo.
  - **Golden:** the full Progress screen in light and dark themes with a
    fixed dataset.
  - **Integration:** log several games → verify totals, streak and team win
    rate on screen.

## Phase 6: Routine tab

### 6.1 Checklists (D3: saved per day)
- The artifact's 3 cards (before / during / after), 12 items total, as static
  content.
- `RoutineViewModel` saves the ticks per local day and resets them each new
  day.
- **Tests:**
  - Unit: ticks saved, and reset on a new day (with the pinned clock).
  - Widget: ticking items, and the ticks surviving a rebuild.

## Phase 7: Team analysis (from the Reg M-C artifact)

### 7.1 Showdown import and export
- Resolve Megas from their held item (moved from 1.2): "Metagross" +
  Metagrossite → `metagross-mega`, "Charizard" + Charizardite Y →
  `charizard-mega-y`.
- A pure-Dart parser that turns a Showdown paste into a `PokemonSet`:
  species, item, ability (including the artifact's "A → B" mega notation),
  level, EVs, IVs, nature and 4 moves. It also handles nicknames, gender and
  blank lines, and reports malformed input with line numbers.
- A serializer for the reverse direction.
- **Tests (unit):** all 3 artifact teams as fixtures parse correctly, a
  parse → export → parse round trip gives the same result, and errors are
  reported for bad EV totals (over 510, or over 252 on one stat), unknown
  natures and more than 4 moves.

### 7.2 Stat calculator
- Level 50 (configurable level) stats from base stats + EVs + IVs + nature.
  Mega forms use the Mega's base stats.
- **Tests (unit):** the verified expected values (Mega Metagross 178,
  Kleavor 137, Whimsicott 184, Mega Raichu Y 200 and Basculegion 130 Spe;
  Kingambit 207 HP), plus nature ±10 %, 0 and 252 EVs, and flooring.

### 7.3 Full team sets in the app
- `Team` gets optional `PokemonSet`s. Teams without them keep working.
- Teams tab: an "Import from Showdown" action, and a **team detail** screen
  showing each Pokémon's avatar, types, item, ability, moves, computed stats
  and a **speed-tier list** sorted fastest to slowest, with Mega speeds.
- Species, items and abilities are validated through PokéAPI (the service
  gains `/item/{slug}`).
- **Tests:**
  - Unit: the import view model and speed-tier ordering.
  - Widget: the detail screen.
  - **Integration:** paste Team 1 → open the detail screen → Mega Metagross
    shows 178 Spe.

### 7.4 Sample teams
- An "Add sample teams" action on an empty Teams tab that imports the
  artifact's 3 teams.
- The format label "Reg M-C" becomes config, not hard-coded text.
- **Tests:** widget + integration: the action adds exactly 3 valid teams.

## Phase 8: Polish and release readiness

- **8.1 Resilience:** offline, error and retry states on every PokéAPI-backed
  widget. The app stays usable offline with its cached index. Tested with the
  fake service in error modes.
- **8.2 Accessibility:** semantics labels on chips, avatars and stats; text
  scaling to 200 %; contrast in both themes. Covered by widget tests with
  `meetsGuideline` checks.
- **8.3 Performance pass:** follow `performance.md`. Profile the Progress
  screen with 1,000 generated games in profile mode and record frame times.
- **8.4 Backup:** export and import all data as JSON, since data is local
  only. Unit test the round trip.
- **8.5 CI (optional):** a GitHub Actions workflow running `flutter analyze`,
  `flutter test` and the integration tests on macOS.
- **8.6 App identity and README:** app name and icon, and a README with
  setup, commands and architecture overview.

## Phase 9 (optional, later): Cloud sync

- New `TeamRepositoryRemote` / `GameLogRepositoryRemote` implementations for
  the chosen backend, plus sign-in, wired through DI. The UI and view models
  don't change, which is the payoff of the abstract repositories.

---

## Traceability: original artifact → step

| Original feature | Step |
|---|---|
| Routine checklists (3 cards, 12 items) | 6.1 |
| Save, list and delete 6-Pokémon teams | 3.1, 3.2 |
| Log game: result, team, bring 4 / lead 2 | 4.1, 4.2 |
| Opponent's team, bring ≤4, leads ≤2 | 4.1, 4.2 |
| Mistake category (9) + notes | 2.1, 4.2 |
| Totals, win %, last 7 days, streak | 5.1, 5.2 |
| Weekly focus (most common mistake, 14 days) | 5.1, 5.2 |
| Win rate by team | 5.1, 5.2 |
| Opponent lead frequency + win % | 5.1, 5.2 |
| Mistake breakdown bars | 5.1, 5.2 |
| Recent games + delete | 5.2 |
| Per-user persistence | 2.1, 2.2 (Phase 9 for sync) |
| Reg M-C teams in Showdown format | 7.1, 7.4 |
| Level 50 EV / speed analysis | 7.2, 7.3 |

## Differences from the original

These are known artifact bugs or limits, fixed on purpose:

| In the original | In the rebuild |
|---|---|
| Free-text Pokémon names (typos split the stats) | Autocomplete validated against PokéAPI (1.3) |
| UTC dates for the streak and last 7 days | Local dates via `clock` (5.1) |
| Win rate grouped by team name | Grouped by team id (5.1) |
| Focus text says "losses" but counts every game | Text matches the calculation (5.1) |
| Teams can't be edited | Editing added (2.2, 3.2) |
| Routine ticks reset whenever the page reloads | Saved per day (6.1, D3) |
| Only 15 recent games visible | "Show all" with a lazy list (5.2) |
