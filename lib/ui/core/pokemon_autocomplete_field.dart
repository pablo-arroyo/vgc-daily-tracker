import 'package:flutter/material.dart';

import '../../domain/models/pokemon_ref.dart';
import '../../utils/result.dart';

/// A text field that only yields real Pokémon: it suggests matches from
/// [search] and reports a [PokemonRef] only when one is picked, so typos
/// can't be stored.
///
/// It gets [search] from the screen's view model rather than a repository,
/// so it stays a plain, reusable widget.
class PokemonAutocompleteField extends StatefulWidget {
  const PokemonAutocompleteField({
    required this.label,
    required this.search,
    required this.onChanged,
    this.initialValue,
    super.key,
  });

  final String label;

  /// A failed search (e.g. offline before the name list ever loaded) shows
  /// a message instead of an unexplained empty list.
  final Future<Result<List<PokemonRef>>> Function(String query) search;
  final ValueChanged<PokemonRef?> onChanged;

  /// Shown at start and treated as already picked, e.g. when editing a team.
  final PokemonRef? initialValue;

  @override
  State<PokemonAutocompleteField> createState() =>
      _PokemonAutocompleteFieldState();
}

class _PokemonAutocompleteFieldState extends State<PokemonAutocompleteField> {
  late PokemonRef? _picked = widget.initialValue;
  bool _showError = false;

  /// The last search failed. Each keystroke searches again, so this clears
  /// by itself once PokéAPI is reachable.
  bool _searchFailed = false;

  Future<List<PokemonRef>> _options(TextEditingValue value) async {
    final result = await widget.search(value.text);
    final failed = result is Failure;
    if (failed != _searchFailed && mounted) {
      setState(() => _searchFailed = failed);
    }
    return switch (result) {
      Ok(:final value) => value,
      Failure() => const [],
    };
  }

  void _pick(PokemonRef ref) {
    setState(() {
      _picked = ref;
      _showError = false;
    });
    widget.onChanged(ref);
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<PokemonRef>(
      displayStringForOption: (ref) => ref.displayName,
      initialValue: TextEditingValue(
        text: widget.initialValue?.displayName ?? '',
      ),
      optionsBuilder: _options,
      onSelected: _pick,
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) =>
          TextField(
            controller: controller,
            focusNode: focusNode,
            decoration: InputDecoration(
              labelText: widget.label,
              errorText: _showError ? 'Pick a Pokémon from the list' : null,
              helperText: _searchFailed
                  ? "Can't reach PokéAPI. Keep typing to try again."
                  : null,
            ),
            onChanged: (text) {
              if (_picked != null && text != _picked!.displayName) {
                _picked = null;
                widget.onChanged(null);
              }
            },
            onSubmitted: (text) {
              // Enter picks the highlighted suggestion, if there is one.
              onFieldSubmitted();
              if (_picked == null && text.trim().isNotEmpty) {
                setState(() => _showError = true);
              }
            },
          ),
    );
  }
}
