import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../domain/models/pokemon_ref.dart';
import '../../../domain/models/team.dart';
import '../../../routing/routes.dart';
import '../../core/pokemon_avatar.dart';
import '../view_models/teams_view_model.dart';

/// The Teams tab: the player's saved teams.
class TeamsScreen extends StatelessWidget {
  const TeamsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<TeamsViewModel>();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add team',
        onPressed: () => context.push(Routes.newTeam),
        child: const Icon(Icons.add),
      ),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          if (!viewModel.loaded) {
            return const Center(child: CircularProgressIndicator());
          }
          if (viewModel.teams.isEmpty) {
            return const Center(child: Text('No teams saved yet.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: viewModel.teams.length,
            itemBuilder: (context, index) =>
                _TeamCard(team: viewModel.teams[index]),
          );
        },
      ),
    );
  }
}

class _TeamCard extends StatelessWidget {
  const _TeamCard({required this.team});

  final Team team;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    team.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  tooltip: 'Edit ${team.name}',
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => context.push(Routes.editTeam(team.id)),
                ),
                IconButton(
                  tooltip: 'Delete ${team.name}',
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _confirmAndDelete(context),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final pokemon in team.pokemon)
                  _TeamMember(pokemon: pokemon),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmAndDelete(BuildContext context) async {
    final viewModel = context.read<TeamsViewModel>();
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete ${team.name}?'),
        content: const Text('Games logged with it are kept.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    await viewModel.deleteTeam.execute(team);
    messenger.showSnackBar(
      viewModel.deleteTeam.completed
          ? SnackBar(
              content: Text('Deleted ${team.name}'),
              action: SnackBarAction(
                label: 'Undo',
                onPressed: viewModel.undoDelete.execute,
              ),
            )
          : SnackBar(content: Text("Couldn't delete ${team.name}. Try again.")),
    );
  }
}

class _TeamMember extends StatelessWidget {
  const _TeamMember({required this.pokemon});

  final PokemonRef pokemon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 76,
      child: Column(
        children: [
          PokemonAvatar(
            spriteUrl: pokemon.spriteUrl,
            name: pokemon.displayName,
          ),
          Text(
            pokemon.displayName,
            style: Theme.of(context).textTheme.labelSmall,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
