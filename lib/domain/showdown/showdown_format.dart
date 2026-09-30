import 'package:freezed_annotation/freezed_annotation.dart';

import '../../utils/result.dart';
import '../models/nature.dart';
import '../models/pokemon_set.dart';
import '../models/stat.dart';
import '../models/stat_spread.dart';

part 'showdown_format.freezed.dart';

/// A problem found in a paste, on its 1-based [line].
@freezed
abstract class ShowdownIssue with _$ShowdownIssue {
  const factory ShowdownIssue({required int line, required String message}) =
      _ShowdownIssue;
}

/// A paste that couldn't be read, with every problem found in it.
class ShowdownParseException implements Exception {
  const ShowdownParseException(this.issues);

  final List<ShowdownIssue> issues;

  @override
  String toString() =>
      issues.map((i) => 'Line ${i.line}: ${i.message}').join('\n');
}

/// Reads and writes Pokémon Showdown's team text format.
abstract final class ShowdownFormat {
  static const _maxEvs = 252;
  static const _maxEvTotal = 510;
  static const _maxIvs = 31;
  static const _maxMoves = 4;

  /// Showdown lines this app has no use for.
  static const _ignoredKeys = {
    'shiny',
    'tera type',
    'happiness',
    'gigantamax',
    'dynamax level',
    'hidden power',
    'pokeball',
  };

  /// All the sets in [paste], or every problem found in it.
  static Result<List<PokemonSet>> parse(String paste) {
    final issues = <ShowdownIssue>[];
    final sets = [
      for (final block in _blocks(paste)) _parseSet(block, issues.add),
    ];
    if (sets.isEmpty) {
      issues.add(const ShowdownIssue(line: 1, message: 'No Pokémon found'));
    }
    return issues.isEmpty
        ? Result.ok(sets)
        : Result.failure(ShowdownParseException(issues));
  }

  /// [sets] as a paste, in the order Showdown writes each line.
  static String export(List<PokemonSet> sets) =>
      sets.map(_exportSet).join('\n');

  /// Groups the non-blank lines of [paste] into one list per set.
  static List<List<_Line>> _blocks(String paste) {
    final blocks = <List<_Line>>[];
    var current = <_Line>[];
    final lines = paste.split(RegExp(r'\r?\n'));
    for (var i = 0; i < lines.length; i++) {
      final text = lines[i].trim();
      if (text.isNotEmpty) {
        current.add((number: i + 1, text: text));
      } else if (current.isNotEmpty) {
        blocks.add(current);
        current = [];
      }
    }
    if (current.isNotEmpty) blocks.add(current);
    return blocks;
  }

  static PokemonSet _parseSet(
    List<_Line> block,
    void Function(ShowdownIssue) report,
  ) {
    var set = _parseHeader(block.first.text);
    for (final line in block.skip(1)) {
      void issue(String message) =>
          report(ShowdownIssue(line: line.number, message: message));
      final text = line.text;
      final colon = text.indexOf(':');
      final key = colon < 0 ? '' : text.substring(0, colon).toLowerCase();
      final value = colon < 0 ? '' : text.substring(colon + 1).trim();

      if (text.startsWith('-')) {
        if (set.moves.length == _maxMoves) {
          issue('More than $_maxMoves moves');
        } else {
          set = set.copyWith(moves: [...set.moves, text.substring(1).trim()]);
        }
      } else if (key == 'ability') {
        final parts = value.split(RegExp(r'\s*(?:→|->)\s*'));
        set = set.copyWith(
          ability: parts.first,
          megaAbility: parts.length > 1 ? parts[1] : null,
        );
      } else if (key == 'level') {
        final level = int.tryParse(value);
        if (level == null || level < 1 || level > 100) {
          issue('Level $value (must be 1-100)');
        } else {
          set = set.copyWith(level: level);
        }
      } else if (key == 'evs') {
        final evs = _parseSpread(
          value,
          const StatSpread(),
          'EVs',
          _maxEvs,
          issue,
        );
        if (evs.total > _maxEvTotal) {
          issue('EVs add up to ${evs.total} (max $_maxEvTotal)');
        }
        set = set.copyWith(evs: evs);
      } else if (key == 'ivs') {
        set = set.copyWith(
          ivs: _parseSpread(
            value,
            StatSpread.perfectIvs,
            'IVs',
            _maxIvs,
            issue,
          ),
        );
      } else if (RegExp(r'\snature$', caseSensitive: false).hasMatch(text)) {
        final name = text.substring(0, text.length - 'nature'.length).trim();
        final nature = Nature.byName(name);
        if (nature == null) {
          issue('Unknown nature "$name"');
        } else {
          set = set.copyWith(nature: nature);
        }
      } else if (!_ignoredKeys.contains(key)) {
        issue('Unrecognised line "$text"');
      }
    }
    return set;
  }

  /// `Nickname (Species) (G) @ Item`, where all but the species is optional.
  static PokemonSet _parseHeader(String header) {
    final at = header.indexOf(' @ ');
    var name = at < 0 ? header : header.substring(0, at).trim();
    final item = at < 0 ? null : header.substring(at + 3).trim();

    String? gender;
    final genderMatch = RegExp(r'\s*\(([MF])\)$').firstMatch(name);
    if (genderMatch != null) {
      gender = genderMatch.group(1);
      name = name.substring(0, genderMatch.start);
    }

    final nicknamed = RegExp(r'^(.*\S)\s*\(([^()]+)\)$').firstMatch(name);
    return PokemonSet(
      species: nicknamed?.group(2)!.trim() ?? name,
      nickname: nicknamed?.group(1),
      gender: gender,
      item: item,
    );
  }

  /// `252 HP / 4 SpD` on top of [base]; each value may be at most [max].
  static StatSpread _parseSpread(
    String value,
    StatSpread base,
    String kind,
    int max,
    void Function(String) issue,
  ) {
    var spread = base;
    for (final part in value.split('/').map((p) => p.trim())) {
      final match = RegExp(r'^(\d+)\s+(\w+)$').firstMatch(part);
      final stat = match == null ? null : _statNamed(match.group(2)!);
      if (stat == null) {
        issue('Unreadable stat "$part"');
        continue;
      }
      final amount = int.parse(match!.group(1)!);
      if (amount > max) {
        issue('$amount ${stat.label} $kind (max $max)');
      } else {
        spread = spread.withStat(stat, amount);
      }
    }
    return spread;
  }

  static Stat? _statNamed(String label) => Stat.values
      .where((s) => s.label.toLowerCase() == label.toLowerCase())
      .firstOrNull;

  static String _exportSet(PokemonSet set) {
    final buffer = StringBuffer(
      set.nickname == null ? set.species : '${set.nickname} (${set.species})',
    );
    if (set.gender != null) buffer.write(' (${set.gender})');
    if (set.item != null) buffer.write(' @ ${set.item}');
    buffer.writeln();

    if (set.ability != null) {
      buffer.write('Ability: ${set.ability}');
      if (set.megaAbility != null) buffer.write(' → ${set.megaAbility}');
      buffer.writeln();
    }
    buffer.writeln('Level: ${set.level}');
    final evs = _spreadText(set.evs, (value) => value > 0);
    if (evs.isNotEmpty) buffer.writeln('EVs: $evs');
    buffer.writeln('${set.nature.label} Nature');
    final ivs = _spreadText(set.ivs, (value) => value < _maxIvs);
    if (ivs.isNotEmpty) buffer.writeln('IVs: $ivs');
    for (final move in set.moves) {
      buffer.writeln('- $move');
    }
    return buffer.toString();
  }

  /// `4 HP / 252 Atk`, with only the stats [listed] keeps.
  static String _spreadText(StatSpread spread, bool Function(int) listed) =>
      Stat.values
          .where((stat) => listed(spread.of(stat)))
          .map((stat) => '${spread.of(stat)} ${stat.label}')
          .join(' / ');
}

typedef _Line = ({int number, String text});
