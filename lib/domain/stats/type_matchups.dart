import '../models/type_chart.dart';

/// How one attacking type fares against a team: how many members it hits
/// super-effectively, how many resist it, and how many are immune.
typedef TypeCoverage = ({String type, int weak, int resist, int immune});

/// One of their attacking types and the Pokémon of yours it hits
/// super-effectively, with the multiplier (×2 or ×4).
typedef TypeThreat = ({
  String type,
  List<({String name, double multiplier})> hits,
});

/// A Pokémon of yours, by its battle form's types.
typedef TypedMember = ({String name, List<String> types});

/// Each of the 18 attacking types against [team] (each member's types),
/// most weaknesses first; ties keep the games' type order. Types only:
/// abilities such as Levitate aren't counted.
List<TypeCoverage> teamWeaknesses(TypeChart chart, List<List<String>> team) {
  final coverage = [
    for (final (i, type) in TypeChart.types.indexed)
      (
        index: i,
        coverage: (
          type: type,
          weak: team.where((t) => chart.multiplier(type, t) > 1).length,
          resist: team.where((t) {
            final m = chart.multiplier(type, t);
            return m > 0 && m < 1;
          }).length,
          immune: team.where((t) => chart.multiplier(type, t) == 0).length,
        ),
      ),
  ];
  // Explicit tie-break: List.sort isn't guaranteed to be stable.
  coverage.sort(
    (a, b) => a.coverage.weak != b.coverage.weak
        ? b.coverage.weak.compareTo(a.coverage.weak)
        : a.index.compareTo(b.index),
  );
  return [for (final c in coverage) c.coverage];
}

/// [theirTypes] (their Pokémon's types, as likely attacking types) against
/// [mine]: for each type, your Pokémon it hits super-effectively. Strongest
/// hit first, then most Pokémon hit; types that hit nobody are left out.
List<TypeThreat> threats(
  TypeChart chart,
  List<String> theirTypes,
  List<TypedMember> mine,
) {
  final rows = [
    for (final (i, type) in theirTypes.toSet().indexed)
      (
        index: i,
        threat: (
          type: type,
          hits: [
            for (final member in mine)
              if (chart.multiplier(type, member.types) case final m when m > 1)
                (name: member.name, multiplier: m),
          ]..sort((a, b) => b.multiplier.compareTo(a.multiplier)),
        ),
      ),
  ]..removeWhere((r) => r.threat.hits.isEmpty);
  double strongest(TypeThreat t) => t.hits.first.multiplier;
  rows.sort((a, b) {
    final byPower = strongest(b.threat).compareTo(strongest(a.threat));
    if (byPower != 0) return byPower;
    final byCount = b.threat.hits.length.compareTo(a.threat.hits.length);
    return byCount != 0 ? byCount : a.index.compareTo(b.index);
  });
  return [for (final r in rows) r.threat];
}
