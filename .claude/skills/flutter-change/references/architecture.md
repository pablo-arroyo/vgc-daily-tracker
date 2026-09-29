# Architecture rules

Distilled from https://docs.flutter.dev/app-architecture/recommendations, plus
the decisions this project made for each item. Flutter's level is in brackets:
**[Strong]** = strongly recommend, **[Rec]** = recommend, **[Cond]** = conditional.

**Status:** every "Decision:" below was confirmed by the user on 2026-09-29.
They are settled; don't reopen them without the user asking.

If a change needs to break one of these rules, stop and raise it with the user
instead of quietly deviating. Record any new decision here.

## Layers

```
View (widget) ──calls commands──▶ ViewModel ──▶ Repository ──▶ Service ──▶ PokéAPI / disk
     ◀──listens (ChangeNotifier)──     ◀── domain models ──    ◀── API models ──
```

- **Separate data and UI layers. [Strong]** The data layer (repositories and
  services) owns the app data and most business logic. The UI layer (views and
  view models) displays data and forwards user events.
- **Repository pattern. [Strong]**
  - *Services* wrap exactly one external source, such as the PokéAPI HTTP
    client or local storage. They are stateless and return raw API models.
  - *Repositories* are the single source of truth for each kind of data. They
    call services, cache results, handle retries and errors, and turn API models
    into domain models.
- **Abstract repository classes. [Strong]** Every repository is an abstract
  class with at least one real implementation and one fake. This lets us swap
  environments (dev/staging/offline) and makes testing trivial.
- **MVVM in the UI. [Strong]** Each screen is a `View` widget plus a
  `ViewModel`. The View stays dumb.
- **No logic in widgets. [Strong]** A widget may only contain:
  - simple `if`s that show or hide something based on a view model flag or a
    nullable field
  - animation logic that needs the widget to calculate
  - layout logic based on device info (screen size, orientation)
  - simple routing calls

  Everything else (filtering, sorting, formatting stats, deciding what to load)
  goes in the view model.
- **Shared widgets (`ui/core/`) take data and callbacks, never repositories.**
  For example, `PokemonAutocompleteField` gets a `search` function and an
  `onChanged` callback from the screen's view model. That keeps it reusable
  (your team and the opponent's use the same field) and testable with a
  fake's `search`.
- **Domain layer / use-cases. [Cond] — Decision: NOT used for now.** Add a
  use-case only when logic is duplicated across view models or crowds one. Team
  analysis across several repositories is the likely first candidate.

## Data

- **Unidirectional data flow. [Strong]** Data flows down from the data layer
  to the UI. User events flow up from the UI to the data layer. The UI never
  mutates data it received.
- **Immutable models. [Strong]** Every model is immutable. To change one,
  create a new instance with `copyWith`.
- **freezed / built_value. [Rec] — Decision: `freezed` + `json_serializable`.**
  These generate equality, `copyWith` and JSON methods. Run
  `dart run build_runner build --delete-conflicting-outputs` after changing a
  model. Generated `*.g.dart` and `*.freezed.dart` files are **committed**
  (a fresh clone builds and tests without running `build_runner`), and they're
  excluded from analysis and the formatting hook. `build.yaml` sets
  `field_rename: snake` and `checked: true`. With `checked`, a wrong JSON
  shape throws `CheckedFromJsonException` (an `Exception`), which services
  turn into a `Failure`.
- **Separate API and domain models. [Cond] — Decision: YES.** PokéAPI
  responses are large and deeply nested (`pokemon`, `pokemon-species`, `move`,
  `type` and so on). API models mirror the JSON exactly and live next to their
  service. Domain models hold only what the app needs, and the repository maps
  API models to domain models. View models and widgets never see an API model.
- **Commands for user events. [Rec] — Decision: YES.** View models expose
  `Command0<T>` / `Command1<T, A>` objects (running/error/completed state, and they
  prevent double execution) instead of bare async methods. Views bind to
  `command.running` and `command.error`, not to ad-hoc booleans. Pair them with
  a `Result<T>` type (`Ok` / `Failure`; not `Error`, which would shadow
  `dart:core`) returned from repositories so errors are
  values, not thrown exceptions crossing layers. Both types live in `lib/utils/`.

## App structure

- **Dependency injection. [Strong] — Decision: the `provider` package.**
  Wire services, then repositories, then view models in one place
  (`lib/config/dependencies.dart`, which contains only the real
  `providersRemote()`). Don't use global singletons or `static` instances.
  View models receive repositories through their constructor. The fake setup
  is `providersFake()` in `testing/app.dart`, which `pumpApp` uses, so test
  fakes never ship in the app.
- **State updates. [Cond] — Decision: `ChangeNotifier` + `ListenableBuilder`.**
  View models extend `ChangeNotifier`. Views rebuild with
  `ListenableBuilder` scoped as tightly as possible (see
  performance.md → build cost).
- **Persistence — Decision: local-first with `sembast`** (roadmap D1). One
  `LocalStorageService` wraps it: `databaseFactoryMemory` in tests,
  `databaseFactoryIo` on mobile and desktop, and `databaseFactoryWeb` on web.
  Repositories are the only callers. Cloud sync, if it comes later, is a new
  repository implementation, not a UI change.
- **Time and IDs are injected.** Use `package:clock` for anything that
  depends on "now", and an `IdGenerator` for new IDs, so tests can control
  both. Store instants in **UTC**, e.g. `GameLog.playedAt =
  clock.now().toUtc()`, and derive local days only for display.
- **Stored JSON is pinned by tests.** Every stored model has a test with its
  exact JSON. `build.yaml` sets `explicit_to_json: true`, so nested models
  become plain maps (sembast can't store Dart objects). A breaking shape
  change bumps `appSchemaVersion` and adds a migration with a test.
- **Navigation. [Rec] — Decision: `go_router`.** All routes are defined in
  `lib/routing/`, and route paths are constants.
- **View models are created in the route**, with
  `ChangeNotifierProvider(create: ... context.read() ..., child: Screen())`,
  so each is built once per tab and disposed with it. Screens get it with
  `context.read<XViewModel>()` and rebuild through `ListenableBuilder`.
  Dialogs and snackbars that react to a command's result are UI flow and
  live in the view; the operation itself lives in the view model.
- **Naming. [Rec]** Name classes after their architectural role:
  `TeamBuilderScreen`, `TeamBuilderViewModel`, `PokemonRepository`,
  `PokeApiService`. Don't use names that clash with Flutter SDK names. Shared
  widgets go in `ui/core/`, **not** a `widgets/` folder.

### Directory layout

```
lib/
  config/          dependencies.dart (provider wiring), environment config
  data/
    services/      PokeApiService, LocalStorageService + their API models
    repositories/  <name>/<name>_repository.dart (abstract)
                   <name>/<name>_repository_remote.dart, _local.dart, ...
  domain/
    models/        immutable freezed domain models
  routing/         go_router config, route constants
  ui/
    core/          shared widgets, theme
    <feature>/
      view_models/ <feature>_view_model.dart
      widgets/     <feature>_screen.dart + feature-private widgets
  utils/           command.dart, result.dart
  main.dart
test/              mirrors lib/
testing/           fakes and fixtures shared across tests (FakePokemonRepository, JSON fixtures)
```

## Testing

- **Test components separately and together. [Strong]**
  - Unit test every service, repository and view model, method by method.
  - Widget test every view. Routing and DI wiring deserve explicit tests.
- **Integration tests are journeys.** `integration_test/app_test.dart` is
  the only integration entry point. Desktop runs relaunch the app per test
  file, and the second launch fails on macOS. Add each flow as a function
  in `integration_test/journeys/` and register it there as a `group`.
- **Fakes, not mocks. [Strong]** Write `Fake<Name>Repository` /
  `Fake<Name>Service` classes in `testing/` that implement the abstract class
  with in-memory data. Tests check inputs and outputs, not calls. Service
  tests use recorded PokéAPI JSON fixtures and never hit the network.
- **Fakes pass the real contract.** Each repository's behavior lives in a
  shared `<name>_repository_contract.dart` suite that runs against the real
  implementation *and* its fake (see `test/data/repositories/team/`). Screen
  tests can then trust the fake. Shared rules such as sort order are
  functions next to the interface (`compareTeamsByName`), used by both.
- **Local storage is one document per record**, keyed by id. There's no
  read-modify-write of shared documents, so concurrent writes can't clobber
  each other.
