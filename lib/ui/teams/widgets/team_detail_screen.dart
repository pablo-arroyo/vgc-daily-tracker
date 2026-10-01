import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/models/stat.dart';
import '../../../domain/models/stat_spread.dart';
import '../../../utils/command.dart';
import '../../core/pokemon_avatar.dart';
import '../../core/type_badge.dart';
import '../view_models/team_detail_view_model.dart';

/// A team's members with their builds and stats, and its Speed order.
class TeamDetailScreen extends StatelessWidget {
  const TeamDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<TeamDetailViewModel>();
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) => Scaffold(
        appBar: AppBar(title: Text(viewModel.name)),
        body: switch (viewModel) {
          TeamDetailViewModel(missing: true) => const Center(
            child: Text('This team no longer exists.'),
          ),
          TeamDetailViewModel(load: Command(error: true)) => const _LoadError(),
          TeamDetailViewModel(load: Command(completed: true)) =>
            const _TeamDetail(),
          _ => const Center(child: CircularProgressIndicator()),
        },
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
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          sliver: SliverList.builder(
            itemCount: members.length,
            itemBuilder: (context, index) =>
                _MemberCard(member: members[index]),
          ),
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
