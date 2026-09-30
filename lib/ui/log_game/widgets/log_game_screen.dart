import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/models/game_log.dart';
import '../../../domain/models/mistake_category.dart';
import '../../../domain/models/pokemon_ref.dart';
import '../../../domain/models/team.dart';
import '../../../utils/result.dart';
import '../../core/pokemon_autocomplete_field.dart';
import '../../core/pokemon_chip.dart';
import '../view_models/log_game_view_model.dart';

/// The Log Game tab: log one game, as in the original tracker.
class LogGameScreen extends StatefulWidget {
  const LogGameScreen({super.key});

  @override
  State<LogGameScreen> createState() => _LogGameScreenState();
}

class _LogGameScreenState extends State<LogGameScreen> {
  /// Bumped after each saved game: the text fields and dropdowns keep their
  /// own state, so a new key rebuilds them from the (reset) view model.
  int _formGeneration = 0;

  @override
  Widget build(BuildContext context) {
    // Its own messenger: snackbars then show in this Scaffold, above the
    // sticky Save bar. The shell's Scaffold would put them right over it.
    return ScaffoldMessenger(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            key: ValueKey(_formGeneration),
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              _SectionLabel('Result'),
              _ResultPicker(),
              SizedBox(height: 16),
              _TeamPicker(),
              _YourPicks(),
              _OpponentSection(),
              Divider(height: 32),
              _MistakePicker(),
              SizedBox(height: 12),
              _NotesField(),
            ],
          ),
        ),
        // Sticky, like the team editor's Save.
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _SaveGameButton(
              onSaved: () => setState(() => _formGeneration++),
            ),
          ),
        ),
      ),
    );
  }
}

class _MistakePicker extends StatelessWidget {
  const _MistakePicker();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<LogGameViewModel>();
    return DropdownButtonFormField<MistakeCategory?>(
      initialValue: viewModel.mistake,
      isExpanded: true,
      decoration: const InputDecoration(labelText: 'What decided this game?'),
      items: [
        const DropdownMenuItem(child: Text('-- select --')),
        for (final category in MistakeCategory.values)
          DropdownMenuItem(value: category, child: Text(category.label)),
      ],
      onChanged: viewModel.setMistake,
    );
  }
}

class _NotesField extends StatelessWidget {
  const _NotesField();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<LogGameViewModel>();
    return TextField(
      decoration: const InputDecoration(
        labelText: 'Notes',
        hintText: 'One or two sentences is enough',
      ),
      minLines: 2,
      maxLines: 4,
      onChanged: viewModel.setNotes,
    );
  }
}

class _SaveGameButton extends StatelessWidget {
  const _SaveGameButton({required this.onSaved});

  /// Called after a game is logged, so the screen can clear its fields.
  final VoidCallback onSaved;

  @override
  Widget build(BuildContext context) {
    final save = context.read<LogGameViewModel>().save;
    return ListenableBuilder(
      listenable: save,
      builder: (context, _) => FilledButton(
        onPressed: save.running ? null : () => _save(context),
        child: const Text('Save game'),
      ),
    );
  }

  Future<void> _save(BuildContext context) async {
    final save = context.read<LogGameViewModel>().save;
    final messenger = ScaffoldMessenger.of(context);
    await save.execute();
    final message = switch (save.result) {
      Ok() => 'Game logged ✓',
      Failure(error: LogGameValidationError(:final message)) => message,
      _ => "Couldn't save the game. Try again.",
    };
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
    if (save.completed) onSaved();
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 6),
      child: Text(text, style: Theme.of(context).textTheme.labelLarge),
    );
  }
}

class _Hint extends StatelessWidget {
  const _Hint(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall
            ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
    );
  }
}

class _ResultPicker extends StatelessWidget {
  const _ResultPicker();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<LogGameViewModel>();
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) => SegmentedButton<GameResult>(
        emptySelectionAllowed: true,
        segments: const [
          ButtonSegment(value: GameResult.win, label: Text('Win')),
          ButtonSegment(value: GameResult.loss, label: Text('Loss')),
        ],
        selected: {?viewModel.result},
        onSelectionChanged: (selection) {
          if (selection.isNotEmpty) viewModel.setResult(selection.single);
        },
      ),
    );
  }
}

class _TeamPicker extends StatelessWidget {
  const _TeamPicker();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<LogGameViewModel>();
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) => DropdownButtonFormField<Team?>(
        initialValue: viewModel.selectedTeam,
        decoration: const InputDecoration(labelText: 'Your team used'),
        items: [
          const DropdownMenuItem(child: Text('No saved team')),
          for (final team in viewModel.teams)
            DropdownMenuItem(value: team, child: Text(team.name)),
        ],
        onChanged: viewModel.selectTeam,
      ),
    );
  }
}

/// Your brought 4 and leads 2, once a team is picked.
class _YourPicks extends StatelessWidget {
  const _YourPicks();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<LogGameViewModel>();
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final team = viewModel.selectedTeam;
        if (team == null) return const SizedBox.shrink();
        final brought = viewModel.brought;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionLabel('Brought (pick 4 of 6)'),
            _Hint('${brought.length} / 4 selected'),
            _ChipGroup(
              key: const ValueKey('your-brought'),
              pokemon: team.pokemon,
              roleOf: (p) => brought.contains(p)
                  ? PokemonChipRole.brought
                  : PokemonChipRole.none,
              onToggle: viewModel.toggleBrought,
            ),
            const _SectionLabel('Leads (pick 2 of the 4 brought)'),
            _Hint(
              brought.length < 4
                  ? 'Select 4 brought first'
                  : '${viewModel.leads.length} / 2 selected',
            ),
            if (brought.length == 4)
              _ChipGroup(
                key: const ValueKey('your-leads'),
                pokemon: brought,
                roleOf: (p) => viewModel.leads.contains(p)
                    ? PokemonChipRole.lead
                    : PokemonChipRole.none,
                onToggle: viewModel.toggleLead,
              ),
          ],
        );
      },
    );
  }
}

/// Their team from Team Preview, then who they brought and led, as far as
/// you remember.
class _OpponentSection extends StatelessWidget {
  const _OpponentSection();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<LogGameViewModel>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(height: 32),
        const _SectionLabel("Opponent's team"),
        const _Hint(
          'From Team Preview — fill in whichever you remember, rest optional',
        ),
        for (var i = 0; i < 6; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: PokemonAutocompleteField(
              label: 'Opp. Pokémon ${i + 1}',
              search: viewModel.search,
              onChanged: (pokemon) => viewModel.setOpponentSlot(i, pokemon),
            ),
          ),
        const _OpponentPicks(),
      ],
    );
  }
}

class _OpponentPicks extends StatelessWidget {
  const _OpponentPicks();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<LogGameViewModel>();
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final team = viewModel.opponentTeam;
        if (team.isEmpty) return const SizedBox.shrink();
        final brought = viewModel.opponentBrought;
        final leads = viewModel.opponentLeads;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionLabel('Opponent brought (up to 4)'),
            _Hint('${brought.length} selected (up to 4)'),
            _ChipGroup(
              key: const ValueKey('opponent-brought'),
              pokemon: team,
              roleOf: (p) => brought.contains(p)
                  ? PokemonChipRole.opponentBrought
                  : PokemonChipRole.none,
              onToggle: viewModel.toggleOpponentBrought,
            ),
            const _SectionLabel('Opponent leads (up to 2)'),
            _Hint(
              brought.isEmpty
                  ? 'Pick from brought above'
                  : '${leads.length} selected (up to 2)',
            ),
            if (brought.isNotEmpty)
              _ChipGroup(
                key: const ValueKey('opponent-leads'),
                pokemon: brought,
                roleOf: (p) => leads.contains(p)
                    ? PokemonChipRole.opponentLead
                    : PokemonChipRole.none,
                onToggle: viewModel.toggleOpponentLead,
              ),
          ],
        );
      },
    );
  }
}

class _ChipGroup extends StatelessWidget {
  const _ChipGroup({
    required this.pokemon,
    required this.roleOf,
    required this.onToggle,
    super.key,
  });

  final List<PokemonRef> pokemon;
  final PokemonChipRole Function(PokemonRef) roleOf;

  /// Toggles a Pokémon; returns why it was refused, shown as a snackbar.
  final String? Function(PokemonRef) onToggle;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final p in pokemon)
          PokemonChip(
            label: p.displayName,
            role: roleOf(p),
            onTap: () {
              final refusal = onToggle(p);
              if (refusal != null) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text(refusal)));
              }
            },
          ),
      ],
    );
  }
}
