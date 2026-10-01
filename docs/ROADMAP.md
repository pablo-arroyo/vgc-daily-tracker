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

### ✅ 1.3 Shared Pokémon UI widgets (`ui/core/`)
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

### ✅ 2.1 Storage service and domain models
- The Pokémon name index from 1.2 is persisted, with its 24-hour expiry and
  offline fallback, so autocomplete works offline right after an app
  restart. **Tests:** a new repository instance reuses the stored index
  without a network call, and an expired stored index still works offline.
- `LocalStorageService` wraps sembast with `get`/`put` (2.2 adds what it
  needs). `database_location.dart` picks `databaseFactoryIo` plus an
  app-support file via `path_provider` on mobile/desktop, and
  `databaseFactoryWeb` on web. Tests use `databaseFactoryMemory`. The
  database is opened once in `main()`, and an integration journey checks
  the real macOS file.
- The schema is versioned from day one (`appSchemaVersion = 1`). The
  *migration* test arrives with the first v2 change, since v1 has nothing
  to migrate from.
- Domain models, each with pinned-JSON and round-trip tests:
  - `Team`: id, name, `PokemonRef`s. (Optional full sets move to Phase 7,
    their first user.)
  - `GameLog`: every artifact field. It stores the team *id* plus a
    `teamName` snapshot, Pokémon as slugs, and one UTC `playedAt`, with the
    local day derived at display time. **4.1 must create it from
    `clock.now().toUtc()`.**
  - `MistakeCategory`: the 9 artifact labels verbatim, with `isPlayedWell`.
  - `GameResult`: win or loss.

### ✅ 2.2 `TeamRepository` and `GameLogRepository`
- Teams: `watchAll` (alphabetical, ignoring case), `save` (insert or
  replace, which covers the editing the artifact lacked; it replaces the
  planned `add` + `update`, which were the same operation), `delete`.
- Games: `watchAll` (newest first), `add`, `delete`.
- Storage keeps **one document per team and per game**, keyed by id, instead
  of the artifact's month-sized arrays. Concurrent saves can't overwrite
  each other by design, with no re-read before writing. The guard test was
  mutation-checked: with a shared key it fails.
- The caller supplies ids (view models use the `IdGenerator`).
- **Tests (unit):** shared *contract* suites run against the local
  implementations **and** the fakes, covering save/add, edit, ordering,
  live delete and concurrent adds. A cross-repository test checks that
  deleting a team keeps its games with its name.
- **Fakes:** `FakeTeamRepository` and `FakeGameLogRepository`, in
  `providersFake()`. Both are wired in DI.

## Phase 3: Teams tab

### ✅ 3.1 Team list
- `TeamsViewModel` watches the team repository and exposes `loaded`,
  `teams`, a `deleteTeam` command and `undoDelete`.
- The list shows each team's name and six Pokémon (sprite plus name). The
  sprites come from `PokemonRef.spriteUrl`, which derives PokéAPI's URL
  from the id, so drawing the list needs no network calls.
- **Type badges moved to the team detail screen (7.3).** Teams store
  lightweight refs, so badges in the list would cost 6 detail lookups per
  team.
- Delete asks for confirmation ("Games logged with it are kept"), then
  shows a snackbar with **Undo**. A failed delete says so and keeps the
  team.
- **Tests:**
  - Acceptance widget test through the whole app: list, confirm-delete,
    undo.
  - View model: loading, delete/undo, failure.
  - Screen: spinner, empty, list, cancel, confirm+undo, failure.

### ✅ 3.2 Add and edit a team
- `TeamEditorViewModel` handles create and edit (`/teams/new`,
  `/teams/:id/edit`). Its rules:
  - the name is required
  - all 6 slots must be filled
  - no Pokémon twice
  - the **species clause**: `Pokemon.speciesSlug` (from PokéAPI) catches
    Charizard plus Charizard-Mega-Y. When the species lookups fail
    offline, only exact duplicates are checked, so saving isn't blocked.
    This fallback was mutation-checked.
- IDs come from the injected `IdGenerator` (`RandomIdGenerator` in the app).
- Editing a team that no longer exists (e.g. an old deep link) shows "This
  team no longer exists." instead of crashing. This was found by a test.
- UI:
  - an **Add team** button and a per-team **Edit** button
  - `PokemonAutocompleteField(initialValue:)` for pre-filled edits
  - a **sticky Save** button: it was hidden under the tab bar on macOS,
    so it no longer needs scrolling past six fields
- **Tests:**
  - Acceptance (create → list → edit), tagged `wip` until green.
  - View model: every rule.
  - Screen: the form states.
  - Router deep links.
  - **Integration journey on macOS:** create → list → edit → delete.
- Process change added during this step: acceptance tests in progress are
  tagged `wip` (see CLAUDE.md). The Stop hook skips them, and a step isn't
  done while any remain.

## Phase 4: Log Game tab

### ✅ 4.1 `LogGameViewModel` (the rules engine)
- Result (Win/Loss) is required.
- Your team, optional; picking another team clears the picks:
  - **exactly 4** brought, where a 5th is refused
  - **exactly 2** leads, picked only once 4 are brought and only from them
  - un-bringing a Pokémon also drops it as a lead
- The opponent:
  - 6 autocomplete slots
  - **up to 4** brought and **up to 2** leads (from their brought)
  - clearing a slot, or un-marking brought, drops that Pokémon from their
    brought and leads
- Refusals come back as messages from the toggle methods, for 4.2 to show
  as snackbars. They're worded as in the original ("Only 4 Pokémon can be
  brought.", "Pick Win or Loss first.", …).
- Mistake and notes are optional (notes are trimmed).
- Save stores UTC `playedAt` from `clock`, the team id plus a name
  snapshot, and every pick as slugs, then resets the form. **A failed
  save keeps everything entered** (mutation-checked).
- **Tests (unit):** 22, covering every rule and limit, with and without a
  team, and failure. 100% line coverage.

### ✅ 4.2 Log Game UI
- `LogGameScreen` follows the original's layout:
  - Win/Loss (`SegmentedButton`)
  - "Your team used" dropdown
  - brought and lead chips with "n / 4" and "n / 2" hints
  - the opponent's section (6 autocomplete slots, then brought and lead
    chips)
  - "What decided this game?"
  - Notes
  - a **sticky Save game** button
- Refusals and save errors show as snackbars, and success shows "Game
  logged ✓". A new key rebuilds the form after each save, clearing text
  fields and dropdowns.
- **Tests:**
  - Acceptance widget test through the app, checking every stored field.
  - Screen tests: picker limits, the opponent section, validation, reset,
    failure.
  - **Integration journey on macOS:** create a team → log a game with it.
- Visually checked at a desktop window size in dark mode (a probe render,
  not committed).
- **Moved to 5.2:** checking the logged game in Progress' recent games,
  since the Progress screen doesn't exist until Phase 5.

## Phase 5: Progress tab

### ✅ 5.1 `ProgressViewModel`: statistics
Recomputed into an immutable `ProgressStats` whenever the game log changes,
never in `build()`. A "local day" is the date of `playedAt` converted to
the device timezone (injectable, so tests pin UTC-6).
- **Totals and win %:** rounded like the original's `Math.round`, and
  `null` with no games (shown as "–").
- **Last 7 days:** today plus the 6 previous *local calendar* days. This
  fixes the original's UTC bug, and a mutation check with UTC days fails
  the test.
- **Day streak:** consecutive local days, counting back from today, or
  from yesterday if nothing is logged yet today.
- **Weekly focus:** the most common real mistake (not "played well") in
  the last 14 local days, reported as "N of M", where M = games in the
  window with a real mistake picked. A tie goes to the most recent.
- **Mistake breakdown:** every picked category including "played well",
  all time. Ties are in option order (explicit, since `List.sort` isn't
  stable).
- **Win rate by team:** grouped by id, with the name from the most recent
  game. Deleted teams are kept. Most games first, then name.
- **Opponent leads:** the top 8 by times seen, with your win % against
  each. A tie goes to the most recently seen (mutation-checked).
- **Recent games:** all of them, newest first, updated live.
- **Tests:** 15 unit tests, 100% line coverage. There's no UI yet (5.2),
  so no `wip` acceptance test in this step.

### ✅ 5.2 Progress UI
- `ProgressScreen`:
  - **Overview:** stat boxes, "–" when empty.
  - **This week's focus:** the accurate "N of the M games with a mistake
    noted in the last 14 days" wording.
  - Win rate by team, and the most common opponent leads.
  - **Mistake breakdown:** plain-widget bars.
  - **Recent games:** a lazy `SliverList.builder`, the first 15 plus
    "Show all (N)", with delete and **Undo**.
- `ProgressViewModel` gained `deleteGame`/`undoDelete`, `dateLabel` (local
  date) and `pokemonName`.
- `AppColors.of(context)` replaces `extension<AppColors>()!`, falling back
  to the light/dark defaults instead of crashing.
- **Bug found by the macOS journey, fixed with regression tests:**
  snackbars were shown by the shell's `Scaffold`, right over the tabs'
  sticky buttons (Save game, Add team) for about 4 seconds. Each tab now
  owns a `ScaffoldMessenger`.
- **Tests:**
  - An acceptance widget test through the app: totals, streak, focus, team
    record, delete and undo.
  - Card empty/data states, and Show all.
  - **Goldens** (`test/goldens/`, light and dark, fixed data/clock/tz).
  - **Integration:** the log-game journey logs two games and checks totals,
    win rate, streak and the team record in Progress.

## Phase 6: Routine tab

### ✅ 6.1 Checklists (D3: saved per day)
- The original's 3 cards (3 + 5 + 4 items) live in `domain/models/
  routine.dart`, each item with a **stable id**. The wording is verbatim,
  except the two items that said "below" now name the tab ("in Progress",
  "in Log Game").
- `RoutineRepository`, with a local implementation, a fake and a shared
  contract: one small document per local day, so each day starts empty.
- `RoutineViewModel` loads today's ticks by local date. `toggle` ticks
  instantly, then saves, and a failed save puts the tick back with a
  snackbar. A shared `isoDate` helper, also used by Progress, formats the
  date.
- **Tests:**
  - An acceptance test through the app: a tick survives an app restart.
  - The repository contract (real and fake).
  - The view model: the local day, toggle, the next day being empty, and
    failure revert.
  - The screen.
  - A visual check at a desktop window size.
- **Not included:** resetting at midnight while the app stays open (a
  fresh load of the tab resets).
- **Fixed during 7.3:** ticks are now saved under the day that was
  loaded. Before, a tick made after midnight with the tab still open
  saved the previous day's ticks into the new day. A test that only
  passed on 2026-09-30 exposed it. One known uncovered line: the local
  repository's "storage read failed" branch (in-memory storage can't fail).

## Phase 7: Team analysis (from the Reg M-C artifact)

### ✅ 7.1 Showdown import and export
- **Megas from held items:** `PokemonRepository.resolve(name, item:)`.
  A stone is the species' name + `ite` (sometimes minus its last letter,
  or plus an `n`), with an optional X/Y/Z, and the Mega must exist in the
  index. This covers Metagrossite, Salamencite, Raichunite Y and
  Garchompite Z, and it rejects Eviolite and other species' stones.
- **Parsing:** `ShowdownFormat.parse` (in `lib/domain/showdown/`) turns a
  paste into `PokemonSet`s. `PokemonSet` is built from the new `Stat`,
  `Nature` (all 25) and `StatSpread` models. The parser reads:
  - nicknames, gender, item and level
  - EVs and IVs, including partial IV lines
  - the nature and up to 4 moves
  - abilities, including the artifact's `A → B` (`->` also works)

  When a line is missing, the parser uses VGC defaults: level 50,
  31 IVs, Serious nature. It skips Showdown extras this app doesn't use
  (Tera Type, Shiny and so on), and treats CRLF and extra blank lines as
  normal. It lists every problem with its line number:
  - EVs over 510 in total, or over 252 on one stat
  - IVs over 31, or a level outside 1–100
  - unknown natures or stats
  - a 5th move
  - unrecognised lines
- **Exporting:** `ShowdownFormat.export` writes lines in Showdown's order,
  listing only non-zero EVs and IVs below 31.
- **Tests (unit):**
  - The artifact's 3 teams as verbatim fixtures: each parses and exports
    back to the exact same text.
  - The parser and exporter rules, and the Nature and StatSpread models.
  - The stone rule, checked against the recorded full PokéAPI index.
  - I also broke each validation rule on purpose, one at a time, and a
    test failed every time.
- **Not included yet:** `PokemonSet` has no stored JSON yet. It gets
  stored JSON and a pinned-JSON test in 7.3, when teams start saving sets.

### ✅ 7.2 Stat calculator
- **The calculator:** `calculateStats(BaseStats, PokemonSet)` in
  `lib/domain/stats/` returns a `StatSpread` of actual stats. It uses the
  games' formula at the set's level (50 unless the paste says otherwise):
  every 4th EV counts, each step rounds down, and the nature's ±10 % is
  done in whole numbers, so 1.1 never rounds wrong. Megas get their stats
  by passing the Mega's own base stats. Looking those up happens in 7.3.
- **Also added:** `BaseStats.of(Stat)`.
- **Tests (unit):**
  - The artifact's Team 1 paste gives Kingambit 207 HP and 137 / 178 /
    184 / 200 / 130 Spe for Kleavor, Mega Metagross, Whimsicott, Mega
    Raichu Y and Basculegion, using PokéAPI base stats checked on
    2026-09-30.
  - The formula: 0 and 252 EVs, EV rounding, IVs, nature up and down with
    rounding, and the level coming from the set.
  - I broke each part of the formula on purpose, one at a time, and a
    test failed every time.

### ✅ 7.3 Full team sets in the app
- **Data:**
  - `PokeApiService.getItem` (`/item/{slug}`, with a recorded fixture
    and a contract test).
  - A new `ItemRepository` (remote with a per-item cache, and a fake).
  - `Pokemon.abilities` is now mapped from PokéAPI.
  - `Team.sets` is an optional list lined up with `pokemon`.
  - `PokemonSet` and `StatSpread` gained stored JSON, with pinned-JSON
    tests. Teams saved before this load with no sets, so no schema bump
    was needed.
- **Import (`TeamImportViewModel` and screen, from "Import from
  Showdown" on the Teams tab):**
  - It parses the paste and lists every problem: paste errors with
    their line numbers, a team that isn't exactly 6, unknown species
    or items, abilities the Pokémon can't have, a Mega ability without
    the stone or that the Mega can't have, and the species clause.
  - If PokéAPI can't be reached, it shows one clear message and saves
    nothing.
  - The team stores base forms (as the editor does); the sets keep the
    paste.
- **Detail (`TeamDetailViewModel` and screen, opened by tapping a
  team):**
  - Each Pokémon's battle form: the Mega when it holds its stone.
  - Each card shows avatar, types, item, ability (`A → B`), moves and
    calculated stats.
  - The Speed order lists the team fastest first; ties keep team
    order.
  - A team without sets shows its Pokémon and suggests importing.
  - Missing teams and failed lookups (with Retry) are handled.
- **Editor:** it keeps the sets when only the name changes, and drops
  them once a Pokémon changes, since they'd no longer match.
- **Tests:**
  - Unit tests: stored JSON, service, item repository, both view
    models, and the editor's set rule.
  - Widget tests: both screens and the Teams tab buttons.
  - An acceptance test through the app.
  - **Integration (macOS):** paste Team 1 → open it → Mega Metagross
    178 Spe.
  - I broke each check on purpose, one at a time, and a test failed
    every time. I also checked screenshots at a desktop window size.

### ✅ 7.4 Sample teams
- **Format config:** `FormatConfig` in `lib/config/format_config.dart`
  holds the label and the sample teams, provided through DI. Reg M-C
  carries the artifact's 3 pastes verbatim, pinned to the fixtures by a
  test. The header label now comes from the config; a test with a "Reg
  Z" config proves it.
- **Use case:** `ImportTeamUseCase` (`lib/domain/use_cases/`) took the
  paste checks out of `TeamImportViewModel`, so the import screen and
  the sample teams share them. It's the first use case, recorded in
  `architecture.md`.
- **Adding samples:** an empty Teams tab offers "Add Reg M-C sample
  teams". `TeamsViewModel.addSampleTeams` checks all 3 first and saves
  only if every one passes. A failure, e.g. offline, saves nothing and
  shows a snackbar.
- **Tests:**
  - **Acceptance (widget):** the button adds 3 teams; Big Six shows
    Mega Charizard Y 167 and Mega Floette 169 Spe.
  - **Integration (macOS):** exactly 3 teams appear.
  - **Unit and widget:** the config, the use case, the view model
    (including all-or-nothing, where the last team fails) and the
    Teams tab states.

### ✅ 7.5 Opponent teams: save and manage
Not in the original. Added 2026-10-01 at the user's request, before 8.4,
so that backup covers it from the start.
- **Model:** `Team` gains `side` (`mine` or `opponent`), defaulting to
  `mine`, so saved teams keep loading without a migration. One
  repository and one store. View models filter by side, so "your team"
  pickers never list opponents.
- **Teams tab:** a "My teams" / "Opponents" toggle at the top. Add, edit,
  delete, Showdown import (VGC open team sheets) and the detail screen
  all work for either side. Sample teams stay "mine".
- **Tests:** unit tests for the model JSON (old teams load as `mine`)
  and the view model filtering, widget tests for the toggle, and an
  acceptance test that adds an opponent team which then never appears
  under My teams.
- **As built:**
  - `Routes.newTeamOn` / `importTeamOn` add `?side=opponent`, and the
    router reads it back with `Routes.sideOf` (unknown values mean
    `mine`).
  - `ImportTeamUseCase` takes the side.
  - Editing a team keeps its side.
  - Log Game's "Your team used" lists only `mine`.
  - The opponent screens say so in their titles: "New opponent team",
    "Import opponent team".
  - **Tests:** a macOS journey was added too. Breaking each side rule
    on purpose fails a test (Teams filter, Log Game filter, the editor
    keeping and saving the side, import side).

### ✅ 7.6 Pick the opponent's team in Log Game
- A "Their team" picker lists saved opponent teams. Picking one fills the
  opponent's 6 Pokémon, and they can still be edited.
- `GameLog` gains `opponentTeamId` and `opponentTeamName`, like
  `teamId` and `teamName`, with null for older games.
- **Tests:** view model (fill, edit after picking, cleared on reset),
  widget, and an acceptance test that logs a game against a saved
  opponent team.
- **As built:**
  - The picker shows only when opponent teams exist.
  - Picking a team also clears their brought and leads, since those
    came from the old slots.
  - "Not a saved team" unlinks the game but keeps the Pokémon.
  - Swapping a Pokémon keeps the link.
  - The 6 fields are keyed by the picked team, so they refill.
  - The macOS opponent journey now goes through Log Game, and each rule
    has been checked by breaking it on purpose.

### ✅ 7.7 Save an opponent team from a logged game
- "Save their team" on a recent game whose opponent's 6 Pokémon were
  entered. It asks for a name and saves an opponent team. The game is
  then linked to it, so its matchup record counts it.
- **Tests:** view model (needs all 6, linking), widget, and acceptance.
- **As built:**
  - `ProgressViewModel` gained the team and Pokémon repositories and the
    id generator.
  - `saveOpponentTeam` looks each stored name up in the Pokémon index,
    saves the team, then re-adds the game linked to it. The repository
    contract now states "add replaces by id". The command completes
    with the saved name, for the snackbar.
  - Blank names and failed lookups give a clear message, and nothing is
    half-saved.
  - Each rule has been checked by breaking it on purpose, and the macOS
    opponent journey covers the flow.

### ✅ 7.8 Matchup stats
- A Progress card "Vs opponent teams" gives the record and win % per
  saved opponent team, grouped by id (as team records are, 5.1). Only
  games linked to an opponent team count.
- **Tests:** stats unit tests (grouping, renamed teams, unlinked games
  ignored), widget, and acceptance.
- **As built:**
  - `ProgressStats.opponentTeamRecords` reuses `TeamRecord`. The team
    record logic is now one `_records(games, id:, name:)` helper shared
    by both. One `_RecordsCard` widget serves "Win rate by team" and
    "Vs opponent teams", and screen readers hear each row as one phrase.
  - The Progress screenshots were re-recorded on purpose for the new
    card, after checking them.
  - Breaking it on purpose: grouping by your team id, and the card
    showing your records, are both caught. One survivor, a name
    fallback, is equivalent: id and name are always saved together.
  - The macOS journey checks the record after "Save their team".

### ✅ 7.9 Team notes
Not in the original. Added 2026-10-01 at the user's request (7.9–7.12).
- **Model:** `Team` gains `notes`, defaulting to empty, so saved teams and
  older backups load unchanged. Any side can have notes: scouting notes
  on an opponent's team, a game plan or EV reasoning on yours.
- **Team detail screen:** a Notes section, editable in place, with Save.
- **Backup:** included automatically, since it's part of the team's JSON.
- **Tests:** model JSON (old teams load with no notes), the view model
  (edit, save, failed save), widget, and acceptance (write notes on an
  opponent team, reopen it, and they're there).
- **As built:**
  - The Notes card is the first section of the team detail screen, for
    any team, with or without sets.
  - `TeamDetailViewModel` keeps the loaded team, and `saveNotes` trims
    the text and keeps everything else on the team. A failed save keeps
    the old notes.
  - The detail screen got its own `ScaffoldMessenger`, like the other
    screens.
  - The backup round-trip test now includes team notes.
  - Each rule has been checked by breaking it on purpose, and the macOS
    opponent journey saves notes.

### ✅ 7.10 Matchup notes
- **Model:** `MatchupNote` holds your team id, their team id, the notes
  and an updated-at time. A new `MatchupRepository` (local store
  `matchups`, keyed by the pair, plus a fake) has a shared contract
  that includes watching one pair.
- **Team detail screen:** a "Matchup notes" section lists the other
  side's teams. On an opponent team it lists your teams, and on yours
  it lists opponents. Each entry is editable.
- **Backup:** gains `matchups`. Older backups without it still restore,
  so the format stays at version 1.
- **Tests:** the repository contract (real and fake), the view model,
  widget, backup round trip with matchups, and acceptance.
- **As built:**
  - `MatchupRepository` has `watchAll` and `save` (upsert by pair, using
    `MatchupNote.keyOf`). A per-pair watch is left to 7.11, if the Log
    Game card needs it, rather than added unused now.
  - `TeamDetailViewModel` lists the other side's teams in name order,
    with titles always "your team vs theirs". Saving from either side
    stores the same orientation, trimmed.
  - Each row opens a "Game plan" dialog, capped at 480 px.
  - The rows are a plain column, not a lazy list: there's one per team
    on the other side, a small number.
  - Backup's summary mentions matchup notes only when there are some, so
    the earlier wording didn't change.
  - Each rule has been checked by breaking it on purpose: orientation,
    other side only, trimming, export, and the summary.

### ✅ 7.11 Game plan in Log Game
- Picking "Their team" shows a **Game plan** card above their slots,
  with that team's notes. Picking "Your team used" as well adds that
  matchup's notes, editable in place, so the plan is in front of you
  before the battle.
- **Tests:** the view model (which notes show for which picks, editing
  the matchup), widget, and acceptance.
- **As built:**
  - `LogGameViewModel` watches all matchup notes (no per-pair watch was
    needed), and reads their team's notes from the latest team data, so
    edits made elsewhere show up live.
  - The card shows "No notes on their team yet", "Pick your team to see
    your plan for this matchup" or "No plan yet for this matchup" where
    fitting. The edit dialog is now a shared `MatchupNotesDialog` in
    `ui/core/`.
  - `pumpApp` can seed matchup notes.
  - Each rule has been checked by breaking it on purpose: latest team
    notes, live matchup notes, trimming, and showing the card only once
    their team is picked.

### ✅ 7.12 Turn a game's notes into matchup notes
- After saving a game against a saved opponent team, if the game had
  notes, the confirmation snackbar offers **"Add to matchup notes"**.
  It appends the date and the note to the notes for your team against
  theirs, or to their team's notes if no team of yours was picked.
- **Tests:** the view model (appending, the target with and without
  your team), widget, and acceptance.
- **As built:**
  - `LogGameViewModel` remembers the last saved game and appends
    `<local date>: <notes>` on a new line, or as the first line when
    there's nothing yet. The local date uses an injectable `toLocal`,
    like Routine and Progress.
  - The action's label says where the notes go: "Add to matchup notes"
    or "Add to their notes". The confirmation names the target ("Added
    to Big Six vs Rival Grassy").
  - If their team was deleted meanwhile, it says so and saves nothing.
  - Each rule has been checked by breaking it on purpose: no blank
    first line, local date, notes required, matchup when your team was
    picked.

## Phase 8: Polish and release readiness

- ✅ **8.1 Resilience:** every PokéAPI-backed widget was audited. Most of
  them were already covered by earlier steps:
  - Avatars fall back to an icon.
  - The team detail screen has Retry.
  - Import and sample teams show one clear offline message and save
    nothing.
  - The editor skips the species check offline.
  - The cached index is the offline fallback (2.1).

  The one gap was the Pokémon autocomplete: a failed search looked like
  "no matches". Its `search` now returns a `Result`, and both view models
  pass failures through. The field then says "Can't reach PokéAPI. Keep
  typing to try again." and clears that on the next successful
  keystroke.
  - **Tests:** an acceptance test runs the whole app offline (editor and
    Log Game) and recovers once back online. The field has widget tests,
    and the view models' search tests now expect the failure passed
    through.
- ✅ **8.2 Accessibility:** an acceptance test visits all 8 screens and
  scrolls each page by page, so lazy rows are checked too.
  - **Guidelines:** text contrast, labelled tap targets, and Android/iOS
    tap-target size, in both themes. At 200 % text, nothing may
    overflow.
  - **Found and fixed:**
    - Dark-mode text on the accent was 4.48:1, under WCAG AA. It now
      uses the background color (about 6.3:1), keeping the original
      accent. A theme test checks the ratio in both themes.
    - Log Game's team dropdown overflowed at 200 % with long team
      names; it now expands and shortens them.
  - **Screen readers:**
    - Bring/lead chips say their role ("Kingambit, lead"), which was
      shown only by color.
    - Team detail stats read in full ("Speed 178", via `Stat.fullName`).
    - Progress stat boxes, rate rows and mistake bars each read as one
      phrase ("overall win rate: 50%").
    - Avatars were already labelled.
- ✅ **8.3 Performance pass:**
  - **Audit against `performance.md`: clean.** No `Opacity`, intrinsic
    sizing, `saveLayer` triggers or clipping. Growing lists use
    `.builder` or slivers. No sorting or filtering in `build()`. No
    widget-returning helpers. Progress computes stats once per data
    change.
  - **Measured (2026-10-01, macOS, profile mode, via
    `integration_test/perf/progress_perf.dart`):** Progress with 1,000
    generated games — open, "Show all (1000)", fling through and back
    (61 frames):

    | | avg | p90 | p99 | worst | over budget |
    |---|---|---|---|---|---|
    | build | 1.9 ms | 3.9 ms | 7.6 ms | 7.7 ms | 0 |
    | raster | 1.1 ms | 1.8 ms | 1.9 ms | 1.9 ms | 0 |

    Every frame is within the ≤8 ms build target, so no code changes
    were needed.
  - **Guard:** a widget test checks that with 1,000 games and "Show
    all", fewer than 100 rows are built. Making the list eager builds
    all 1,000 and fails it.
  - **Found on the way:** both macOS entitlements files lacked
    `com.apple.security.network.client`, so the sandboxed macOS app
    couldn't reach PokéAPI or load sprites in any build. Added, with a
    test that reads both files.
  - **Tooling:** `flutter_driver` (SDK, test-only) was added, with the
    user's OK.
- ✅ **8.4 Backup:** all data is exported and imported as JSON, since
  it's local only. The user chose the clipboard (no new package) and
  merge-by-id restore on 2026-10-01.
  - **Where:** a "Backup & restore" icon in the header opens `/backup`,
    a full-screen route capped at 640 px like the tabs.
  - **Copy backup** puts the JSON on the clipboard with a summary
    ("2 teams, 1 game, 1 routine day").
  - **Restore** merges a pasted backup: the backup's copy replaces
    anything with the same id, and everything else stays, so restoring
    twice changes nothing.
  - **The format:** `BackupFormat` is a pure encode/decode, marked with
    the app name and `format_version` 1. It covers teams (both sides,
    with sets), games and routine days; the Pokémon index is left out
    because it can be downloaded again. It refuses non-JSON, other
    JSON, newer versions and damaged backups, each with a clear
    message.
  - **New storage and repository calls:** `LocalStorageService.getAll`
    and `watch`, plus `RoutineRepository.allDays` and `watchOn`. Restore
    exposed a bug: the Routine tab read its day once, so a restore (or
    any change made elsewhere) didn't show until a restart. It now
    watches its day, like Teams and Progress do.
  - **Test setup fix:** each `pumpApp` call now builds a fresh app (it
    has a unique key), so tests that simulate a restart really get one.
  - **Tests:**
    - Round trip and every refusal (unit).
    - Merge, idempotency, export contents and errors (view model).
    - The screen (widget).
    - Acceptance: copy from one app, restore into an empty one;
      everything is back, live.
    - A macOS journey, using a fake clipboard so test runs never
      overwrite the developer's real one.
    - Six rules broken on purpose, one at a time; a test caught each.
- ⏸ **8.5 CI (optional): deferred by the user on 2026-10-01.** This is
  a GitHub Actions workflow running `flutter analyze`, `flutter test`
  and the integration tests on macOS. Pick it up whenever the project
  uses a hosted remote for CI.
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
| *(new)* Saved opponent teams, Log Game picker, matchup stats | 7.5–7.8 |
| *(new)* Team notes, matchup notes, Log Game game plan, notes from a game | 7.9–7.12 |

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
