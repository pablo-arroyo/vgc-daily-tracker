import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/models/stat.dart';
import '../../../domain/models/stat_spread.dart';
import '../../../domain/models/team.dart';
import '../../../utils/command.dart';
import '../../core/matchup_notes_dialog.dart';
import '../../core/pokemon_avatar.dart';
import '../../core/type_badge.dart';
import '../view_models/team_detail_view_model.dart';

/// A team's members with their builds and stats, and its Speed order.
class TeamDetailScreen extends StatelessWidget {
  const TeamDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<TeamDetailViewModel>();
    // Its own messenger, so "Notes saved" shows on this screen.
    return ScaffoldMessenger(
      child: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) => Scaffold(
          appBar: AppBar(title: Text(viewModel.name)),
          body: switch (viewModel) {
            TeamDetailViewModel(missing: true) => const Center(
              child: Text('This team no longer exists.'),
            ),
            TeamDetailViewModel(load: Command(error: true)) =>
              const _LoadError(),
            TeamDetailViewModel(load: Command(completed: true)) =>
              const _TeamDetail(),
            _ => const Center(child: CircularProgressIndicator()),
          },
        ),
      ),
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError();

  @override
  Widget build(BuildContext context) {
    final load = context.read<TeamDetailViewModel>().load;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Couldn't load this team."),
          const SizedBox(height: 12),
          FilledButton(onPressed: load.execute, child: const Text('Retry')),
        ],
      ),
    );
  }
}

class _TeamDetail extends StatelessWidget {
  const _TeamDetail();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<TeamDetailViewModel>();
    final members = viewModel.members;
    final speedOrder = viewModel.speedOrder;
    return CustomScrollView(
      slivers: [
        const SliverPadding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
          sliver: SliverToBoxAdapter(child: _NotesCard()),
        ),
        const SliverPadding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
          sliver: SliverToBoxAdapter(child: _MatchupNotesCard()),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          sliver: SliverList.builder(
            itemCount: members.length,
            itemBuilder: (context, index) =>
                _MemberCard(member: members[index]),
          ),
        ),
        const SliverPadding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
          sliver: SliverToBoxAdapter(child: _WeaknessesCard()),
        ),
        if (!viewModel.hasSets)
          const SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Import this team from Showdown to see its sets, stats and '
                'Speed order.',
              ),
            ),
          )
        else ...[
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Speed order',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 16),
            sliver: SliverList.builder(
              itemCount: speedOrder.length,
              itemBuilder: (context, index) =>
                  _SpeedTierTile(tier: speedOrder[index]),
            ),
          ),
        ],
      ],
    );
  }
}

/// The team's notes, edited in place. Built once the team has loaded, so
/// the field starts from the saved notes.
class _NotesCard extends StatefulWidget {
  const _NotesCard();

  @override
  State<_NotesCard> createState() => _NotesCardState();
}

class _NotesCardState extends State<_NotesCard> {
  late final _viewModel = context.read<TeamDetailViewModel>();
  late final _notes = TextEditingController(text: _viewModel.notes);

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _notes,
              decoration: const InputDecoration(
                labelText: 'Notes',
                hintText: 'Scouting notes, threats, your game plan…',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
              minLines: 3,
              maxLines: 8,
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: ListenableBuilder(
                listenable: _viewModel.saveNotes,
                builder: (context, _) => FilledButton(
                  onPressed: _viewModel.saveNotes.running ? null : _save,
                  child: const Text('Save notes'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    final saveNotes = _viewModel.saveNotes;
    final messenger = ScaffoldMessenger.of(context);
    await saveNotes.execute(_notes.text);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            saveNotes.completed
                ? 'Notes saved'
                : "Couldn't save the notes. Try again.",
          ),
        ),
      );
  }
}

/// Matchup notes against each team on the other side; tap one to edit.
class _MatchupNotesCard extends StatelessWidget {
  const _MatchupNotesCard();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<TeamDetailViewModel>();
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) {
            final matchups = viewModel.matchups;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Matchup notes',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                if (matchups.isEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Text(
                      viewModel.side == TeamSide.mine
                          ? 'Save an opponent team to keep matchup notes '
                                'against it.'
                          : 'Save a team of yours to keep matchup notes '
                                'against it.',
                    ),
                  ),
                // Few teams per side, so a plain column is fine here.
                for (final matchup in matchups)
                  ListTile(
                    title: Text(matchup.teamName),
                    subtitle: Text(
                      matchup.notes.isEmpty ? 'No notes yet' : matchup.notes,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: const Icon(Icons.edit_outlined),
                    onTap: () => _edit(context, matchup),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _edit(BuildContext context, MatchupView matchup) async {
    final save = context.read<TeamDetailViewModel>().saveMatchupNotes;
    final messenger = ScaffoldMessenger.of(context);
    final notes = await showDialog<String>(
      context: context,
      builder: (context) =>
          MatchupNotesDialog(title: matchup.title, initial: matchup.notes),
    );
    if (notes == null) return;

    await save.execute((teamId: matchup.teamId, notes: notes));
    if (save.error) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text("Couldn't save the matchup notes. Try again."),
          ),
        );
    }
  }
}

/// Attacking types that hit this team super-effectively, from its
/// members' battle-form types.
class _WeaknessesCard extends StatelessWidget {
  const _WeaknessesCard();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<TeamDetailViewModel>();
    final textTheme = Theme.of(context).textTheme;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Weaknesses', style: textTheme.titleMedium),
            const SizedBox(height: 8),
            if (viewModel.typesUnavailable)
              const Text("Couldn't load the type chart. Check your connection.")
            else ...[
              // At most 18 rows, one per type, so a plain column.
              for (final row in viewModel.weaknessRows)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    children: [
                      TypeBadge(type: row.type),
                      const SizedBox(width: 8),
                      Expanded(child: Text(row.label)),
                    ],
                  ),
                ),
              const SizedBox(height: 6),
              Text(
                "Types only: abilities like Levitate aren't counted.",
                style: textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MemberCard extends StatelessWidget {
  const _MemberCard({required this.member});

  final TeamMemberView member;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final set = member.set;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                PokemonAvatar(spriteUrl: member.spriteUrl, name: member.name),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(member.name, style: textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 6,
                        children: [
                          for (final type in member.types)
                            TypeBadge(type: type),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (set != null) ...[
              const SizedBox(height: 8),
              if (set.item case final item?)
                _LabelledLine(label: 'Item', value: item),
              if (member.ability case final ability?)
                _LabelledLine(label: 'Ability', value: ability),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final move in set.moves) Chip(label: Text(move)),
                ],
              ),
            ],
            if (member.stats case final stats?) ...[
              const SizedBox(height: 8),
              _StatsRow(stats: stats),
            ],
          ],
        ),
      ),
    );
  }
}

class _LabelledLine extends StatelessWidget {
  const _LabelledLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Row(
        // No fixed label width: it would wrap at larger text sizes.
        children: [
          Text(label, style: textTheme.labelMedium),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

/// The six stats in a row, each label over its value.
class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.stats});

  final StatSpread stats;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        for (final stat in Stat.values)
          Expanded(
            // Read as "Speed 178", not "Spe", "178".
            child: Semantics(
              label: '${stat.fullName} ${stats.of(stat)}',
              container: true,
              excludeSemantics: true,
              child: Column(
                children: [
                  Text(stat.label, style: textTheme.labelSmall),
                  Text('${stats.of(stat)}', style: textTheme.titleSmall),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _SpeedTierTile extends StatelessWidget {
  const _SpeedTierTile({required this.tier});

  final SpeedTier tier;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(tier.name),
      trailing: Text(
        '${tier.speed}',
        key: const ValueKey('speed'),
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
