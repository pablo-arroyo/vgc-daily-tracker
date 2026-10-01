import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/models/game_log.dart';
import '../../../utils/result.dart';
import '../../core/theme/app_theme.dart';
import '../view_models/progress_stats.dart';
import '../view_models/progress_view_model.dart';

/// The Progress tab: statistics from the game log, as in the original.
class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<ProgressViewModel>();
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        if (!viewModel.loaded) {
          return const Center(child: CircularProgressIndicator());
        }
        final stats = viewModel.stats;
        // Like every tab: its own messenger, so snackbars stay in this tab.
        return ScaffoldMessenger(
          child: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList.list(
                    children: [
                      _OverviewCard(stats: stats),
                      _FocusCard(stats: stats),
                      _RecordsCard(
                        title: 'Win rate by team',
                        records: stats.teamRecords,
                        emptyNote: 'No games logged with a saved team yet.',
                      ),
                      _RecordsCard(
                        title: 'Vs opponent teams',
                        records: stats.opponentTeamRecords,
                        emptyNote:
                            'Pick or save an opponent team when logging a game '
                            'to see your matchups.',
                      ),
                      _SetsCard(stats: stats),
                      _OpponentLeadsCard(stats: stats),
                      _MistakeBreakdownCard(stats: stats),
                    ],
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  sliver: _RecentGames(games: stats.recentGames),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// A titled card, like the original's `.card` sections.
class _Card extends StatelessWidget {
  const _Card({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}

String _percent(int? percent) => percent == null ? '–' : '$percent%';

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({required this.stats});

  final ProgressStats stats;

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'Overview',
      child: Column(
        children: [
          Row(
            children: [
              _StatBox(value: '${stats.totalGames}', label: 'games logged'),
              const SizedBox(width: 10),
              _StatBox(
                value: _percent(stats.winRatePercent),
                label: 'overall win rate',
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _StatBox(
                value: _percent(stats.winRateLast7DaysPercent),
                label: 'last 7 days',
              ),
              const SizedBox(width: 10),
              _StatBox(value: '${stats.dayStreak}', label: 'day streak'),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: DecoratedBox(
        key: const ValueKey('stat-box'),
        decoration: BoxDecoration(
          color: AppColors.of(context).accentSoft,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          // Read as one phrase: "overall win rate: 50%".
          child: Semantics(
            label: '$label: $value',
            container: true,
            excludeSemantics: true,
            child: Column(
              children: [
                Text(
                  value,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(label, style: theme.textTheme.labelSmall),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FocusCard extends StatelessWidget {
  const _FocusCard({required this.stats});

  final ProgressStats stats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final focus = stats.weeklyFocus;
    return _Card(
      title: "This week's focus",
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.of(context).accentSoft,
          borderRadius: BorderRadius.circular(10),
          border: Border(
            left: BorderSide(color: theme.colorScheme.primary, width: 4),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: focus != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      focus.mistake.label,
                      style: theme.textTheme.titleSmall,
                    ),
                    Text(
                      'Showed up in ${focus.count} of the '
                      '${focus.gamesWithMistakes} games with a mistake noted '
                      'in the last 14 days. Make it the one thing you watch '
                      'for this week.',
                    ),
                  ],
                )
              : Text(
                  stats.totalGames == 0
                      ? 'Log a few games to see your most common mistake here.'
                      : 'No repeated mistake pattern yet in the last two '
                            'weeks — keep logging.',
                ),
        ),
      ),
    );
  }
}

class _EmptyNote extends StatelessWidget {
  const _EmptyNote(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
    );
  }
}

/// A "label ... value" row, like the original's win-rate rows.
class _RateRow extends StatelessWidget {
  const _RateRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Semantics(
        label: '$label: $value',
        container: true,
        excludeSemantics: true,
        child: Row(
          children: [
            Expanded(child: Text(label)),
            Text(
              value,
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Win/loss records per team: yours ("Win rate by team"), or against
/// saved opponent teams ("Vs opponent teams").
class _RecordsCard extends StatelessWidget {
  const _RecordsCard({
    required this.title,
    required this.records,
    required this.emptyNote,
  });

  final String title;
  final List<TeamRecord> records;
  final String emptyNote;

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: title,
      child: records.isEmpty
          ? _EmptyNote(emptyNote)
          : Column(
              children: [
                for (final team in records)
                  _RateRow(
                    label: '${team.teamName} (${team.wins}-${team.losses})',
                    value: '${team.winRatePercent}%',
                  ),
              ],
            ),
    );
  }
}

/// Best-of-3 records: sets won and lost, game 1 against games 2–3, and
/// the most recent sets.
class _SetsCard extends StatelessWidget {
  const _SetsCard({required this.stats});

  final ProgressStats stats;

  @override
  Widget build(BuildContext context) {
    final decided = stats.setWinRatePercent;
    final game1 = stats.game1WinRatePercent;
    final later = stats.laterGamesWinRatePercent;
    return _Card(
      title: 'Best-of-3 sets',
      child: stats.recentSets.isEmpty
          ? const _EmptyNote(
              'Tick "Part of a best-of-3" when logging to track your sets.',
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (decided != null)
                  _RateRow(
                    label: 'Set record (${stats.setsWon}-${stats.setsLost})',
                    value: '$decided%',
                  ),
                if (game1 != null)
                  _RateRow(label: 'Game 1 win rate', value: '$game1%'),
                if (later != null)
                  _RateRow(label: 'Games 2–3 win rate', value: '$later%'),
                if (stats.unfinishedSets > 0)
                  _RateRow(
                    label: 'Unfinished sets',
                    value: '${stats.unfinishedSets}',
                  ),
                const SizedBox(height: 8),
                for (final set in stats.recentSets)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      set.label,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
              ],
            ),
    );
  }
}

class _OpponentLeadsCard extends StatelessWidget {
  const _OpponentLeadsCard({required this.stats});

  final ProgressStats stats;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<ProgressViewModel>();
    return _Card(
      title: 'Most common opponent leads',
      child: stats.opponentLeads.isEmpty
          ? const _EmptyNote('No opponent lead data logged yet.')
          : Column(
              children: [
                for (final lead in stats.opponentLeads)
                  _RateRow(
                    label:
                        '${viewModel.pokemonName(lead.slug)} '
                        '(seen ${lead.timesSeen}×)',
                    value: '${lead.winRatePercent}% win',
                  ),
              ],
            ),
    );
  }
}

class _MistakeBreakdownCard extends StatelessWidget {
  const _MistakeBreakdownCard({required this.stats});

  final ProgressStats stats;

  @override
  Widget build(BuildContext context) {
    final breakdown = stats.mistakeBreakdown;
    return _Card(
      title: 'Mistake breakdown',
      child: breakdown.isEmpty
          ? const _EmptyNote('No games logged yet.')
          : Column(
              children: [
                for (final entry in breakdown)
                  _MistakeBar(
                    label: entry.mistake.label,
                    count: entry.count,
                    // The list is sorted, so the first count is the largest.
                    fraction: entry.count / breakdown.first.count,
                  ),
              ],
            ),
    );
  }
}

/// A labelled bar: plain widgets, no chart package.
class _MistakeBar extends StatelessWidget {
  const _MistakeBar({
    required this.label,
    required this.count,
    required this.fraction,
  });

  final String label;
  final int count;
  final double fraction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = BorderRadius.circular(6);
    return Padding(
      key: const ValueKey('mistake-bar'),
      padding: const EdgeInsets.only(bottom: 10),
      // The bar only restates the count, so read just "label: count".
      child: Semantics(
        label: '$label: $count',
        container: true,
        excludeSemantics: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(child: Text(label, style: theme.textTheme.bodySmall)),
                Text('$count', style: theme.textTheme.bodySmall),
              ],
            ),
            const SizedBox(height: 4),
            DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorScheme.outlineVariant,
                borderRadius: radius,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: fraction,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: radius,
                    ),
                    child: const SizedBox(height: 8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Recent games, newest first: the first 15, then "Show all". Built lazily
/// so a long history stays cheap.
class _RecentGames extends StatefulWidget {
  const _RecentGames({required this.games});

  final List<GameLog> games;

  @override
  State<_RecentGames> createState() => _RecentGamesState();
}

class _RecentGamesState extends State<_RecentGames> {
  static const _initialCount = 15;
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final games = widget.games;
    final shown = _showAll
        ? games.length
        : games.length.clamp(0, _initialCount);
    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Recent games',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
        if (games.isEmpty)
          const SliverToBoxAdapter(child: _EmptyNote('No games logged yet.')),
        SliverList.builder(
          itemCount: shown,
          itemBuilder: (context, index) => _GameItem(game: games[index]),
        ),
        if (shown < games.length)
          SliverToBoxAdapter(
            child: TextButton(
              onPressed: () => setState(() => _showAll = true),
              child: Text('Show all (${games.length})'),
            ),
          ),
      ],
    );
  }
}

class _GameItem extends StatelessWidget {
  const _GameItem({required this.game});

  final GameLog game;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = context.read<ProgressViewModel>();
    String names(List<String> slugs) =>
        slugs.map(viewModel.pokemonName).join(', ');
    final meta = [viewModel.dateLabel(game), ?game.teamName].join(' · ');
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ResultBadge(result: game.result),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(meta, style: theme.textTheme.bodySmall),
                  if (game.brought.isNotEmpty)
                    Text(
                      'Brought: ${names(game.brought)} · '
                      'Leads: ${names(game.leads)}',
                      style: theme.textTheme.bodySmall,
                    ),
                  if (game.opponentTeam.isNotEmpty)
                    Text(
                      [
                        'Opp: ${names(game.opponentTeam)}',
                        if (game.opponentLeads.isNotEmpty)
                          'Opp leads: ${names(game.opponentLeads)}',
                      ].join(' · '),
                      style: theme.textTheme.bodySmall,
                    ),
                  if (game.mistake?.label ?? game.notes case final summary
                      when summary.isNotEmpty)
                    Text(summary),
                ],
              ),
            ),
            if (viewModel.canSaveOpponentTeam(game))
              IconButton(
                tooltip: 'Save their team',
                icon: const Icon(Icons.group_add_outlined),
                onPressed: () => _saveTheirTeam(context),
              ),
            IconButton(
              tooltip: 'Delete game',
              icon: const Icon(Icons.close),
              onPressed: () => _delete(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveTheirTeam(BuildContext context) async {
    final save = context.read<ProgressViewModel>().saveOpponentTeam;
    final messenger = ScaffoldMessenger.of(context);
    final name = await showDialog<String>(
      context: context,
      builder: (context) => const _TeamNameDialog(),
    );
    if (name == null) return;

    await save.execute((game: game, name: name));
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(switch (save.result) {
            Ok(value: final saved) => 'Saved $saved to Opponents',
            Failure(error: SaveOpponentTeamError(:final message)) => message,
            _ => "Couldn't save their team. Try again.",
          }),
        ),
      );
  }

  Future<void> _delete(BuildContext context) async {
    final viewModel = context.read<ProgressViewModel>();
    final messenger = ScaffoldMessenger.of(context);
    await viewModel.deleteGame.execute(game);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        viewModel.deleteGame.completed
            ? SnackBar(
                content: const Text('Game deleted'),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: viewModel.undoDelete.execute,
                ),
              )
            : const SnackBar(
                content: Text("Couldn't delete the game. Try again."),
              ),
      );
  }
}

/// Asks for the opponent team's name; pops with it, or null on Cancel.
class _TeamNameDialog extends StatefulWidget {
  const _TeamNameDialog();

  @override
  State<_TeamNameDialog> createState() => _TeamNameDialogState();
}

class _TeamNameDialogState extends State<_TeamNameDialog> {
  final _name = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Save their team'),
      content: TextField(
        controller: _name,
        autofocus: true,
        decoration: const InputDecoration(labelText: 'Team name'),
        onSubmitted: (name) => Navigator.pop(context, name),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _name.text),
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class _ResultBadge extends StatelessWidget {
  const _ResultBadge({required this.result});

  final GameResult result;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final win = result == GameResult.win;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: win ? colors.winSoft : colors.lossSoft,
        borderRadius: BorderRadius.circular(8),
      ),
      child: SizedBox.square(
        dimension: 30,
        child: Center(
          child: Text(
            win ? 'W' : 'L',
            style: TextStyle(
              color: win ? colors.win : colors.loss,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}
