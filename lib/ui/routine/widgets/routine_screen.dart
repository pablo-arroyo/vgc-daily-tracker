import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/models/routine.dart';
import '../view_models/routine_view_model.dart';

/// The Routine tab: before / during / after checklists, ticked per day.
class RoutineScreen extends StatelessWidget {
  const RoutineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<RoutineViewModel>();
    // Its own messenger, like every tab (snackbars stay in this tab).
    return ScaffoldMessenger(
      child: Scaffold(
        body: ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) {
            if (!viewModel.loaded) {
              return const Center(child: CircularProgressIndicator());
            }
            // Fixed, short content (12 items), so build it all.
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  for (final section in routine) _RoutineCard(section: section),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _RoutineCard extends StatelessWidget {
  const _RoutineCard({required this.section});

  final RoutineSection section;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<RoutineViewModel>();
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                section.title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            for (final item in section.items)
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                value: viewModel.isChecked(item.id),
                title: Text(item.text),
                onChanged: (_) => _toggle(context, item.id),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggle(BuildContext context, String itemId) async {
    final toggle = context.read<RoutineViewModel>().toggle;
    final messenger = ScaffoldMessenger.of(context);
    await toggle.execute(itemId);
    if (toggle.error) {
      messenger.showSnackBar(
        const SnackBar(content: Text("Couldn't save your tick. Try again.")),
      );
    }
  }
}
