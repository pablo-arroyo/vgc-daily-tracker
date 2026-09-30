/// One checklist item. [id] is stable, so saved ticks survive rewording.
class RoutineItem {
  const RoutineItem(this.id, this.text);

  final String id;
  final String text;
}

class RoutineSection {
  const RoutineSection(this.title, this.items);

  final String title;
  final List<RoutineItem> items;
}

/// The original tracker's routine, word for word, except that "below" now
/// names the tab it meant.
const routine = [
  RoutineSection('Before the game', [
    RoutineItem(
      'win-condition',
      "Say your team's win condition out loud — which two Pokémon actually "
          'win you the game?',
    ),
    RoutineItem(
      'bad-matchups',
      "Review your bad matchups: what beats you, and what's your plan when "
          'you see it at Team Preview?',
    ),
    RoutineItem(
      'reread-loss',
      "If you lost your last game, re-read that game's entry in Progress "
          'before queuing again.',
    ),
  ]),
  RoutineSection('During the game', [
    RoutineItem(
      'predict-lead',
      'At Team Preview: guess their likely lead and win condition before you '
          'pick your own bring/lead.',
    ),
    RoutineItem(
      'outsped-or-kod',
      'Before attacking, ask "what does this get outsped or KO\'d by right '
          'now?" — not just "what does this KO?"',
    ),
    RoutineItem(
      'protect-reason',
      'Before Protect-ing, have an actual reason (info, Fake Out bait, '
          'surviving a read) — not just default caution.',
    ),
    RoutineItem(
      'speed-order',
      'Check speed order before committing to a move you assume goes first.',
    ),
    RoutineItem(
      'no-throwaway',
      "Don't throw away a Pokémon for a KO you don't need this turn.",
    ),
  ]),
  RoutineSection('After the game', [
    RoutineItem(
      'log-fast',
      "Log the result in Log Game within a minute or two — while it's fresh, "
          'not at the end of the session.',
    ),
    RoutineItem(
      'decisive-moment',
      'Name ONE specific moment that decided the game, win or lose.',
    ),
    RoutineItem(
      'one-mistake',
      'If you lost, pick the single mistake category that mattered most — '
          'resist "everything went wrong."',
    ),
    RoutineItem(
      'opponent-team',
      "Jot down the opponent's full team from Team Preview — even a rough "
          'memory helps you spot recurring archetypes.',
    ),
  ]),
];
