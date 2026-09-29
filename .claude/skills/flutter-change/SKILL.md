---
name: flutter-change
description: Required workflow for every feature, bugfix or update to the VGC Daily Tracker Flutter app. Loads the project's architecture (MVVM + repositories + services) and performance rules, plans the change per layer, implements it with tests, and self-reviews before finishing. Use whenever adding, changing or fixing anything under lib/ or test/, including "add a screen", "fix this bug", "refactor", "call a new PokéAPI endpoint" or "update the UI".
---

# Flutter change workflow

Follow these steps in order for every feature, bugfix or update. Skip a step
only when it truly doesn't apply, for example a pure copy change touches no
data layer. If you skip one, say so in your summary.

## 1. Load the rules

Read both reference files before writing any code:

- `references/architecture.md` covers layers, data flow, models, DI,
  routing, naming, directory layout and testing.
- `references/performance.md` covers build cost, lists, opacity/clipping and
  strings.

## 2. Understand the change

- **Feature meant to mimic the original VGC daily tracker artifact:** read that
  artifact first and match its behavior and data. Ask the user for the link if
  it isn't known.
- **Bugfix:** reproduce the bug first. Write a failing test that shows it
  whenever possible, and find the root cause before changing code.
- **New PokéAPI endpoint:** check its real response shape, either by fetching
  a sample or from the docs at https://pokeapi.co/docs/v2, and save a trimmed
  sample as a test fixture in `testing/`.

## 3. Plan by layer

Before editing, state briefly which layers the change touches and what goes
in each. Put things in this order, from the data source up to the UI:

1. **Service:** the endpoint call plus API models that mirror the JSON exactly.
2. **Repository:** add to the abstract class, the real implementation *and*
   the fake. Map API models to domain models and return `Result<T>`.
3. **Domain model:** a new or changed immutable `freezed` model.
4. **ViewModel:** state plus `Command`s. All logic goes here.
5. **View:** widgets only. Register the route in `lib/routing/` and add DI
   wiring in `lib/config/dependencies.dart`.

If the plan breaks an architecture rule, or needs a new package or a new
architectural decision, stop and ask the user before implementing it.

## 4. Implement with tests

Write the tests together with the code in each layer, not at the end:

- Services: unit tests against JSON fixtures. Never call the real network in
  tests.
- Repositories: unit tests using a fake service.
- ViewModels: unit tests using fake repositories. Cover success, error and
  loading states through the commands.
- Views: widget tests using fake repositories, covering the main states and
  any navigation.

After changing any `freezed` or `json_serializable` model, run
`dart run build_runner build --delete-conflicting-outputs`.

A PostToolUse hook runs `dart format` and `dart analyze` on every Dart file
you edit. Fix any issues it reports right away. Don't use `// ignore:`
comments unless there's a clear reason, and explain the reason in a comment.

## 5. Self-review the diff

Run `git diff` and check the change against this list:

**Architecture**
- [ ] No business or formatting logic in widgets. Only the allowed kinds of
      logic (flags, animation, layout, simple routing).
- [ ] Widgets never touch services or repositories directly. They only go
      through a view model.
- [ ] No API model leaks past its repository.
- [ ] All models are immutable, and changes use `copyWith`.
- [ ] No new globals or singletons. Dependencies come in through
      constructors and provider.
- [ ] Each new repository method exists in the abstract class, the real
      implementation and the fake.
- [ ] Names and file locations follow the layout in `architecture.md`.

**Performance**
- [ ] No sorting, filtering, parsing or I/O inside `build()`.
- [ ] Rebuild scope is narrow, and static subtrees are passed as `child:`.
- [ ] Lists that can grow use `.builder` constructors.
- [ ] No `Opacity` where a translucent color, `FadeInImage` or
      `AnimatedOpacity` would do. No needless clipping; rounded corners use
      `borderRadius`.
- [ ] No intrinsic sizing in lists or grids.
- [ ] Reusable UI pieces are widget classes, not helper functions.

**Tests**
- [ ] Every new or changed service, repository and view model method has a
      unit test. Every new view has a widget test.
- [ ] Bugfixes include a regression test that failed before the fix.

## 6. Verify and summarize

- Run `flutter analyze` and `flutter test`. The Stop hook runs them too and
  blocks finishing if they fail.
- If there's UI, offer to run the app (`flutter run -d chrome` or
  `-d macos`) so the user can see the change.
- Summarize the change for the user:
  - what changed in each layer
  - any rule you deviated from, and why
  - any decision that should be added to `references/architecture.md` or
    `CLAUDE.md`
- Don't commit unless the user asks. When they do, use the `git-commit` skill.
