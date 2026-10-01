import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/nature.dart';
import '../models/pokemon.dart';
import '../models/pokemon_set.dart';
import '../models/stat_spread.dart';
import 'stat_calculator.dart';

part 'speed_order.freezed.dart';

enum SpeedSide { mine, theirs }

/// What changes the turn order: Tailwind doubles one side's Speed; Trick
/// Room makes the slowest move first.
enum SpeedMode { normal, tailwindMine, tailwindTheirs, trickRoom }

/// One Pokémon to place: its battle form's base stats, and its set when
/// known (an opponent's spread usually isn't).
typedef SpeedInput = ({
  SpeedSide side,
  String name,
  BaseStats base,
  PokemonSet? set,
});

/// A Pokémon's place in the order: an exact Speed ([min] == [max]) or the
/// range an unknown spread allows. [tie] marks an exact Speed another
/// Pokémon matches.
@freezed
abstract class SpeedEntry with _$SpeedEntry {
  const factory SpeedEntry({
    required SpeedSide side,
    required String name,
    required int min,
    required int max,
    @Default(false) bool tie,
  }) = _SpeedEntry;
}

/// [inputs] in the order they move under [mode]. Equal places keep the
/// input order (sorted explicitly, since List.sort isn't stable).
List<SpeedEntry> speedOrder(
  List<SpeedInput> inputs, {
  SpeedMode mode = SpeedMode.normal,
}) {
  final entries = [
    for (final (i, input) in inputs.indexed)
      (index: i, entry: _entry(input, mode)),
  ];
  final trickRoom = mode == SpeedMode.trickRoom;
  entries.sort((a, b) {
    final byPace = trickRoom
        ? a.entry.min.compareTo(b.entry.min)
        : b.entry.max.compareTo(a.entry.max);
    return byPace != 0 ? byPace : a.index.compareTo(b.index);
  });

  final exact = <int, int>{};
  for (final (:entry, index: _) in entries) {
    if (entry.min == entry.max) exact[entry.min] = (exact[entry.min] ?? 0) + 1;
  }
  return [
    for (final (:entry, index: _) in entries)
      entry.copyWith(
        tie: entry.min == entry.max && (exact[entry.min] ?? 0) > 1,
      ),
  ];
}

SpeedEntry _entry(SpeedInput input, SpeedMode mode) {
  final (min, max) = switch (input.set) {
    final set? => (_speed(input.base, set), _speed(input.base, set)),
    null => (
      _speed(input.base, const PokemonSet(species: '')),
      _speed(
        input.base,
        const PokemonSet(
          species: '',
          evs: StatSpread(spe: 252),
          nature: Nature.timid,
        ),
      ),
    ),
  };
  final tailwind = switch (mode) {
    SpeedMode.tailwindMine => input.side == SpeedSide.mine,
    SpeedMode.tailwindTheirs => input.side == SpeedSide.theirs,
    _ => false,
  };
  final factor = tailwind ? 2 : 1;
  return SpeedEntry(
    side: input.side,
    name: input.name,
    min: min * factor,
    max: max * factor,
  );
}

/// The set's Speed with its held item: Choice Scarf ×1.5; Iron Ball and
/// Macho Brace ×½ (rounded down).
int _speed(BaseStats base, PokemonSet set) {
  final speed = calculateStats(base, set).spe;
  return switch (set.item?.toLowerCase().replaceAll(' ', '')) {
    'choicescarf' => speed * 3 ~/ 2,
    'ironball' || 'machobrace' => speed ~/ 2,
    _ => speed,
  };
}
