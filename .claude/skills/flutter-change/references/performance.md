# Performance rules

Distilled from https://docs.flutter.dev/perf/best-practices. Rules marked
(lint) are enforced by `analysis_options.yaml`, so the analyzer hook catches
them. Everything else must be checked by reading the diff.

## Frame budget

- At 60 Hz a frame has 16 ms in total: aim for ≤8 ms build and ≤8 ms render.
  On 120 Hz devices the whole frame has 8 ms. Staying under budget also saves
  battery and heat.

## build() cost

- `build()` runs often, whenever an ancestor rebuilds. Don't do expensive
  work in it: no sorting or filtering, no JSON parsing, no creating
  controllers, no network or disk calls. Compute it in the view model and
  expose the result.
- Split big `build()` methods into smaller widgets based on **what changes
  together**, so a change only rebuilds the part that depends on it.
- Scope rebuilds narrowly. Put `ListenableBuilder` / `setState` as low in the
  tree as possible, around the subtree that actually changes, not around the
  whole screen.
- Use `const` constructors wherever possible (lint). A const subtree is
  skipped on rebuild.
- Pass subtrees that don't change as `child:` to builders such as
  `ListenableBuilder`, `AnimatedBuilder` and `TransitionBuilder`, instead of
  building them inside the builder callback. Rebuilds stop at a widget
  instance that is the same as last frame.
- Use `StatelessWidget` classes for reusable UI pieces, **not** helper methods
  or functions that return widgets.
- Don't override `operator ==` on widgets (it causes O(N²) rebuild checks). The
  only exception is leaf widgets that rarely change.

## Lists and grids

- Build them lazily. Use `ListView.builder`, `GridView.builder` and
  `SliverList.builder` for anything that can grow, such as Pokédex lists, move
  lists, usage tables and team history.
- Don't use `Column` / `ListView(children: [...])` with a concrete list when
  most children are off screen.
- Avoid intrinsic sizing passes (`IntrinsicHeight`, `IntrinsicWidth`, or
  "make every cell as big as the largest"). Instead give cells a fixed size,
  size them relative to one anchor cell, or write a custom `RenderObject` as
  a last resort.

## Opacity, clipping, saveLayer

- `saveLayer()` allocates an offscreen buffer and switches render targets,
  which is expensive on mobile GPUs. These widgets can trigger it: `ShaderMask`,
  `ColorFilter`, `Chip` with `disabledColorAlpha != 0xff`, and `Text` with an
  `overflowShader`. Use them sparingly, and never inside list items.
- Avoid the `Opacity` widget:
  - For simple shapes or text, draw with a semi-transparent color instead
    (e.g. `color.withValues(alpha: 0.5)`).
  - For fading an image in, use `FadeInImage`. This applies to Pokémon
    sprites and official artwork from PokéAPI.
  - For animated fades, use `AnimatedOpacity` / `FadeTransition`.
- Clipping is disabled by default (`Clip.none`). Turn it on only when needed,
  and never use `Clip.antiAliasWithSaveLayer` unless you must. For rounded
  corners, use a `borderRadius` on the decoration, not `ClipRRect`. Don't clip
  during animations; pre-clip the content instead.

## Strings

- When building a string from many parts, especially in a loop, use
  `StringBuffer` rather than `+` (lint: `use_string_buffers`).

## Debugging (when something is slow)

- Profile in **profile mode** on a real device: `flutter run --profile`.
- DevTools Performance view: enable *Track layouts* to find intrinsic passes
  (look for timeline events labeled `<Type> intrinsics`), and use
  `checkerboardOffscreenLayers` to find `saveLayer` calls.
