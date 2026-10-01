import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/result.dart';
import '../view_models/team_import_view_model.dart';

/// Import a team by pasting Showdown's export text.
class TeamImportScreen extends StatelessWidget {
  const TeamImportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: _ImportAppBar(),
      body: _ImportForm(),
      // Sticky: reachable without scrolling past a long paste.
      bottomNavigationBar: SafeArea(
        child: Padding(padding: EdgeInsets.all(16), child: _ImportButton()),
      ),
    );
  }
}

class _ImportAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _ImportAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) =>
      AppBar(title: const Text('Import from Showdown'));
}

class _ImportForm extends StatelessWidget {
  const _ImportForm();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<TeamImportViewModel>();
    // A fixed, short form, so build it all rather than lazily.
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            decoration: const InputDecoration(labelText: 'Team name'),
            onChanged: viewModel.setName,
          ),
          const SizedBox(height: 12),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Showdown paste',
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
            ),
            style: const TextStyle(fontFamily: 'monospace'),
            minLines: 12,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            onChanged: viewModel.setPaste,
          ),
        ],
      ),
    );
  }
}

/// Listens only to the import command, so importing rebuilds just this part.
class _ImportButton extends StatelessWidget {
  const _ImportButton();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<TeamImportViewModel>();
    final import = viewModel.import;
    return ListenableBuilder(
      listenable: import,
      builder: (context, _) {
        final problems = switch (import.result) {
          Failure() when viewModel.problems.isEmpty => const [
            "Couldn't save the team. Try again.",
          ],
          _ => viewModel.problems,
        };
        final errorStyle = TextStyle(
          color: Theme.of(context).colorScheme.error,
        );
        return Column(
          // As the Scaffold's bottom bar, a full-height Column would cover
          // the whole form.
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final problem in problems)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(problem, style: errorStyle),
              ),
            if (problems.isNotEmpty) const SizedBox(height: 4),
            FilledButton(
              onPressed: import.running ? null : () => _import(context),
              child: const Text('Import team'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _import(BuildContext context) async {
    final import = context.read<TeamImportViewModel>().import;
    final navigator = Navigator.of(context);
    await import.execute();
    if (import.completed) navigator.pop();
  }
}
