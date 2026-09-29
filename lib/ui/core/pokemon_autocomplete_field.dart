import 'package:flutter/material.dart';

import '../../domain/models/pokemon_ref.dart';

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
    super.key,
  });

  final String label;
  final Future<List<PokemonRef>> Function(String query) search;
  final ValueChanged<PokemonRef?> onChanged;

  @override
  State<PokemonAutocompleteField> createState() =>
      _PokemonAutocompleteFieldState();
}

class _PokemonAutocompleteFieldState extends State<PokemonAutocompleteField> {
  PokemonRef? _picked;
  bool _showError = false;

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
      optionsBuilder: (value) => widget.search(value.text),
      onSelected: _pick,
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) =>
          TextField(
            controller: controller,
            focusNode: focusNode,
            decoration: InputDecoration(
              labelText: widget.label,
              errorText: _showError ? 'Pick a Pokémon from the list' : null,
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
