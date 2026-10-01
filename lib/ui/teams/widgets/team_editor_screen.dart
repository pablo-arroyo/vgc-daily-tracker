import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/models/team.dart';
import '../../../utils/result.dart';
import '../../core/pokemon_autocomplete_field.dart';
import '../view_models/team_editor_view_model.dart';

/// Create or edit a team: a name and six Pokémon picked by autocomplete.
class TeamEditorScreen extends StatelessWidget {
  const TeamEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<TeamEditorViewModel>();
    // The view model only notifies when the team finishes loading.
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final ready = viewModel.loaded && !viewModel.missing;
        return Scaffold(
          appBar: AppBar(
            title: Text(switch ((viewModel.isEditing, viewModel.side)) {
              (true, TeamSide.mine) => 'Edit team',
              (true, TeamSide.opponent) => 'Edit opponent team',
              (false, TeamSide.mine) => 'New team',
              (false, TeamSide.opponent) => 'New opponent team',
            }),
          ),
          body: switch (viewModel) {
            TeamEditorViewModel(loaded: false) => const Center(
              child: CircularProgressIndicator(),
            ),
            TeamEditorViewModel(missing: true) => const Center(
              child: Text('This team no longer exists.'),
            ),
            _ => const _TeamForm(),
          },
          // Sticky: always reachable, without scrolling past six fields.
          bottomNavigationBar: ready
              ? const SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: _SaveButton(),
                  ),
                )
              : null,
        );
      },
    );
  }
}

/// Built once the team is loaded, so its fields start from the saved values.
class _TeamForm extends StatefulWidget {
  const _TeamForm();

  @override
  State<_TeamForm> createState() => _TeamFormState();
}

class _TeamFormState extends State<_TeamForm> {
  late final _viewModel = context.read<TeamEditorViewModel>();
  late final _name = TextEditingController(text: _viewModel.name);

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // A fixed, short form, so build it all rather than lazily.
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _name,
            decoration: const InputDecoration(labelText: 'Team name'),
            onChanged: _viewModel.setName,
          ),
          for (var i = 0; i < 6; i++)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: PokemonAutocompleteField(
                label: 'Pokémon ${i + 1}',
                search: _viewModel.search,
                initialValue: _viewModel.slots[i],
                onChanged: (pokemon) => _viewModel.setSlot(i, pokemon),
              ),
            ),
        ],
      ),
    );
  }
}

/// Listens only to the save command, so saving rebuilds just this part.
class _SaveButton extends StatelessWidget {
  const _SaveButton();

  @override
  Widget build(BuildContext context) {
    final save = context.read<TeamEditorViewModel>().save;
    return ListenableBuilder(
      listenable: save,
      builder: (context, _) {
        final error = switch (save.result) {
          Failure(error: TeamValidationError(:final message)) => message,
          Failure() => "Couldn't save the team. Try again.",
          _ => null,
        };
        return Column(
          // As the Scaffold's bottom bar, a full-height Column would cover
          // the whole form.
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  error,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            FilledButton(
              onPressed: save.running ? null : () => _save(context),
              child: const Text('Save team'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _save(BuildContext context) async {
    final save = context.read<TeamEditorViewModel>().save;
    final navigator = Navigator.of(context);
    await save.execute();
    if (save.completed) navigator.pop();
  }
}
