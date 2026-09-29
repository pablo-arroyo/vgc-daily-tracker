---
name: flutter-change
description: Required workflow for every feature, bugfix or update to the VGC Daily Tracker Flutter app. Loads the project's architecture (MVVM + repositories + services) and performance rules, plans the change per layer, implements it test-first (TDD red → green → refactor), and self-reviews before finishing. Use whenever adding, changing or fixing anything under lib/ or test/, including "add a screen", "fix this bug", "refactor", "call a new PokéAPI endpoint" or "update the UI".
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

## 4. Implement test-first (TDD)

Production code is only written to make a failing test pass. Work through the
layers in the order from step 3, and in each one repeat this loop:

1. **Red:** write *one* small test for the next behavior. Run it
   (`flutter test <file> --plain-name "<test>"`) and **watch it fail for the
   right reason**: an assertion failure, or a compile error about the
   missing class or method. A test that passes straight away tests nothing
   new, so fix the test.
2. **Green:** write the **minimum** production code that makes it pass.
   Hard-coding is fine if the next test will force a generalization. Don't
   add parameters, branches or classes that no test needs yet.
3. **Refactor:** with everything green, clean up both test and production
   code (names, duplication, the architecture and performance rules). Re-run
   the tests.

Then pick the next behavior. **Never change or delete a test just to make it
pass.** If a test turns out to be wrong, say so and fix the test deliberately,
as its own change.

**Outside-in for features:** start with the step's acceptance test, which is
the integration or widget test for the roadmap step's "Done when". It stays
red while you TDD the layers underneath it (service → repository →
view model → view), and goes green last.

What each layer's tests use:
- Services: unit tests against JSON fixtures. Never call the real network in
  tests.
- Repositories: unit tests using a fake service.
- ViewModels: unit tests using fake repositories. Cover success, error and
  loading states through the commands.
- Views: widget tests using fake repositories, covering the main states and
  any navigation.

**Where test-first doesn't apply** (say so in your summary when you use one of
these):
- generated code
- `pubspec.yaml` / config edits
- pure styling or theme values with no behavior
- golden tests, which record a screenshot of existing UI and so can only be
  created after it

Fakes in `testing/` are written as tests need them. They're test support, not
production code.

After changing any `freezed` or `json_serializable` model, run
`dart run build_runner build --delete-conflicting-outputs`.

A PostToolUse hook runs `dart format` and `dart analyze` on every Dart file
you edit.
- **In `lib/`:** analyzer issues are blocking. Fix them right away.
- **In test files:** issues are reported but don't block, because an
  undefined class or method there is the expected red step. Answer it with
  the minimum production code, never by weakening the test.

Fix any other issues it reports right away. Don't use `// ignore:`
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

**Tests (TDD)**
- [ ] Every production change was driven by a test you saw fail first.
      Nothing in `lib/` goes beyond what the tests require.
- [ ] Every new or changed service, repository and view model method has a
      unit test. Every new view has a widget test.
- [ ] The roadmap step's acceptance test (integration or widget) exists and
      passes.
- [ ] Bugfixes include a regression test that failed before the fix.
- [ ] No test was weakened, skipped or deleted to get green.

## 6. Verify and summarize

- Run `flutter analyze` and `flutter test`. The Stop hook runs them too and
  blocks finishing if they fail.
- Run `flutter test integration_test -d macos` before calling a roadmap step
  done. The Stop hook skips it because it's slow, taking a minute or more to
  build the macOS app.
- If there's UI, offer to run the app (`flutter run -d chrome` or
  `-d macos`) so the user can see the change.
- Summarize the change for the user:
  - what changed in each layer
  - the red → green sequence, in short: which tests drove which code, and
    any TDD exceptions you used
  - any rule you deviated from, and why
  - any decision that should be added to `references/architecture.md` or
    `CLAUDE.md`
- Don't commit unless the user asks. When they do, use the `git-commit` skill.
