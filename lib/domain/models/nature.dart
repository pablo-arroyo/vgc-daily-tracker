import 'stat.dart';

/// The 25 natures, in the games' order. Each raises one stat by 10 % and
/// lowers another; the 5 neutral ones change nothing.
enum Nature {
  hardy(),
  lonely(Stat.atk, Stat.def),
  brave(Stat.atk, Stat.spe),
  adamant(Stat.atk, Stat.spa),
  naughty(Stat.atk, Stat.spd),
  bold(Stat.def, Stat.atk),
  docile(),
  relaxed(Stat.def, Stat.spe),
  impish(Stat.def, Stat.spa),
  lax(Stat.def, Stat.spd),
  timid(Stat.spe, Stat.atk),
  hasty(Stat.spe, Stat.def),
  serious(),
  jolly(Stat.spe, Stat.spa),
  naive(Stat.spe, Stat.spd),
  modest(Stat.spa, Stat.atk),
  mild(Stat.spa, Stat.def),
  quiet(Stat.spa, Stat.spe),
  bashful(),
  rash(Stat.spa, Stat.spd),
  calm(Stat.spd, Stat.atk),
  gentle(Stat.spd, Stat.def),
  sassy(Stat.spd, Stat.spe),
  careful(Stat.spd, Stat.spa),
  quirky();

  const Nature([this.raised, this.lowered]);

  final Stat? raised;
  final Stat? lowered;

  /// `Adamant`, as Showdown writes it.
  String get label => name[0].toUpperCase() + name.substring(1);

  /// The nature called [name] (any case), or null if there's none.
  static Nature? byName(String name) {
    final wanted = name.trim().toLowerCase();
    return values.where((n) => n.name == wanted).firstOrNull;
  }
}
