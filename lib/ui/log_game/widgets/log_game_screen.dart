import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/models/game_log.dart';
import '../../../domain/models/mistake_category.dart';
import '../../../domain/models/pokemon_ref.dart';
import '../../../domain/models/team.dart';
import '../../../utils/result.dart';
import '../../core/matchup_notes_dialog.dart';
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
    final viewModel = context.read<LogGameViewModel>();
    final save = viewModel.save;
    final messenger = ScaffoldMessenger.of(context);
    await save.execute();
    final message = switch (save.result) {
      Ok() => 'Game logged ✓',
      Failure(error: LogGameValidationError(:final message)) => message,
      _ => "Couldn't save the game. Try again.",
    };
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          action: save.completed && viewModel.canAddLastGameToNotes
              ? SnackBarAction(
                  label: viewModel.addToNotesLabel,
                  onPressed: () => _addToNotes(viewModel, messenger),
                )
              : null,
        ),
      );
    if (save.completed) onSaved();
  }

  /// Runs after the form has reset, so it uses what was captured at save.
  Future<void> _addToNotes(
    LogGameViewModel viewModel,
    ScaffoldMessengerState messenger,
  ) async {
    final add = viewModel.addLastGameToNotes;
    await add.execute();
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(switch (add.result) {
            Ok(value: final target) => 'Added to $target',
            Failure(error: LogGameValidationError(:final message)) => message,
            _ => "Couldn't add the notes. Try again.",
          }),
        ),
      );
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
        // Long team names shorten instead of overflowing at large text.
        isExpanded: true,
        items: [
          const DropdownMenuItem(child: Text('No saved team')),
          for (final team in viewModel.teams)
            DropdownMenuItem(
              value: team,
              child: Text(team.name, overflow: TextOverflow.ellipsis),
            ),
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
        const _OpponentTeamPicker(),
        const _GamePlanCard(),
        ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) {
            // Keyed by the picked team: the fields keep their own text, so
            // a new pick rebuilds them with its Pokémon.
            final picked = viewModel.selectedOpponentTeam?.id;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < 6; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: PokemonAutocompleteField(
                      key: ValueKey('opponent-$picked-$i'),
                      label: 'Opp. Pokémon ${i + 1}',
                      search: viewModel.search,
                      initialValue: viewModel.opponentSlots[i],
                      onChanged: (pokemon) =>
                          viewModel.setOpponentSlot(i, pokemon),
                    ),
                  ),
              ],
            );
          },
        ),
        const _OpponentPicks(),
      ],
    );
  }
}

/// "Their team": a saved opponent team fills their 6 slots. Shown only
/// when there are some.
class _OpponentTeamPicker extends StatelessWidget {
  const _OpponentTeamPicker();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<LogGameViewModel>();
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        if (viewModel.opponentTeams.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: DropdownButtonFormField<Team?>(
            initialValue: viewModel.selectedOpponentTeam,
            decoration: const InputDecoration(labelText: 'Their team'),
            isExpanded: true,
            items: [
              const DropdownMenuItem(child: Text('Not a saved team')),
              for (final team in viewModel.opponentTeams)
                DropdownMenuItem(
                  value: team,
                  child: Text(team.name, overflow: TextOverflow.ellipsis),
                ),
            ],
            onChanged: viewModel.selectOpponentTeam,
          ),
        );
      },
    );
  }
}

/// Their team's notes and your plan for the matchup, shown once their team
/// is picked, so the plan is in front of you before the battle.
class _GamePlanCard extends StatelessWidget {
  const _GamePlanCard();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<LogGameViewModel>();
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        if (!viewModel.showGamePlan) return const SizedBox.shrink();
        final textTheme = Theme.of(context).textTheme;
        final theirNotes = viewModel.opponentTeamNotes;
        final title = viewModel.matchupTitle;
        final plan = viewModel.matchupNotes;
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Game plan', style: textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  theirNotes.isEmpty
                      ? 'No notes on their team yet.'
                      : theirNotes,
                ),
                const Divider(height: 20),
                if (title == null || plan == null)
                  const Text(
                    'Pick your team to see your plan for this matchup.',
                  )
                else
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title, style: textTheme.labelLarge),
                            const SizedBox(height: 2),
                            Text(
                              plan.isEmpty
                                  ? 'No plan yet for this matchup.'
                                  : plan,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'Edit the matchup plan',
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () => _edit(context, title, plan),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _edit(BuildContext context, String title, String plan) async {
    final save = context.read<LogGameViewModel>().saveMatchupNotes;
    final messenger = ScaffoldMessenger.of(context);
    final notes = await showDialog<String>(
      context: context,
      builder: (context) => MatchupNotesDialog(title: title, initial: plan),
    );
    if (notes == null) return;

    await save.execute(notes);
    if (save.error) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text("Couldn't save the matchup plan. Try again."),
          ),
        );
    }
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
